import 'dart:convert';

import 'package:counter_spell/models/game/game.dart';
import 'package:counter_spell/models/game/game_settings.dart';
import 'package:counter_spell/models/game/game_state.dart';
import 'package:counter_spell/models/game/old_app/old_game_record.dart';

class GameRecord {
  final GameState gameState;
  final GameSettings settings;
  final int? winner;
  final DateTime startTime;
  final DateTime endTime;
  final int? actions;
  Duration get duration => endTime.difference(startTime).abs();

  static GameRecord fromGame(Game game, {required int? winner}) {
    return GameRecord(
      actions: game.gameStates.length - 1,
      gameState: game.currentState,
      settings: game.settings.sanitized(),
      winner: winner,
      endTime: switch (game.currentState.timestamp
          .difference(DateTime.now())
          .abs()
          .inMinutes) {
        > 30 => game.currentState.timestamp,
        _ => DateTime.now(),
      },
      startTime: switch (game.gameStates.length) {
        > 1 => switch (game.gameStates[1].timestamp
            .difference(game.startTime)
            .abs()
            .inMinutes) {
          > 30 => game.gameStates[1].timestamp,
          _ => game.startTime,
        },
        _ => game.startTime,
      },
    );
  }

  static GameRecord? parseOld(String old) {
    try {
      OldGameRecord oldRecord = OldGameRecord.fromJson(jsonDecode(old));
      final result = fromOldGameRecord(oldRecord);
      return result;
    } catch (e) {
      return null;
    }
  }

  static GameRecord fromOldGameRecord(OldGameRecord oldRecord) {
    final List<String> orderedPlayerNames = oldRecord.state.players.keys
        .toList();
    final GameState gameState = GameState.fromOldGameRecord(
      oldRecord,
      orderedPlayerNames: orderedPlayerNames,
    );
    final GameSettings settings = GameSettings.fromOldGameRecord(
      oldRecord,
      orderedPlayerNames: orderedPlayerNames,
    ).sanitized();
    int? winnerIndex;
    if (oldRecord.winner case String winnerName) {
      for (final playerSettings in settings.playerSettings) {
        if (playerSettings.name == winnerName) {
          winnerIndex = settings.playerSettings.indexOf(playerSettings);
          break;
        }
      }
    }

    return GameRecord(
      gameState: gameState,
      settings: settings,
      winner: winnerIndex,
      startTime: oldRecord.startingDateTime,
      endTime: oldRecord.state.lastTime,
      actions: null,
    );
  }

  bool equivalentToOldRecord(OldGameRecord oldRecord) {
    return oldRecord.startingDateTime == startTime;
  }

  GameRecord({
    required this.gameState,
    required this.settings,
    required this.winner,
    required this.startTime,
    required this.endTime,
    required this.actions,
  });

  GameRecord copyWithoutWinner() {
    return GameRecord(
      gameState: gameState,
      settings: settings,
      winner: null,
      startTime: startTime,
      endTime: endTime,
      actions: actions,
    );
  }

  GameRecord copyWith({
    GameState? gameState,
    GameSettings? settings,
    int? winner,
    DateTime? startTime,
    DateTime? endTime,
    int? actions,
  }) {
    return GameRecord(
      gameState: gameState ?? this.gameState,
      settings: settings ?? this.settings,
      winner: winner ?? this.winner,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      actions: actions ?? this.actions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gameState': gameState.toMap(),
      'settings': settings.toMap(),
      'winner': winner,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'actions': actions,
    };
  }

  factory GameRecord.fromMap(Map<String, dynamic> map) {
    return GameRecord(
      gameState: GameState.fromMap(map['gameState'] as Map<String, dynamic>),
      settings: GameSettings.fromMap(
        map['settings'] as Map<String, dynamic>,
      ).sanitized(),
      winner: map['winner'] != null ? map['winner'] as int : null,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      actions: map['actions'] != null ? map['actions'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameRecord.fromJson(String source) =>
      GameRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameRecord(gameState: $gameState, settings: $settings, winner: $winner, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(covariant GameRecord other) {
    if (identical(this, other)) return true;

    return other.gameState == gameState &&
        other.settings == settings &&
        other.winner == winner &&
        other.startTime == startTime &&
        other.actions == actions &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return gameState.hashCode ^
        settings.hashCode ^
        winner.hashCode ^
        startTime.hashCode ^
        actions.hashCode ^
        endTime.hashCode;
  }
}
