import 'dart:convert';

import 'package:counter_spell/models/game/commander_damage_settings.dart';
import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/models/game/old_app/old_game_record.dart';
import 'package:counter_spell/models/game/player_state.dart';
import 'package:flutter/foundation.dart';

class GameState {
  final DateTime timestamp;
  final List<PlayerState> playerStates;

  GameState.start({required int startingLifeTotal, required int playerCount})
    : timestamp = DateTime.now(),
      playerStates = [
        for (int i = 0; i < playerCount; i++)
          PlayerState.start(
            startingLifeTotal: startingLifeTotal,
            playerCount: playerCount,
          ),
      ];

  /// this is used to replace all already existing gamestates in a game, information is lost here
  GameState withoutPlayer(int playerIndex) {
    return copyWith(
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          if (i != playerIndex) playerStates[i].removePlayer(playerIndex),
      ],
    );
  }

  GameState addNewPlayer({required int startingLifeTotal}) {
    return copyWith(
      timestamp: DateTime.now(),
      playerStates: [
        for (final state in playerStates)
          state
              .addNewPlayer(), // to mark a new entry in the list of commander damage taken
        PlayerState.start(
          startingLifeTotal: startingLifeTotal,
          playerCount: playerStates.length + 1,
        ),
      ],
    );
  }

  GameState dealDamage({required int playerIndex, required int damage}) {
    return copyWith(
      timestamp: DateTime.now(),
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          if (i == playerIndex)
            playerStates[i].dealDamage(damage)
          else
            playerStates[i],
      ],
    );
  }

  GameState editLifeMultiple({
    required List<bool?> selectedPlayers,
    required int change,
  }) {
    return copyWith(
      timestamp: DateTime.now(),
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          playerStates[i].dealDamage(
            -change *
                switch (selectedPlayers[i]) {
                  true => 1,
                  false => 0,
                  null => -1,
                },
          ),
      ],
    );
  }

  GameState dealCommanderDamage({
    required int attackingPlayerIndex,
    required int defendingPlayerIndex,
    required int damage,
    required bool fromPartnerA,
    required CommanderDamageSettings settings,
  }) {
    return copyWith(
      timestamp: DateTime.now(),
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          if (i == defendingPlayerIndex)
            playerStates[i]
                .dealCommanderDamage(
                  damage,
                  attackingPlayerIndex: attackingPlayerIndex,
                  fromPartnerA: fromPartnerA,
                )
                .dealDamage(settings.dealDamageToLifeTotal ? damage : 0)
                .addCounters(
                  counter: Counter.poison,
                  amount: settings.infect ? damage : 0,
                )
          else if (i == attackingPlayerIndex)
            playerStates[i].dealDamage(settings.lifelink ? -damage : 0)
          else
            playerStates[i],
      ],
    );
  }

  GameState castCommander({
    required int playerIndex,
    required bool partnerA,
    required int times,
  }) {
    return copyWith(
      timestamp: DateTime.now(),
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          if (i == playerIndex)
            playerStates[i].castCommander(partnerA: partnerA, times: times)
          else
            playerStates[i],
      ],
    );
  }

  GameState resetCommanderCasts({
    required int playerIndex,
    required bool partnerA,
  }) {
    return copyWith(
      timestamp: DateTime.now(),
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          if (i == playerIndex)
            playerStates[i].resetCommanderCasts(partnerA: partnerA)
          else
            playerStates[i],
      ],
    );
  }

  GameState editCastsMultiple({
    required List<bool?> selectedPlayers,
    required List<bool> partnerA,
    required int change,
  }) {
    return copyWith(
      timestamp: DateTime.now(),
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          playerStates[i].castCommander(
            partnerA: partnerA.elementAtOrNull(i) ?? true,
            times:
                change *
                switch (selectedPlayers[i]) {
                  true => 1,
                  false => 0,
                  null => -1,
                },
          ),
      ],
    );
  }

  GameState editCountersMultiple({
    required List<bool?> selectedPlayers,
    required Counter counter,
    required int change,
  }) {
    return copyWith(
      timestamp: DateTime.now(),
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          playerStates[i].addCounters(
            counter: counter,
            amount:
                change *
                switch (selectedPlayers[i]) {
                  true => 1,
                  false => 0,
                  null => -1,
                },
          ),
      ],
    );
  }

  GameState addCounters({
    required Counter counter,
    required int amount,
    required int playerIndex,
  }) {
    // should not happen, but just in case
    if (playerIndex >= playerStates.length) return deepCopy();
    final newPlayerState = playerStates[playerIndex].addCounters(
      counter: counter,
      amount: amount,
    );
    final bool resetOtherPlayers =
        counter.onePlayerAtATime &&
        newPlayerState.amountOfCounters(counter) > 0;

    return copyWith(
      timestamp: DateTime.now(),
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          if (i == playerIndex)
            newPlayerState
          else
            playerStates[i].modalResetCounters(
              counter: counter,
              reset: resetOtherPlayers,
            ),
      ],
    );
  }

  GameStateDelta operator -(covariant GameState other) {
    if (identical(this, other)) {
      return GameStateDelta.zero(
        playerCount: playerStates.length,
        laterTimeStamp: timestamp,
      );
    }
    return GameStateDelta(
      laterTimeStamp: timestamp,
      playerStates: [
        for (int i = 0; i < playerStates.length; i++)
          playerStates[i] -
              (other.playerStates.elementAtOrNull(i) ??
                  PlayerState.start(
                    startingLifeTotal: 0,
                    playerCount: playerStates.length,
                  )),
      ],
    );
  }

  GameState operator +(covariant GameStateDelta delta) {
    return copyWith(
      timestamp: delta.laterTimeStamp,
      playerStates: [
        for (int i = 0; i < delta.playerStates.length; i++)
          (playerStates.elementAtOrNull(i) ??
                  PlayerState.start(
                    startingLifeTotal: 0,
                    playerCount: playerStates.length,
                  )) +
              delta.playerStates[i],
      ],
    );
  }

  int? autoWinner(int lethalPoisonCounters) {
    final int playersCount = playerStates.length;
    int deadPlayersCount = 0;
    int alivePlayer = 0;
    for (int i = 0; i < playersCount; i++) {
      if (playerStates[i].isDead(lethalPoisonCounters)) {
        deadPlayersCount++;
      } else {
        alivePlayer = i;
      }
    }
    if (deadPlayersCount == playersCount - 1) {
      return alivePlayer;
    }
    return null;
  }

  const GameState({required this.timestamp, required this.playerStates});

  static GameState fromOldGameRecord(
    OldGameRecord oldRecord, {
    required List<String> orderedPlayerNames,
  }) {
    return GameState(
      timestamp: oldRecord.state.lastTime,
      playerStates: [
        for (final name in orderedPlayerNames)
          PlayerState.fromOldPlayerState(
            oldRecord.state.players[name]!.states.last,
            orderedPlayerNames: orderedPlayerNames,
          ),
      ],
    );
  }

  GameState deepCopy() => GameState.fromJson(toJson());

  GameState copyWith({DateTime? timestamp, List<PlayerState>? playerStates}) {
    return GameState(
      timestamp: timestamp ?? this.timestamp,
      playerStates: playerStates ?? this.playerStates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp': timestamp.toIso8601String(),
      'playerStates': [for (final ps in playerStates) ps.toMap()],
    };
  }

  factory GameState.fromMap(Map<String, dynamic> map) {
    return GameState(
      timestamp: DateTime.parse(map['timestamp']),
      playerStates: <PlayerState>[
        for (final psm in map['playerStates'] as List)
          PlayerState.fromMap(psm as Map<String, dynamic>),
      ],
    );
  }

  String toJson() => json.encode(toMap());

  factory GameState.fromJson(String source) =>
      GameState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GameState(timestamp: $timestamp, playerStates: $playerStates)';

  @override
  bool operator ==(covariant GameState other) {
    if (identical(this, other)) return true;

    return other.timestamp == timestamp &&
        listEquals(other.playerStates, playerStates);
  }

  @override
  int get hashCode => timestamp.hashCode ^ playerStates.hashCode;
}

class GameStateDelta {
  final DateTime laterTimeStamp;
  final List<PlayerStateDelta> playerStates;

  GameStateDelta({required this.laterTimeStamp, required this.playerStates});

  bool sameKindOf(GameStateDelta other) {
    if (identical(this, other)) return true;

    if (playerStates.length != other.playerStates.length) return false;

    final kinds = {for (final state in playerStates) ...state.deltaKinds};

    if (kinds.length > 1) return false;
    if (kinds.isEmpty) return false;

    final otherKinds = {
      for (final state in other.playerStates) ...state.deltaKinds,
    };

    if (otherKinds.length > 1) return false;
    if (otherKinds.isEmpty) return false;

    return kinds.first == otherKinds.first;
  }

  GameStateDelta.zero({required int playerCount, required this.laterTimeStamp})
    : playerStates = [
        for (int i = 0; i < playerCount; i++)
          PlayerStateDelta.zero(playerCount: playerCount),
      ];
}
