import 'dart:convert';
import 'dart:io';

import 'package:counter_spell/logic/cards_logic.dart';
import 'package:counter_spell/logic/old_logic_stuff/shared_db.dart';
import 'package:counter_spell/models/game/game.dart';
import 'package:counter_spell/models/game/old_app/old_game_record.dart';
import 'package:counter_spell/models/leaderboards/game_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sid_base/sid_base.dart';

class LeaderboardsLogic extends LogicBase {
  final PersistentReactive<List<GameRecord>> gameRecords = PersistentReactive(
    [],
    key: 'gameRecords',
    toJsonEncodable: (value) => [for (final record in value) record.toMap()],
    fromJsonDecoded: (list) => [
      for (final recordMap in list)
        if (recordMap case Map<String, dynamic> recordMap)
          GameRecord.fromMap(recordMap),
    ],
  );

  final ValueChanged<String> onLogBugs;

  final CardsLogic cardsLogic;

  @override
  void dispose() {
    gameRecords.dispose();
    super.dispose();
  }

  LeaderboardsLogic(this.onLogBugs, this.cardsLogic) {
    _readOldAppData();
  }

  void recordGame(Game game, {required int? selectedWinner}) {
    gameRecords.value.add(GameRecord.fromGame(game, winner: selectedWinner));
    gameRecords.refresh();
  }

  Future<File?> writeBackupFile() async {
    final now = DateTime.now();
    final tempDir = await getTemporaryDirectory();
    File newFile = File(
      path.join(
        tempDir.path,
        'counterspell_game_history_${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}.json',
      ),
    );

    await newFile.writeAsString(encodeBackupMap());

    return newFile;
  }

  String encodeBackupMap() => jsonEncode(createBackupMap());

  Map<String, dynamic> createBackupMap() {
    return {
      'counterspell_backup_version': 1,
      'gameRecords': [for (final record in gameRecords.value) record.toMap()],
    };
  }

  String? mergeBackup(dynamic decoded, {required PanelFrameState panelFrame}) {
    // try {
    if (decoded case Map<String, dynamic> map) {
      switch (map['counterspell_backup_version']) {
        case 1:
          final valid = validNewRecords([
            for (final recordMap in (map['gameRecords'] as List))
              if (recordMap case Map<String, dynamic> recordMap)
                GameRecord.fromMap(recordMap),
          ]);
          if (valid.isEmpty) {
            return 'No new past games to merge';
          }
          panelFrame.showAlert(
            ConfirmPanelAlert(
              title: Text('Merge ${valid.length} new past games?'),
              onConfirmed: () {
                mergeValidRecords(valid);
                panelFrame.showSnackBar(
                  PanelSnackBar(
                    child: Text('Merged ${valid.length} past games'),
                  ),
                );
              },
              confirmLabel: const Text('Merge'),
              overrideConfirmIcon: Icon(MdiIcons.trayArrowDown),
            ),
          );
          return null;
        case final int v:
          return 'Unknown backup version: $v';
        default:
          return 'Missing backup version';
      }
    } else if (decoded case List decoded) {
      final valid = validOldRecords([
        for (final recordMap in decoded)
          if (recordMap case Map<String, dynamic> recordMap)
            OldGameRecord.fromJson(recordMap),
      ]);
      if (valid.isEmpty) {
        return 'No new past games to merge';
      }
      panelFrame.showAlert(
        ConfirmPanelAlert(
          title: Text('Merge ${valid.length} new past games?'),
          onConfirmed: () {
            mergeValidRecords([
              for (final old in valid) GameRecord.fromOldGameRecord(old),
            ]);

            panelFrame.showSnackBar(
              PanelSnackBar(child: Text('Merged ${valid.length} past games')),
            );
          },
          confirmLabel: const Text('Merge'),
          overrideConfirmIcon: Icon(MdiIcons.trayArrowDown),
        ),
      );
      return null;
    }
    return 'Unknown file format';
  }

