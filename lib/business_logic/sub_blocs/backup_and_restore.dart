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

  final BlocVar<bool> ready = BlocVar<bool>(false);

  String storagePath;
  Directory csDirectory;
  Directory pastGamesDirectory;

  //===================================
  // Constructor
  CSBackupBloc(this.parent){
    init();
  }

  //===================================
  // Init
  void init() async {
    if(await initDirectoriesAndFiles()){
      ready.set(true);
      this.initPastGames();
    }
  }

  Future<bool> initDirectoriesAndFiles() async {

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

    } catch (e) {
      return false;
    }

    return true;
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
  
  void initPastGames() {
    if(!ready.value) return;
    final List<File> _pastGames = jsonFilesInDirectory(pastGamesDirectory);
    if(_pastGames == null) return;
    this.savedPastGames.set(_pastGames);
  }


  Future<bool> savePastGames() async {
    if(!ready.value) return false;

    final now = DateTime.now();
    File newFile = File(path.join(
      this.pastGamesDirectory.path,
      "past_games_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));
    
    int i = 0;
    while(await newFile.exists()){
      String withoutExt = path.basenameWithoutExtension(newFile.path);
      newFile = File(path.join(
        this.pastGamesDirectory.path,
        withoutExt + "${++i}.json",
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


}