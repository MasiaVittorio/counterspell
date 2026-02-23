import 'dart:convert';
import 'dart:io';

import 'package:counter_spell/core.dart';
import 'package:counter_spell/logic/sub_blocs/backups/backup_logic.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/share_or_save.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

extension CSBackupPastGames on CSBackupBloc {
  //===================================
  // Methods
  Future<bool> savePastGames() async {
    final newFile = await createGamesBackup();
    if (newFile == null) {
      return false;
    } else {
      await newFile.share();
      return true;
    }
  }

  Future<File?> createGamesBackup() async {
    final now = DateTime.now();
    final tempDir = await getTemporaryDirectory();
    File newFile = File(path.join(
      tempDir.path,
      "counterspell_game_history_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json",
    ));

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

  Future<bool> loadPastGame(File file) async {
    final result = await readPastGames(file);

    final newPastGames = result.games;
    if (newPastGames == null || newPastGames.isEmpty) {
      return false;
    }

    return await restorePastGames(newPastGames);
  }

  Future<bool> restorePastGames(List<PastGame> newPastGames) async {
    if (newPastGames.isEmpty) return false;

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
      if (errorParsingJson || newPastGames == null) {
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
