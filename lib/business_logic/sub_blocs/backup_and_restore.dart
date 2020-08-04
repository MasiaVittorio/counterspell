import 'dart:convert';
import 'dart:io';

import 'package:counter_spell_new/core.dart';
import 'package:ext_storage/ext_storage.dart';
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

  String storagePath;
  Directory csDirectory;
  Directory pastGamesDirectory;
  Directory preferencesDirectory;

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
        csDirPath(storagePath),
      );
      if(csDirectory == null) return false;

      this.pastGamesDirectory = await getPastGamesDirectory(
        this.csDirectory,
      );
      if(pastGamesDirectory == null) return false;

      this.preferencesDirectory = await getPreferencesDirectory(
        this.csDirectory,
      );
      if(preferencesDirectory == null) return false;

    } catch (e) {
      return false;
    }

    return true;
  }

  void initPastGames() {
    if(!ready.value) return;
    final List<File> _pastGames = jsonFilesInDirectory(pastGamesDirectory);
    if(_pastGames == null) return;
    this.savedPastGames.set(_pastGames);
  }

  void initPreferences() {
    if(!ready.value) return;
    final List<File> _preferences = jsonFilesInDirectory(preferencesDirectory);
    if(_preferences == null) return;
    this.savedPreferences.set(_preferences);
  }

  //===================================
  // Getters
  static const String csDirName = "CounterSpell";
  static Future<String> get getStoragePath => ExtStorage.getExternalStorageDirectory();

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
      this.pastGamesDirectory.path,
      "pg_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));
    
    int i = 0;
    while(await newFile.exists()){
      ++i;
      String withoutExt = path.basenameWithoutExtension(newFile.path);
      newFile = File(path.join(
        this.pastGamesDirectory.path,
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

    try {
      String content = await file.readAsString();

      dynamic decoded = jsonDecode(content);

      if(decoded is List){
        /// try to decode them to past game object to check if they are
        final List<PastGame> newPastGames = <PastGame>[
          for(final json in decoded)
            PastGame.fromJson(json),
        ];

        final List<String> newStrings = <String>[
          for(final game in newPastGames)
            jsonEncode(game.toJson),
        ];

        final List<String> oldStrings = <String>[
          for(final game in parent.pastGames.pastGames.value)
            jsonEncode(game.toJson),
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

    } catch (e) {
      return false;
    }

    return true;
  }


  Future<bool> savePreferences() async {
    if(!ready.value) return false;

    final now = DateTime.now();
    File newFile = File(path.join(
      this.preferencesDirectory.path,
      "pr_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));
    
    int i = 0;
    while(await newFile.exists()){
      ++i;
      String withoutExt = path.basenameWithoutExtension(newFile.path);
      newFile = File(path.join(
        this.preferencesDirectory.path,
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