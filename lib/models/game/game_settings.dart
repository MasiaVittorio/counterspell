import 'dart:convert';

import 'package:counter_spell/models/game/commander_damage_settings.dart';
import 'package:counter_spell/models/game/old_app/old_game_record.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:flutter/foundation.dart';

class GameSettings {
  // used when adding new players
  final int startingLifeTotal;

  /// fixed order, player 1 is always at index 0, etc
  final List<PlayerSettings> playerSettings;

  CommanderDamageSettings damageSettingsOf({
    required int playerIndex,
    required bool partnerA,
  }) =>
      playerSettings[playerIndex].commanderDamageSettings.partner(partnerA) ??
      const CommanderDamageSettings();

  String? commanderOf(int playerIndex, {required bool partnerA}) =>
      commandersOf(playerIndex).partner(partnerA);

  Commanders commandersOf(int playerIndex) =>
      playerSettings[playerIndex].commanders;

  GameSettings restart({required int? startingLifeTotal}) => copyWith(
    startingLifeTotal: startingLifeTotal,
    playerSettings: [for (final settings in playerSettings) settings.restart()],
  );

  GameSettings swapCommanders({required int playerIndex}) {
    return updatePlayerSettings(
      playerIndex: playerIndex,
      editor: (old) => old.swapCommanders(),
    );
  }

  GameSettings addPlayer(PlayerSettings settings) {
    return copyWith(playerSettings: [...playerSettings, settings]);
  }

  GameSettings renamePlayer({
    required int playerIndex,
    required String newName,
  }) => updatePlayerSettings(
    playerIndex: playerIndex,
    editor: (old) => old.copyWith(name: newName),
  );

  GameSettings removePlayer(int playerIndex) {
    if (playerSettings.length <= 2) {
      return deepCopy();
    }
    return copyWith(
      playerSettings: [
        for (int i = 0; i < playerSettings.length; i++)
          if (i != playerIndex) playerSettings[i],
      ],
    );
  }

  GameSettings deepCopy() => GameSettings.fromJson(toJson());

  GameSettings updatePartnerSettings({
    required int playerIndex,
    required bool partnerA,
    required CommanderDamageSettings? damageSettings,
  }) => updatePlayerSettings(
    playerIndex: playerIndex,
    editor: (old) => old.updatePartnerSettings(
      partnerA: partnerA,
      damageSettings: damageSettings,
    ),
  );

  GameSettings updateCommander({
    required int playerIndex,
    required bool partnerA,
    required MtgCard? card,
  }) => updatePlayerSettings(
    playerIndex: playerIndex,
    editor: (old) => old.updateCommander(partnerA: partnerA, card: card),
  );

  GameSettings updatePlayerSettings({
    required int playerIndex,
    required PlayerSettings Function(PlayerSettings old) editor,
  }) => copyWith(
    playerSettings: [
      for (int i = 0; i < playerSettings.length; i++)
        if (i == playerIndex) editor(playerSettings[i]) else playerSettings[i],
    ],
  );

  //

  // LATER: maybe make this an editable setting
  int get lethalPoisonCounters => switch (startingLifeTotal) {
    30 || 60 => 15,
    _ => 10,
  };

  const GameSettings({
    required this.startingLifeTotal,
    required this.playerSettings,
  });

  // we don't want names to start or end with spaces unless they would be in conflict with another name
  GameSettings sanitized() {
    final List<String> names = [];
    for (final player in playerSettings) {
      final String trimmed = player.name.trim();
      if (!names.contains(trimmed)) {
        names.add(trimmed);
      } else {
        names.add(player.name);
      }
    }
    return copyWith(
      playerSettings: [
        for (int i = 0; i < names.length; i++)
          playerSettings[i].copyWith(name: names[i]),
      ],
    );
  }

  static GameSettings fromOldGameRecord(
    OldGameRecord oldRecord, {
    required List<String> orderedPlayerNames,
  }) {
    return GameSettings(
      startingLifeTotal: 40,
      playerSettings: [
        for (final name in orderedPlayerNames)
          PlayerSettings.fromOldGameRecord(
            oldRecord,
            playerName: name,
            orderedPlayerNames: orderedPlayerNames,
          ),
      ],
    );
  }

  GameSettings copyWith({
    int? startingLifeTotal,
    List<PlayerSettings>? playerSettings,
  }) {
    return GameSettings(
      startingLifeTotal: startingLifeTotal ?? this.startingLifeTotal,
      playerSettings: playerSettings ?? this.playerSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startingLifeTotal': startingLifeTotal,
      'playerSettings': playerSettings.map((x) => x.toMap()).toList(),
    };
  }

  factory GameSettings.fromMap(Map<String, dynamic> map) {
    return GameSettings(
      startingLifeTotal: map['startingLifeTotal'] as int,
      playerSettings: [
        for (final x in ((map['playerSettings'] ?? []) as List))
          PlayerSettings.fromMap(x as Map<String, dynamic>),
      ],
    );
  }

  String toJson() => json.encode(toMap());

  factory GameSettings.fromJson(String source) =>
      GameSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GameSettings(startingLifeTotal: $startingLifeTotal, playerSettings: $playerSettings)';

  @override
  bool operator ==(covariant GameSettings other) {
    if (identical(this, other)) return true;

    return other.startingLifeTotal == startingLifeTotal &&
        listEquals(other.playerSettings, playerSettings);
  }

  @override
  int get hashCode => startingLifeTotal.hashCode ^ playerSettings.hashCode;
}
