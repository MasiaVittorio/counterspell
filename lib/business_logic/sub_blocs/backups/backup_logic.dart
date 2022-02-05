import 'package:counter_spell_new/core.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

export 'log.dart';
export 'past_games.dart';
export 'preferences.dart';
export 'directories.dart';

class CSBackupBloc {
  //===================================
  // Disposer
  void dispose() {
    savedPastGames.dispose();
    savedPreferences.dispose();
    ready.dispose();
    logs.dispose();
  }

  //===================================
  // Values
  final CSBloc parent;
  final BlocVar<List<File>> savedPastGames = BlocVar(<File>[]);
  final BlocVar<List<File>> savedPreferences = BlocVar(<File>[]);

  final PersistentVar<String> logs = PersistentVar(
    initVal: "",
    key: "cs bloc backup and restore logs",
  );

  final BlocVar<bool> ready = BlocVar<bool>(false);

  String? storagePath;
  Directory? backupsDirectory;
  Directory? pastGamesDirectory;
  Directory? preferencesDirectory;

  //===================================
  // Constructor
  CSBackupBloc(this.parent) {
    init();
  }

  //===================================
  // Init
  void init() async {
    if (await initDirectories()) {
      ready.set(true);
      this.initPastGames();
      this.initPreferences();
    }
  }

  List<File> jsonFilesInDirectory(Directory dir) => <File>[
        for (final entity in dir.listSync())
          if (entity is File)
            if (path.extension(entity.path) == ".json") entity,
      ]..sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
}
