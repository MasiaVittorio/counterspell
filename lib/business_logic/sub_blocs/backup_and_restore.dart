// import 'package:counter_spell_new/core.dart';

// class CSBackupBloc {
//   final CSBloc parent;

//   CSBackupBloc(this.parent);

//   void dispose(){}
// }


import 'dart:convert';
import 'dart:io';

import 'package:counter_spell_new/core.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:path/path.dart' as path;

class CSBackupBloc {

  //===================================
  // Disposer
  void dispose(){
    this.savedPastGames.dispose();
    this.ready.dispose();
  } 

  //===================================
  // Values
  final CSBloc parent;
  final BlocVar<List<File>> savedPastGames 
    = BlocVar<List<File>>(<File>[]);
  final BlocVar<List<File>> savedPreferences 
    = BlocVar<List<File>>(<File>[]);

  final BlocVar<bool> ready = BlocVar<bool>(false);

  String? storagePath;
  Directory? csDirectory;
  Directory? pastGamesDirectory;
  Directory? preferencesDirectory;

  //===================================
  // Constructor
  CSBackupBloc(this.parent){
    init();
  }

  //===================================
  // Init
  void init() async {
    if(await initDirectories()){
      ready.set(true);
      this.initPastGames();
      this.initPreferences();
    }
  }

  Future<bool> initDirectories() async {

    if(!(await Permission.storage.status.isGranted)){
      return false;
    }

    try {
      this.storagePath = await getStoragePath;
      if(storagePath == null) return false;

      this.csDirectory = await getCSDirectory(
        csDirPath(storagePath!),
      );
      if(csDirectory == null) return false;

      this.pastGamesDirectory = await getPastGamesDirectory(
        this.csDirectory!,
      );
      if(pastGamesDirectory == null) return false;

      this.preferencesDirectory = await getPreferencesDirectory(
        this.csDirectory!,
      );
      if(preferencesDirectory == null) return false;

    } catch (e) {
      return false;
    }

    return true;
  }

  void initPastGames() {
    if(!ready.value) return;
    final List<File> _pastGames = jsonFilesInDirectory(pastGamesDirectory!);
    this.savedPastGames.set(_pastGames);
  }

  void initPreferences() {
    if(!ready.value) return;
    final List<File> _preferences = jsonFilesInDirectory(preferencesDirectory!);
    this.savedPreferences.set(_preferences);
  }

  //===================================
  // Getters
  static const String csDirName = "CounterSpell";
  static Future<String> get getStoragePath async {
    final List list = await  ExternalPath.getExternalStorageDirectories();

    if(list.isNotEmpty) return list.first;
    return "error";
    // return "/storage/emulated/0";
  }

  static String csDirPath(String _storagePath) => path.join(
    _storagePath,
    csDirName,
  );

  static Future<Directory> getCSDirectory(String _csDirPath) async {
    Directory dir = Directory(_csDirPath);
    if(!await dir.exists()){
      dir = await dir.create(recursive: true);
    }
    return dir;
  }

  static const String pastGamesDirName = "PastGames";
  static Future<Directory> getPastGamesDirectory(Directory _csDirectory) async {
    Directory dir =  Directory(path.join(
      _csDirectory.path,
      pastGamesDirName,
    ));
    if(!await dir.exists()){
      dir = await dir.create(recursive: true);
    }
    return dir;
  }
  static const String preferencesDirName = "Preferences";
  static Future<Directory> getPreferencesDirectory(Directory _csDirectory) async {
    Directory dir =  Directory(path.join(
      _csDirectory.path,
      preferencesDirName,
    ));
    if(!await dir.exists()){
      dir = await dir.create(recursive: true);
    }
    return dir;
  }

  static List<File> jsonFilesInDirectory(Directory dir) => <File>[
    for(final entity in dir.listSync())
      if(entity is File)
        if(path.extension(entity.path) == ".json")
          entity,
  ]..sort((a,b) => a.lastModifiedSync()
        .compareTo(b.lastModifiedSync())
  );
  
