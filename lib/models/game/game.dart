import 'dart:convert';

import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/models/game/game_settings.dart';
import 'package:counter_spell/models/game/game_state.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:flutter/foundation.dart';

class Game {
  final DateTime startTime;
  final DateTime? endTime;
  final List<GameState> gameStates;
  final GameSettings settings;

  const Game({
    required this.startTime,
    required this.gameStates,
    required this.settings,
    this.endTime,
  });

  int get playerCount => settings.playerSettings.length;

  Game end() => copyWith(endTime: DateTime.now());

  Game.start({
    required int startingLifeTotal,
    required List<String> playerNames,
    required GameSettings? pastGameSettings,
  }) : startTime = DateTime.now(),
       endTime = null,
       gameStates = [
         GameState.start(
           startingLifeTotal: startingLifeTotal,
           playerCount: playerNames.length,
         ),
       ],
       settings = GameSettings(
         startingLifeTotal: startingLifeTotal,
         playerSettings: [
           for (final name in playerNames)
             pastGameSettings?.playerSettings.lastWhere(
                   (element) => element.name == name,
                   orElse: () => PlayerSettings(name: name),
                 ) ??
                 PlayerSettings(name: name),
         ],
       );

  Game restart({required int? startingLifeTotal}) {
    return Game(
      startTime: startTime,
      settings: settings.restart(
        startingLifeTotal: startingLifeTotal ?? settings.startingLifeTotal,
      ),
      gameStates: [
        GameState.start(
          startingLifeTotal: startingLifeTotal ?? settings.startingLifeTotal,
          playerCount: playerCount,
        ),
      ],
    );
  }

  Game deepCopy() => Game.fromJson(toJson());

  Game applyGeneralInteraction({
    required List<bool?> playersMultiSelection,
    required InteractionMode mode,
    required int increment,
    required int? attackingPlayerIndex,
    required int? defendingPlayerIndex,
    required Counter selectedCounter,
    required List<bool> usingPartnerA,
  }) {
    switch (mode) {
      case InteractionMode.life:
        return editLifeMultiple(
          selectedPlayers: playersMultiSelection,
          change: increment,
        );
      case InteractionMode.damage:
        if (attackingPlayerIndex case final int attacker) {
          if (defendingPlayerIndex case final int defender) {
            return dealCommanderDamage(
              attackingPlayerIndex: attacker,
              defendingPlayerIndex: defender,
              damage: increment,
              fromPartnerA: usingPartnerA.elementAtOrNull(attacker) ?? true,
            );
          }
        }
        return deepCopy();
      case InteractionMode.counters:
        return editCountersMultiple(
          selectedPlayers: playersMultiSelection,
          counter: selectedCounter,
          change: increment,
        );
      case InteractionMode.cast:
        return editCastsMultiple(
          selectedPlayers: playersMultiSelection,
          partnerA: usingPartnerA,
          change: increment,
        );
    }
  }

  Game applySinglePlayerInteraction({
    required int playerIndex,
    required InteractionMode mode,
    required int increment,
    required int? attackingPlayerIndex,
    required Counter selectedCounter,
    required List<bool> usingPartnerA,
  }) {
    switch (mode) {
      case InteractionMode.life:
        return dealDamage(playerIndex: playerIndex, damage: -increment);
      case InteractionMode.damage:
        if (attackingPlayerIndex case final int attacker) {
          return dealCommanderDamage(
            attackingPlayerIndex: attacker,
            defendingPlayerIndex: playerIndex,
            damage: increment,
            fromPartnerA: usingPartnerA.elementAtOrNull(attacker) ?? true,
          );
        }
        return deepCopy();
      case InteractionMode.counters:
        return addCounters(
          counter: selectedCounter,
          amount: increment,
          playerIndex: playerIndex,
        );
      case InteractionMode.cast:
        return castCommander(
          playerIndex: playerIndex,
          partnerA: usingPartnerA.elementAtOrNull(playerIndex) ?? true,
          times: increment,
        );
    }
  }

  GameState get currentState =>
      gameStates.lastOrNull ??
      GameState.start(
        startingLifeTotal: settings.startingLifeTotal,
        playerCount: playerCount,
      );

