import 'dart:io';
import 'dart:convert';

import 'package:path/path.dart' as path;

import 'package:counter_spell_new/core.dart';
import 'package:permission_handler/permission_handler.dart';

extension CSBackupPastGames on CSBackupBloc {
  void initPastGames() {
    if (!ready.value) return;
    final List<File> _pastGames = jsonFilesInDirectory(pastGamesDirectory!);
    this.savedPastGames.set(_pastGames);
  }

  //===================================
  // Methods
  Future<bool> savePastGames() async {
    if (!ready.value) return false;

    final now = DateTime.now();
    File newFile = File(path.join(
      this.pastGamesDirectory!.path,
      "pg_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));

    int i = 0;
    while (await newFile.exists()) {
      ++i;
      String withoutExt = path.basenameWithoutExtension(newFile.path);
      newFile = File(path.join(
        this.pastGamesDirectory!.path,
        withoutExt + "_($i).json",
      ));
      if (i == 100) {
        print("100 files in the same second? wtf??");
        return false;
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

    this.savedPastGames.value.add(newFile);
    this.savedPastGames.refresh();

    return true;
  }

  Future<bool> deletePastGame(int index) async {
    if (this.savedPastGames.value.checkIndex(index)) {
      final file = this.savedPastGames.value.removeAt(index);
      this.savedPastGames.refresh();
      await file.delete();
      return true;
    } else
      return false;
  }

  Future<bool> loadPastGame(File file) async {
    if (!ready.value) return false;
    if (!(await Permission.storage.isGranted)) return false;

    late dynamic decoded;
    bool error = false;
    try {
      String content = await file.readAsString();
      decoded = jsonDecode(content);
    } catch (e) {
      error = true;
    }

    if (decoded == null || error) return false;

    if (decoded is List) {
      /// try to decode them to past game object to check if they are
      final List<PastGame> newPastGames = <PastGame>[
        for (final json in decoded) PastGame.fromJson(json)
      ];

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
    } else
      return false;

    return true;
  }
}