  // static String fileName(File file) => path.basename(file.path);


  //===================================
  // Methods
  

  Future<bool> savePastGames() async {
    if(!ready.value) return false;

    final now = DateTime.now();
    File newFile = File(path.join(
      this.pastGamesDirectory!.path,
      "pg_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));
    
    int i = 0;
    while(await newFile.exists()){
      ++i;
      String withoutExt = path.basenameWithoutExtension(newFile.path);
      newFile = File(path.join(
        this.pastGamesDirectory!.path,
        withoutExt + "_($i).json",
      ));
      if(i == 100){
        print("100 files in the same second? wtf??");
        return false;
      }
    }

    newFile.create();

    await newFile.writeAsString(jsonEncode([
      for(final game in parent.pastGames.pastGames.value)
        parent.pastGames.pastGames.itemToJson(
          game,
        ),
    ],),);

    this.savedPastGames.value.add(newFile);
    this.savedPastGames.refresh();

    return true;
  }

  Future<bool> deletePastGame(int index) async {
    if(this.savedPastGames.value.checkIndex(index)){
      final file = this.savedPastGames.value.removeAt(index);
      this.savedPastGames.refresh();
      await file.delete();
      return true;
    } else return false;
  }

  Future<bool> loadPastGame(File file) async {
    if(!ready.value) return false;
    if(!(await Permission.storage.isGranted)) return false;

    late dynamic decoded;
    bool error = false;
    try {
      String content = await file.readAsString();
      decoded = jsonDecode(content);
    } catch (e) {
      error = true;
    }

    if(decoded == null || error) return false;

    if(decoded is List){

      /// try to decode them to past game object to check if they are
      final List<PastGame> newPastGames = <PastGame>[
        for(final json in decoded)
          PastGame.fromJson(json)
      ];

      final List<String> newStrings = <String>[
        for(final game in newPastGames)
          jsonEncode(game.toJson),
      ];

      final List<String> oldStrings = <String>[
        for(final game in parent.pastGames.pastGames.value)
          jsonEncode(game!.toJson),
      ];

      final Set<String> allStrings = <String>{
        ...oldStrings,
        ...newStrings,
      };

      final List<PastGame> allNewGames = <PastGame>[
        for(final string in allStrings)
          PastGame.fromJson(jsonDecode(string)),
      ]..sort((one, two) 
        => one.startingDateTime.compareTo(
          two.startingDateTime
        ),
      );

      parent.pastGames.pastGames.set(allNewGames);

    } else return false;

    return true;
  }


  Future<bool> savePreferences() async {
    if(!ready.value) return false;

    final now = DateTime.now();
    File newFile = File(path.join(
      this.preferencesDirectory!.path,
      "pr_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));
    
    int i = 0;
    while(await newFile.exists()){
      ++i;
      String withoutExt = path.basenameWithoutExtension(newFile.path);
      newFile = File(path.join(
        this.preferencesDirectory!.path,
        withoutExt + "_($i).json",
      ));
      if(i == 100){
        print("100 files in the same second? wtf??");
        return false;
      }
    }

    newFile.create();

    final settings = parent.settings;
    final arena = settings.arenaSettings;
    final gameSettings = settings.gameSettings;
    final app = settings.appSettings;
    final scroll = settings.scrollSettings;
    final game = parent.game;
    final group = game.gameGroup;
    final themer = parent.themer;

    await newFile.writeAsString(jsonEncode(<String,dynamic>{
      themer.savedSchemes.key:
        <String,Map<String,dynamic>>{
          for(final e in themer.savedSchemes.value.entries)
            e.key: e.value.toJson,
        },

      group.savedNames.key // Set<String> ->
        : group.savedNames.value.toList(), // List<String>

      gameSettings.timeMode.key: // TimeMode ->
        TimeModes.nameOf(gameSettings.timeMode.value), // String (nameOf)

      app.alwaysOnDisplay.key:
        app.alwaysOnDisplay.value, // bool

      app.wantVibrate.key:
        app.wantVibrate.value, // bool

      arena.scrollOverTap.key:
        arena.scrollOverTap.value, // bool

      arena.verticalScroll.key:
        arena.verticalScroll.value, // bool

      arena.verticalTap.key:
        arena.verticalTap.value, // bool

      scroll.confirmDelay.key: // Duration ->
        scroll.confirmDelay.value.inMilliseconds, // int (milliseconds)

      scroll.scrollSensitivity.key:
        scroll.scrollSensitivity.value, // double

      scroll.scroll1Static.key:
        scroll.scroll1Static.value, // bool

      scroll.scroll1StaticValue.key:
        scroll.scroll1StaticValue.value, // double

      scroll.scrollDynamicSpeed.key:
        scroll.scrollDynamicSpeed.value, // bool

      scroll.scrollDynamicSpeedValue.key:
        scroll.scrollDynamicSpeedValue.value, // double

      scroll.scrollPreBoost.key:
        scroll.scrollPreBoost.value, //bool

      scroll.scrollPreBoostValue.key:
        scroll.scrollPreBoostValue.value, //double

    }),);


    this.savedPreferences.value.add(newFile);
    this.savedPreferences.refresh();

    return true;
  }


  Future<bool> deletePreference(int index) async {
    if(this.savedPreferences.value.checkIndex(index)){
      final file = this.savedPreferences.value.removeAt(index);
      this.savedPreferences.refresh();
      await file.delete();
      return true;
    } else return false;
  }


  Future<bool> loadPreferences(File file) async {
    if(!ready.value) return false;
    if(!(await Permission.storage.isGranted)) return false;

    try {
      String content = await file.readAsString();

      dynamic map = jsonDecode(content);

      if(map is Map){

        final settings = parent.settings;
        final arena = settings.arenaSettings;
        final gameSettings = settings.gameSettings;
        final app = settings.appSettings;
        final scroll = settings.scrollSettings;
        final game = parent.game;
        final group = game.gameGroup;
        final themer = parent.themer;

        {final blocVar = themer.savedSchemes;
        final _val = map[blocVar.key];
        if(_val is Map){
          for(final e in _val.entries){
            if(e.key is String)
            if(e.value is Map)
              blocVar.value[e.key] 
                = CSColorScheme.fromJson(e.value);
          }
          blocVar.refresh();
        }}

        {final blocVar = group.savedNames; 
        final _val = map[blocVar.key];
        if(_val is List){
          for(final name in _val){
            if(name is String)
              blocVar.value.add(name);
          }
          blocVar.refresh();
        }}

        {final blocVar = gameSettings.timeMode; 
        final _val = map[blocVar.key];
        if(_val is String){
          if(TimeModes.reversed.containsKey(_val)){
            blocVar.set(TimeModes.fromName(_val));
          }
        }}

        {final blocVar = app.alwaysOnDisplay; 
        final _val = map[blocVar.key];
        if(_val is bool){
          blocVar.set(_val);
        }}

        {final blocVar = app.wantVibrate; 
        final _val = map[blocVar.key];
        if(_val is bool){
          blocVar.set(_val);
        }}

        {final blocVar = arena.scrollOverTap; 
        final _val = map[blocVar.key];
        if(_val is bool){
          blocVar.set(_val);
        }}

        {final blocVar = arena.verticalScroll; 
        final _val = map[blocVar.key];
        if(_val is bool){
          blocVar.set(_val);
        }}


        {final blocVar = arena.verticalTap; 
        final _val = map[blocVar.key];
        if(_val is bool){
          blocVar.set(_val);
        }}

        {final blocVar = scroll.confirmDelay; 
        final _val = map[blocVar.key];
        if(_val is int){
          blocVar.set(Duration(milliseconds: _val));
        }}

        {final blocVar = scroll.scrollSensitivity; 
        final _val = map[blocVar.key];
        if(_val is double){
          blocVar.set(_val);
        }}

        {final blocVar = scroll.scroll1StaticValue; 
        final _val = map[blocVar.key];
        if(_val is double){
          blocVar.set(_val);
        }}

        {final blocVar = scroll.scrollDynamicSpeedValue; 
        final _val = map[blocVar.key];
        if(_val is double){
          blocVar.set(_val);
        }}

        {final blocVar = scroll.scrollPreBoostValue; 
        final _val = map[blocVar.key];
        if(_val is double){
          blocVar.set(_val);
        }}

        {final blocVar = scroll.scroll1Static; 
        final _val = map[blocVar.key];
        if(_val is bool){
          blocVar.set(_val);
        }}

        {final blocVar = scroll.scrollDynamicSpeed; 
        final _val = map[blocVar.key];
        if(_val is bool){
          blocVar.set(_val);
        }}
        
        {final blocVar = scroll.scrollPreBoost; 
        final _val = map[blocVar.key];
        if(_val is bool){
          blocVar.set(_val);
        }}

      } else return false;

    } catch (e) {
      return false;
    }

    return true;
  }

}



const problem = """
{"winner":"Umberto","notes":"","state":{"players":{"Vittorio":{"name":"Vittorio","havePartnerB":false,"usePartnerB":false,"commanderSettingsA":{"lifelink":false,"damageDefendersLife":true,"infect":false},"commanderSettingsB":{"lifelink":false,"damageDefendersLife":true,"infect":false},"states":[{"life":-1,"time":"2021-07-04 22:19:53.321076","cast":[0,0],"damages":{"Vittorio":[0,0],"Chicco":[11,0],"Umberto":[5,0]},"counters":{"Poison Counters":0,"Experience Counters":0,"Storm Count":0,"Total Mana":0,"City's Blessing":0,"Take the Crown":0,"Energy Counters":0}}]},"Chicco":{"name":"Chicco","havePartnerB":false,"usePartnerB":false,"commanderSettingsA":{"lifelink":false,"damageDefendersLife":true,"infect":false},"commanderSettingsB":{"lifelink":false,"damageDefendersLife":true,"infect":false},"states":[{"life":8,"time":"2021-07-04 22:19:53.321080","cast":[0,0],"damages":{"Vittorio":[0,0],"Chicco":[0,0],"Umberto":[12,0]},"counters":{"Poison Counters":0,"Experience Counters":0,"Storm Count":0,"Total Mana":0,"City's Blessing":0,"Take the Crown":0,"Energy Counters":0}}]},"Umberto":{"name":"Umberto","havePartnerB":false,"usePartnerB":false,"commanderSettingsA":{"lifelink":false,"damageDefendersLife":true,"infect":false},"commanderSettingsB":{"lifelink":false,"damageDefendersLife":true,"infect":false},"states":[{"life":71,"time":"2021-07-04 22:19:53.321081","cast":[0,0],"damages":{"Vittorio":[0,0],"Chicco":[0,0],"Umberto":[0,0]},"counters":{"Poison Counters":0,"Experience Counters":0,"Storm Count":0,"Total Mana":0,"City's Blessing":0,"Take the Crown":0,"Energy Counters":0}}]}}},"dateTime":1625428740821,"commandersA":{"Vittorio":{"object":"card","id":"ced8571a-24e1-45be-8698-3314b663940a","oracle_id":"92023a5d-a143-4950-a71b-d736e6b8e959","multiverse_ids":[507666,507665],"mtgo_id":null,"mtgo_foil_id":null,"tcgplayer_id":230289,"name":"Esika, God of the Tree // The Prismatic Bridge","lang":"en","released_at":"2021-02-05","uri":"https://api.scryfall.com/cards/ced8571a-24e1-45be-8698-3314b663940a","scryfall_uri":"https://scryfall.com/card/khm/314/esika-god-of-the-tree-the-prismatic-bridge?utm_source=api","layout":null,"highres_image":true,"image_uris":null,"mana_cost":null,"cmc":3.0,"type_line":"Legendary Creature — God // Legendary Enchantment","oracle_text":null,"colors":null,"color_identity":["B","G","R","U","W"],"legalities":{"standard":"legal","future":"legal","frontier":null,"modern":"legal","legacy":"legal","pauper":"not_legal","vintage":"legal","penny":"not_legal","commander":"legal","duel":"legal","oldschool":"not_legal"},"games":["arena","paper","mtgo"],"reserved":false,"foil":true,"nonfoil":true,"oversized":false,"promo":false,"reprint":false,"set":"khm","set_name":"Kaldheim","set_uri":"https://api.scryfall.com/sets/43057fad-b1c1-437f-bc48-0045bce6d8c9","set_search_uri":"https://api.scryfall.com/cards/search?order=set&q=e%3Akhm&unique=prints","scryfall_set_uri":"https://scryfall.com/sets/khm?utm_source=api","rulings_uri":"https://api.scryfall.com/cards/ced8571a-24e1-45be-8698-3314b663940a/rulings","prints_search_uri":"https://api.scryfall.com/cards/search?order=released&q=oracleid%3A92023a5d-a143-4950-a71b-d736e6b8e959&unique=prints","collector_number":"314","digital":false,"rarity":"mythic","flavor_text":null,"illustration_id":null,"artist":"Collin Estrada","border_color":"black","frame":"2015","frame_effect":null,"full_art":false,"story_spotlight":false,"edhrec_rank":3764,"related_uris":{"gatherer":"https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=507666","tcgplayer_decks":null,"edhrec":"https://edhrec.com/route/?cc=Esika%2C+God+of+the+Tree","mtgtop8":"https://mtgtop8.com/search?MD_check=1&SB_check=1&cards=Esika%2C+God+of+the+Tree"},"power":null,"toughness":null,"arena_id":75420,"watermark":null,"all_parts":null,"card_faces":[{"object":"card_face","name":"Esika, God of the Tree","mana_cost":"{1}{G}{G}","type_line":"Legendary Creature — God","oracle_text":"Vigilance\n{T}: Add one mana of any color.\nOther legendary creatures you control have vigilance and \"{T}: Add one mana of any color.\"","colors":["G"],"power":"1","toughness":"4","artist":"Collin Estrada","illustration_id":"ea8db8f5-415a-4c32-81c9-fb182733edd2","image_uris":{"small":"https://c1.scryfall.com/file/scryfall-cards/small/front/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349","normal":"https://c1.scryfall.com/file/scryfall-cards/normal/front/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349","large":"https://c1.scryfall.com/file/scryfall-cards/large/front/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349","png":"https://c1.scryfall.com/file/scryfall-cards/png/front/c/e/ced8571a-24e1-45be-8698-3314b663940a.png?1615650349","art_crop":"https://c1.scryfall.com/file/scryfall-cards/art_crop/front/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349","border_crop":"https://c1.scryfall.com/file/scryfall-cards/border_crop/front/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349"},"watermark":null,"color_indicator":null,"flavor_text":null,"loyalty":null},{"object":"card_face","name":"The Prismatic Bridge","mana_cost":"{W}{U}{B}{R}{G}","type_line":"Legendary Enchantment","oracle_text":"At the beginning of your upkeep, reveal cards from the top of your library until you reveal a creature or planeswalker card. Put that card onto the battlefield and the rest on the bottom of your library in a random order.","colors":["B","G","R","U","W"],"power":null,"toughness":null,"artist":"Collin Estrada","illustration_id":"cec1e872-2d6e-49ca-8935-12f05e1a017d","image_uris":{"small":"https://c1.scryfall.com/file/scryfall-cards/small/back/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349","normal":"https://c1.scryfall.com/file/scryfall-cards/normal/back/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349","large":"https://c1.scryfall.com/file/scryfall-cards/large/back/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349","png":"https://c1.scryfall.com/file/scryfall-cards/png/back/c/e/ced8571a-24e1-45be-8698-3314b663940a.png?1615650349","art_crop":"https://c1.scryfall.com/file/scryfall-cards/art_crop/back/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349","border_crop":"https://c1.scryfall.com/file/scryfall-cards/border_crop/back/c/e/ced8571a-24e1-45be-8698-3314b663940a.jpg?1615650349"},"watermark":null,"color_indicator":null,"flavor_text":null,"loyalty":null}],"life_modifier":null,"hand_modifier":null,"loyalty":null,"color_indicator":null,"prices":{"usd":"8.94","usd_foil":"25.39","eur":null,"tix":null},"purchase_uris":{"tcgplayer":"https://shop.tcgplayer.com/product/productsearch?id=230289&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall","cardmarket":"https://www.cardmarket.com/en/Magic/Products/Search?referrer=scryfall&searchString=Esika%2C+God+of+the+Tree&utm_campaign=card_prices&utm_medium=text&utm_source=scryfall","cardhoarder":"https://www.cardhoarder.com/cards?affiliate_id=scryfall&data%5Bsearch%5D=Esika%2C+God+of+the+Tree&ref=card-profile&utm_campaign=affiliate&utm_medium=card&utm_source=scryfall"}},"Chicco":{"object":"card","id":"fc0969f1-92a0-47c3-8eff-d106fbef2f7e","oracle_id":"9f7d5e1c-bf5b-4ab9-bd6e-2627b4d22b36","multiverse_ids":[402100],"mtgo_id":58559,"mtgo_foil_id":58560,"tcgplayer_id":104815,"name":"Zada, Hedron Grinder","lang":"en","released_at":"2015-10-02","uri":"https://api.scryfall.com/cards/fc0969f1-92a0-47c3-8eff-d106fbef2f7e","scryfall_uri":"https://scryfall.com/card/bfz/162/zada-hedron-grinder?utm_source=api","layout":"normal","highres_image":true,"image_uris":{"small":"https://c1.scryfall.com/file/scryfall-cards/small/front/f/c/fc0969f1-92a0-47c3-8eff-d106fbef2f7e.jpg?1562954742","normal":"https://c1.scryfall.com/file/scryfall-cards/normal/front/f/c/fc0969f1-92a0-47c3-8eff-d106fbef2f7e.jpg?1562954742","large":"https://c1.scryfall.com/file/scryfall-cards/large/front/f/c/fc0969f1-92a0-47c3-8eff-d106fbef2f7e.jpg?1562954742","png":"https://c1.scryfall.com/file/scryfall-cards/png/front/f/c/fc0969f1-92a0-47c3-8eff-d106fbef2f7e.png?1562954742","art_crop":"https://c1.scryfall.com/file/scryfall-cards/art_crop/front/f/c/fc0969f1-92a0-47c3-8eff-d106fbef2f7e.jpg?1562954742","border_crop":"https://c1.scryfall.com/file/scryfall-cards/border_crop/front/f/c/fc0969f1-92a0-47c3-8eff-d106fbef2f7e.jpg?1562954742"},"mana_cost":"{3}{R}","cmc":4.0,"type_line":"Legendary Creature — Goblin Ally","oracle_text":"Whenever you cast an instant or sorcery spell that targets only Zada, Hedron Grinder, copy that spell for each other creature you control that the spell could target. Each copy targets a different one of those creatures.","colors":["R"],"color_identity":["R"],"legalities":{"standard":"not_legal","future":"not_legal","frontier":null,"modern":"legal","legacy":"legal","pauper":"not_legal","vintage":"legal","penny":"legal","commander":"legal","duel":"legal","oldschool":"not_legal"},"games":["paper","mtgo"],"reserved":false,"foil":true,"nonfoil":true,"oversized":false,"promo":false,"reprint":false,"set":"bfz","set_name":"Battle for Zendikar","set_uri":"https://api.scryfall.com/sets/91719374-7ac5-4afa-ada8-5da964dcf1d4","set_search_uri":"https://api.scryfall.com/cards/search?order=set&q=e%3Abfz&unique=prints","scryfall_set_uri":"https://scryfall.com/sets/bfz?utm_source=api","rulings_uri":"https://api.scryfall.com/cards/fc0969f1-92a0-47c3-8eff-d106fbef2f7e/rulings","prints_search_uri":"https://api.scryfall.com/cards/search?order=released&q=oracleid%3A9f7d5e1c-bf5b-4ab9-bd6e-2627b4d22b36&unique=prints","collector_number":"162","digital":false,"rarity":"rare","flavor_text":"\"A hedron holds magic for a thousand years—or less, if need be.\"","illustration_id":"5fdbbe88-4f43-4723-90f3-51a81e1c2675","artist":"Chris Rallis","border_color":"black","frame":"2015","frame_effect":null,"full_art":false,"story_spotlight":false,"edhrec_rank":1976,"related_uris":{"gatherer":"https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=402100","tcgplayer_decks":"https://decks.tcgplayer.com/magic/deck/search?contains=Zada%2C+Hedron+Grinder&page=1&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall","edhrec":"https://edhrec.com/route/?cc=Zada%2C+Hedron+Grinder","mtgtop8":"https://mtgtop8.com/search?MD_check=1&SB_check=1&cards=Zada%2C+Hedron+Grinder"},"power":"3","toughness":"3","arena_id":null,"watermark":null,"all_parts":null,"card_faces":null,"life_modifier":null,"hand_modifier":null,"loyalty":null,"color_indicator":null,"prices":{"usd":"0.27","usd_foil":"1.93","eur":"0.19","tix":"0.01"},"purchase_uris":{"tcgplayer":"https://shop.tcgplayer.com/product/productsearch?id=104815&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall","cardmarket":"https://www.cardmarket.com/en/Magic/Products/Singles/Battle-for-Zendikar/Zada-Hedron-Grinder?referrer=scryfall&utm_campaign=card_prices&utm_medium=text&utm_source=scryfall","cardhoarder":"https://www.cardhoarder.com/cards/58559?affiliate_id=scryfall&ref=card-profile&utm_campaign=affiliate&utm_medium=card&utm_source=scryfall"}},"Umberto":{"object":"card","id":"1e90c638-d4b2-4243-bbc4-1cc10516c40f","oracle_id":"e7fc5ad6-f2f0-4b06-a61b-05022db9d93b","multiverse_ids":[447348],"mtgo_id":68585,"mtgo_foil_id":null,"tcgplayer_id":169246,"name":"Arcades, the Strategist","lang":"en","released_at":"2018-07-13","uri":"https://api.scryfall.com/cards/1e90c638-d4b2-4243-bbc4-1cc10516c40f","scryfall_uri":"https://scryfall.com/card/m19/212/arcades-the-strategist?utm_source=api","layout":"normal","highres_image":true,"image_uris":{"small":"https://c1.scryfall.com/file/scryfall-cards/small/front/1/e/1e90c638-d4b2-4243-bbc4-1cc10516c40f.jpg?1562300781","normal":"https://c1.scryfall.com/file/scryfall-cards/normal/front/1/e/1e90c638-d4b2-4243-bbc4-1cc10516c40f.jpg?1562300781","large":"https://c1.scryfall.com/file/scryfall-cards/large/front/1/e/1e90c638-d4b2-4243-bbc4-1cc10516c40f.jpg?1562300781","png":"https://c1.scryfall.com/file/scryfall-cards/png/front/1/e/1e90c638-d4b2-4243-bbc4-1cc10516c40f.png?1562300781","art_crop":"https://c1.scryfall.com/file/scryfall-cards/art_crop/front/1/e/1e90c638-d4b2-4243-bbc4-1cc10516c40f.jpg?1562300781","border_crop":"https://c1.scryfall.com/file/scryfall-cards/border_crop/front/1/e/1e90c638-d4b2-4243-bbc4-1cc10516c40f.jpg?1562300781"},"mana_cost":"{1}{G}{W}{U}","cmc":4.0,"type_line":"Legendary Creature — Elder Dragon","oracle_text":"Flying, vigilance\nWhenever a creature with defender enters the battlefield under your control, draw a card.\nEach creature you control with defender assigns combat damage equal to its toughness rather than its power and can attack as though it didn't have defender.","colors":["G","U","W"],"color_identity":["G","U","W"],"legalities":{"standard":"not_legal","future":"not_legal","frontier":null,"modern":"legal","legacy":"legal","pauper":"not_legal","vintage":"legal","penny":"not_legal","commander":"legal","duel":"legal","oldschool":"not_legal"},"games":["arena","paper","mtgo"],"reserved":false,"foil":true,"nonfoil":true,"oversized":false,"promo":false,"reprint":false,"set":"m19","set_name":"Core Set 2019","set_uri":"https://api.scryfall.com/sets/2f5f2509-56db-414d-9a7e-6e312ec3760c","set_search_uri":"https://api.scryfall.com/cards/search?order=set&q=e%3Am19&unique=prints","scryfall_set_uri":"https://scryfall.com/sets/m19?utm_source=api","rulings_uri":"https://api.scryfall.com/cards/1e90c638-d4b2-4243-bbc4-1cc10516c40f/rulings","prints_search_uri":"https://api.scryfall.com/cards/search?order=released&q=oracleid%3Ae7fc5ad6-f2f0-4b06-a61b-05022db9d93b&unique=prints","collector_number":"212","digital":false,"rarity":"mythic","flavor_text":null,"illustration_id":"12bdd526-f045-4779-83cb-ce2146c15cba","artist":"Even Amundsen","border_color":"black","frame":"2015","frame_effect":null,"full_art":false,"story_spotlight":false,"edhrec_rank":2340,"related_uris":{"gatherer":"https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=447348","tcgplayer_decks":"https://decks.tcgplayer.com/magic/deck/search?contains=Arcades%2C+the+Strategist&page=1&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall","edhrec":"https://edhrec.com/route/?cc=Arcades%2C+the+Strategist","mtgtop8":"https://mtgtop8.com/search?MD_check=1&SB_check=1&cards=Arcades%2C+the+Strategist"},"power":"3","toughness":"5","arena_id":68104,"watermark":null,"all_parts":null,"card_faces":null,"life_modifier":null,"hand_modifier":null,"loyalty":null,"color_indicator":null,"prices":{"usd":"6.84","usd_foil":"17.66","eur":"5.31","tix":"0.51"},"purchase_uris":{"tcgplayer":"https://shop.tcgplayer.com/product/productsearch?id=169246&utm_campaign=affiliate&utm_medium=api&utm_source=scryfall","cardmarket":"https://www.cardmarket.com/en/Magic/Products/Singles/Core-2019/Arcades-the-Strategist?referrer=scryfall&utm_campaign=card_prices&utm_medium=text&utm_source=scryfall","cardhoarder":"https://www.cardhoarder.com/cards/68585?affiliate_id=scryfall&ref=card-profile&utm_campaign=affiliate&utm_medium=card&utm_source=scryfall"}}},"commandersB":{"Vittorio":null,"Chicco":null,"Umberto":null},"customStats":{"Turn 1 Sol Ring":[],"Cycloninc Rift":[],"Lab man":[]}}
""";