  Game withNewState(GameState Function(GameState old) editor) {
    final newState = editor(currentState);
    final relevant =
        jsonEncode(currentState.toMap()..remove('timestamp')) !=
        jsonEncode(newState.toMap()..remove('timestamp'));
    if (!relevant) return deepCopy();
    if (newState.timestamp.difference(currentState.timestamp) >=
        actionsMergeThreshold) {
      return copyWith(gameStates: [...gameStates, newState]);
    }
    if (gameStates.length < 2) {
      return copyWith(gameStates: [...gameStates, newState]);
    }
    final thisDelta = newState - currentState;
    final previousDelta = currentState - gameStates[gameStates.length - 2];
    if (thisDelta.sameKindOf(previousDelta)) {
      return copyWith(
        gameStates: [
          /// replace current state with new state,
          /// ignoring it so that the resulting delta
          /// is the merge of the previous and current action
          for (int i = 0; i < gameStates.length - 1; i++) gameStates[i],
          newState,
        ],
      );
    }

    return copyWith(gameStates: [...gameStates, newState]);
  }

  static const Duration actionsMergeThreshold = Duration(milliseconds: 2500);

  Game addPlayer(PlayerSettings playerSettings) {
    return copyWith(
      settings: settings.addPlayer(playerSettings),
      gameStates: [
        for (final state in gameStates)
          state.addNewPlayer(startingLifeTotal: 0),
        currentState.addNewPlayer(
          startingLifeTotal: settings.startingLifeTotal,
        ),
      ],
    );
  }

  Game removePlayer(int playerIndex) {
    return copyWith(
      gameStates: [
        for (final state in gameStates) state.withoutPlayer(playerIndex),
      ],
      settings: settings.removePlayer(playerIndex),
    );
  }

  Game renamePlayer({required int playerIndex, required String newName}) {
    return copyWith(
      settings: settings.renamePlayer(
        playerIndex: playerIndex,
        newName: newName,
      ),
    );
  }

  ({Game game, GameStateDelta gameStateDelta}) back() {
    if (gameStates.isEmpty) {
      // absurd
      return (
        game: deepCopy(),
        gameStateDelta: GameStateDelta.zero(
          playerCount: playerCount,
          laterTimeStamp: DateTime.now(),
        ),
      );
    }
    if (gameStates.length == 1) {
      // still shouldn't call this
      return (
        game: deepCopy(),
        gameStateDelta: GameStateDelta.zero(
          playerCount: playerCount,
          laterTimeStamp: currentState.timestamp,
        ),
      );
    }

    final delta = currentState - gameStates[gameStates.length - 2];

    return (
      game: copyWith(
        gameStates: [
          for (int i = 0; i < gameStates.length - 1; i++) gameStates[i],
        ],
      ),
      gameStateDelta: delta,
    );
  }

  Game forward(GameStateDelta delta) {
    return copyWith(gameStates: [...gameStates, currentState + delta]);
  }

  Game dealDamage({required int playerIndex, required int damage}) =>
      withNewState(
        (old) => old.dealDamage(playerIndex: playerIndex, damage: damage),
      );

  Game editLifeMultiple({
    required List<bool?> selectedPlayers,
    required int change,
  }) {
    return withNewState(
      (old) => old.editLifeMultiple(
        selectedPlayers: selectedPlayers,
        change: change,
      ),
    );
  }

  Game dealCommanderDamage({
    required int attackingPlayerIndex,
    required int defendingPlayerIndex,
    required int damage,
    required bool fromPartnerA,
  }) {
    return withNewState(
      (old) => old.dealCommanderDamage(
        attackingPlayerIndex: attackingPlayerIndex,
        defendingPlayerIndex: defendingPlayerIndex,
        damage: damage,
        fromPartnerA: fromPartnerA,
        settings: settings.damageSettingsOf(
          playerIndex: attackingPlayerIndex,
          partnerA: fromPartnerA,
        ),
      ),
    );
  }

  ({Game game, GameStateDelta? removedAction, GameState? actionResult})
  removePartialState(int stateIndex) {
    if (gameStates.length < 2 ||
        stateIndex <= 0 ||
        stateIndex >= gameStates.length - 1) {
      return (game: deepCopy(), removedAction: null, actionResult: null);
    }
    return (
      game: copyWith(
        gameStates: [
          for (int i = 0; i < gameStates.length; i++)
            if (i != stateIndex) gameStates[i],
        ],
      ),
      removedAction: gameStates[stateIndex] - gameStates[stateIndex - 1],
      actionResult: gameStates[stateIndex],
    );
  }