  void mergeValidRecords(List<GameRecord> valid) {
    gameRecords.value.addAll(valid);
    gameRecords.refresh();
    final Map<String, Set<String>> newPlayerCards = {};
    for (final record in valid) {
      for (final settings in record.settings.playerSettings) {
        final String name = settings.name;
        newPlayerCards[name] = {
          ...?newPlayerCards[name],
          ?settings.commanders.partnerA,
          ?settings.commanders.partnerB,
        };
      }
    }
    cardsLogic.playerCards.accessAfterReading((_) {
      for (final entry in newPlayerCards.entries) {
        cardsLogic.playerCards.value[entry.key] = {
          ...?cardsLogic.playerCards.value[entry.key],
          ...entry.value,
        };
      }
      cardsLogic.playerCards.refresh();
    });
  }

  void mergeOldBackup(List<OldGameRecord> oldRecords) {
    gameRecords.value.addAll([
      for (final old in validOldRecords(oldRecords))
        GameRecord.fromOldGameRecord(old),
    ]);
    gameRecords.refresh();
  }

  List<GameRecord> validNewRecords(List<GameRecord> newRecords) => [
    for (final newRecord in newRecords)
      if (!gameRecords.value.any((record) => record == newRecord)) newRecord,
  ];

  List<OldGameRecord> validOldRecords(List<OldGameRecord> oldRecords) => [
    for (final oldRecord in oldRecords)
      if (!gameRecords.value.any(
        (record) => record.equivalentToOldRecord(oldRecord),
      ))
        oldRecord,
  ];

  Future<bool> _readOldAppData() async {
    const String key = 'counterspell_bloc_var_pastGames_pastGames';
    const String lenghtKey = '${key}_lenght';
    String indexKey(int index) => '${key}_$index';

    OldGameRecord jsonToItem(Map<String, dynamic> json) =>
        OldGameRecord.fromJson(json);
    final SharedDb? instance = await SharedDb.getInstance();
    if (instance == null) return false;

    final String? lenghtString = await instance.getString(lenghtKey);
    if (lenghtString == null) return false; // not wrote anything yet

    int? lenghtFromDisk;
    bool error = false;
    try {
      lenghtFromDisk = jsonDecode(lenghtString);
    } catch (e) {
      error = true;
      onLogBugs('unexpected error during lenght decoding of $key: error = $e');
    }
    if (error) return false;
    if (lenghtFromDisk == 0) return false;
    if (lenghtFromDisk == null) return false;

    List<OldGameRecord?> content = <OldGameRecord?>[];

    for (int i = 0; i < lenghtFromDisk; ++i) {
      String? itemString = await instance.getString(indexKey(i));
      if (itemString == null) continue;
      OldGameRecord? item;
      bool error = false;
      try {
        item = jsonToItem(jsonDecode(itemString));
      } catch (e) {
        error = true;
        onLogBugs(
          'unexpected error during item number $i decoding of $key: error = $e',
        );
      }
      if (error) continue;

      content.add(item);
    }

    if (content.length != lenghtFromDisk) {
      instance.setString(lenghtKey, jsonEncode(content.length));
    }

    gameRecords.accessAfterReading((_) async {
      await Future.delayed(100.milliseconds);
      final valid = validOldRecords([for (final a in content) ?a]);
      if (valid.isNotEmpty) {
        onLogBugs(
          'found ${valid.length} unrecorded past games in old app data',
        );
      }
      final newRecords = [
        for (final old in valid) GameRecord.fromOldGameRecord(old),
      ];
      final Map<String, Set<String>> newPlayerCards = {};
      for (final record in newRecords) {
        for (int i = 0; i < record.settings.playerSettings.length; i++) {
          final settings = record.settings.playerSettings[i];
          final String name = settings.name;
          newPlayerCards[name] = {
            ...?newPlayerCards[name],
            ?settings.commanders.partnerA,
            ?settings.commanders.partnerB,
          };
        }
      }
      gameRecords.value.addAll(newRecords);
      gameRecords.refresh();
      cardsLogic.playerCards.accessAfterReading((_) {
        for (final entry in newPlayerCards.entries) {
          cardsLogic.playerCards.value[entry.key] = {
            ...?cardsLogic.playerCards.value[entry.key],
            ...entry.value,
          };
        }
        cardsLogic.playerCards.refresh();
      });

      if (newRecords.isEmpty) {
        // past games already merged, let's delete old app data to free up space and to avoid re-merging it in case the user deletes the new past games
        for (int i = 0; i < lenghtFromDisk!; ++i) {
          await instance.deleteByKey(indexKey(i));
        }
      }
    });

    return true;
  }
}
