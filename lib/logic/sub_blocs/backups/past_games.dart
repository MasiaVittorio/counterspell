// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'package:counter_spell_new/core.dart';

extension CSBackupPastGames on CSBackupBloc {
  void initPastGames() {
    if (!ready.value) return;
    final List<File> pastGames = jsonFilesInDirectory(pastGamesDirectory!);
    savedPastGames.set(pastGames);
  }

  //===================================
  // Methods
  Future<bool> savePastGames() async {
    final newFile = await createGamesBackup();
    if(newFile == null){
      return false;
    } else {
      savedPastGames.value.add(newFile);
      savedPastGames.refresh();
      return true;
    }
  }

  Future<File?> createGamesBackup() async {
    if (!ready.value) return null;

    final now = DateTime.now();
    File newFile = File(path.join(
      pastGamesDirectory!.path,
      "pg_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));

    int i = 0;
    while (await newFile.exists()) {
      ++i;
      String withoutExt = path.basenameWithoutExtension(newFile.path);
      newFile = File(path.join(
        pastGamesDirectory!.path,
        "${withoutExt}_($i).json",
      ));
      if (i == 100) {
        // print("100 files in the same second? wtf??");
        return null;
      }
    }

    newFile.create();

    await newFile.writeAsString(
      jsonEncode(
        [
          for (final game in parent.pastGames.pastGames.value)
            parent.pastGames.pastGames.itemToJson(
              game,
            ),
        ],
      ),
    );

    return newFile;
  }

  Future<bool> deletePastGame(int index) async {
    if (savedPastGames.value.checkIndex(index)) {
      final file = savedPastGames.value.removeAt(index);
      savedPastGames.refresh();
      await file.delete();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> loadPastGame(File file) async {

    final result = await readPastGames(file);
    
    final newPastGames = result.games;
    if(newPastGames == null || newPastGames.isEmpty){
      return false;
    }

    return await restorePastGames(newPastGames);
  }

  Future<bool> restorePastGames(List<PastGame> newPastGames) async {

    if(newPastGames.isEmpty) return false;

    final List<String> newStrings = <String>[
      for (final game in newPastGames) jsonEncode(game.toJson),
    ];

    final List<String> oldStrings = <String>[
      for (final game in parent.pastGames.pastGames.value)
        jsonEncode(game!.toJson),
    ];

    final Set<String> allStrings = <String>{
      ...oldStrings,
      ...newStrings,
    };

    final List<PastGame> allNewGames = <PastGame>[
      for (final string in allStrings) PastGame.fromJson(jsonDecode(string)),
    ]..sort(
        (one, two) => one.startingDateTime.compareTo(two.startingDateTime),
      );

    parent.pastGames.pastGames.set(allNewGames);

    return true;
  }

  Future<ReadPastGamesResult> readPastGames(File file) async {
    
    if (!ready.value) {
      return ReadPastGamesResult(
        errorMessage: "Backups logic not ready",
      );
    }
    if (!(await Permission.storage.isGranted)) {
      return ReadPastGamesResult(
        errorMessage: "Storage permission not granted",
      );
    }

    late dynamic decoded;
    bool error = false;
    try {
      String content = await file.readAsString();
      decoded = jsonDecode(content);
    } catch (e) {
      error = true;
    }

    if (decoded == null || error) {
      return ReadPastGamesResult(
        errorMessage: "Error reading the file",
      );
    }

    if (decoded is List) {
      /// try to decode them to past game object to check if they are
      
      bool errorParsingJson = false;
      List<PastGame>? newPastGames;
      try {
        newPastGames = <PastGame>[
          for (final json in decoded) PastGame.fromJson(json)
        ];
      } catch (e) {
        errorParsingJson = true;
      }
      if(errorParsingJson || newPastGames == null){
        return ReadPastGamesResult(
          errorMessage: "Error parsing past games",
        );
      }

      return ReadPastGamesResult(
        games: newPastGames,
      );

    } else {
      return ReadPastGamesResult(
        errorMessage: "Wrong file contents",
      );
    }
  }
}

class ReadPastGamesResult {
  final List<PastGame>? games;
  final String? errorMessage;

  ReadPastGamesResult({
    this.games,
    this.errorMessage,
  });

  bool get error => errorMessage != null || games == null;
  bool get empty => games?.isEmpty ?? false;
  bool get notEmpty => games?.isNotEmpty ?? false;
}