  // 0: latest action, 1: one before that, etc.
  // example: 3 states, 0 is initial state, then 1 and 2.
  // meaning: 2 actions were taken
  // cancelPastAction(0) cancels the latest action, returning to states 0 and 1
  // cancelPastAction(1) cancels the action before that, backing up two times but re-applying the delta of just the latest action
  // cancelPastAction(2) should not work, because you cannot back up past the initial state
  // example: 5 states, 0 is initial, then 1, 2, 3, 4.
  // cancelPastAction(0) cancels the last action and returns
  // cancelPastAction(1) cancels two actions, reapplies the latest one, and returns
  // cancelPastAction(3) cancels four actions, reapplies the latest three, and returns
  // cancelPastAction(4) should not work, because you cannot back up past the initial state
  ({Game game, GameStateDelta? cancelledAction, GameState? actionResult})
  cancelPastAction(int pastIndex) {
    if (gameStates.length < 2 ||
        pastIndex < 0 ||
        pastIndex >= gameStates.length - 1) {
      return (game: deepCopy(), cancelledAction: null, actionResult: null);
    }
    if (pastIndex == 0) {
      final finalState = gameStates.last.deepCopy();
      return (
        game: back().game,
        cancelledAction: finalState - gameStates[gameStates.length - 2],
        actionResult: finalState,
      );
    }

    final deltas = <GameStateDelta>[];
    Game g = deepCopy();
    GameState? actionResult;
    for (int i = 0; i <= pastIndex; i++) {
      actionResult = g.currentState.deepCopy();
      final result = g.back();
      g = result.game;
      deltas.insert(0, result.gameStateDelta);
    }
    final cancelled = deltas.removeAt(0);
    for (final delta in deltas) {
      g = g.forward(delta);
    }
    return (
      game: g.deepCopy(),
      cancelledAction: cancelled,
      actionResult: actionResult,
    );
  }

  Game castCommander({
    required int playerIndex,
    required bool partnerA,
    required int times,
  }) {
    return withNewState(
      (old) => old.castCommander(
        playerIndex: playerIndex,
        partnerA: partnerA,
        times: times,
      ),
    );
  }

  Game resetCommanderCasts({required int playerIndex, required bool partnerA}) {
    return withNewState(
      (old) =>
          old.resetCommanderCasts(playerIndex: playerIndex, partnerA: partnerA),
    );
  }

  Game editCastsMultiple({
    required List<bool?> selectedPlayers,
    required List<bool> partnerA,
    required int change,
  }) {
    return withNewState(
      (old) => old.editCastsMultiple(
        selectedPlayers: selectedPlayers,
        partnerA: partnerA,
        change: change,
      ),
    );
  }

  Game addCounters({
    required Counter counter,
    required int amount,
    required int playerIndex,
  }) {
    return withNewState(
      (old) => old.addCounters(
        counter: counter,
        amount: amount,
        playerIndex: playerIndex,
      ),
    );
  }

  Game editCountersMultiple({
    required List<bool?> selectedPlayers,
    required Counter counter,
    required int change,
  }) {
    return withNewState(
      (old) => old.editCountersMultiple(
        selectedPlayers: selectedPlayers,
        counter: counter,
        change: change,
      ),
    );
  }

  int? get autoWinner => currentState.autoWinner(settings.lethalPoisonCounters);

  Game copyWith({
    DateTime? startTime,
    DateTime? endTime,
    List<GameState>? gameStates,
    GameSettings? settings,
  }) {
    return Game(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      gameStates: gameStates ?? this.gameStates,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'gameStates': [for (final state in gameStates) state.toMap()],
      'settings': settings.toMap(),
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: switch (map['endTime']) {
        String s => DateTime.parse(s),
        _ => null,
      },
      gameStates: <GameState>[
        for (final m in map['gameStates'] as List)
          GameState.fromMap(m as Map<String, dynamic>),
      ],
      settings: GameSettings.fromMap(map['settings'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) =>
      Game.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Game(startTime: $startTime, endTime: $endTime, gameStates: $gameStates, settings: $settings)';
  }

  @override
  bool operator ==(covariant Game other) {
    if (identical(this, other)) return true;

    return other.startTime == startTime &&
        other.endTime == endTime &&
        listEquals(other.gameStates, gameStates) &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    return startTime.hashCode ^
        endTime.hashCode ^
        gameStates.hashCode ^
        settings.hashCode;
  }
}
