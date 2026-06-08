// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/models/game/old_app/old_player_state.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:flutter/foundation.dart';

class PlayerState {
  /// self explanatory
  final int life;

  /// commander damage from each player (fixed order, player 1 is always at index 0, etc)
  final List<CommanderDamage> commanderDamageTaken;

  /// for each counter, the value of that counter for this player
  final Map<Counter, int> counters;

  /// number of times this player's commander has been cast, split by partner
  final CommanderCasts commanderCasts;

  PlayerState addCounters({required Counter counter, required int amount}) {
    int result = amountOfCounters(counter) + amount;
    if (counter.minValue case int min) {
      if (result < min) result = min;
    }
    if (counter.maxValue case int max) {
      if (result > max) result = max;
    }
    return copyWith(
      counters: {...counters, counter: result}
        ..removeWhere((key, value) => value == 0),
    );
  }

  PlayerState resetCounters({required Counter counter}) {
    return copyWith(
      counters: {...counters, counter: counter.minValue ?? 0}
        ..removeWhere((key, value) => value == 0),
    );
  }

  PlayerState modalResetCounters({
    required Counter counter,
    required bool reset,
  }) => reset ? resetCounters(counter: counter) : this;

  PlayerState castCommander({required int times, required bool partnerA}) =>
      copyWith(
        commanderCasts: (
          partnerA: commanderCasts.partnerA + (partnerA ? times : 0),
          partnerB: commanderCasts.partnerB + (partnerA ? 0 : times),
        ).clamped(),
      );

  PlayerState resetCommanderCasts({required bool partnerA}) => copyWith(
    commanderCasts: (
      partnerA: partnerA ? 0 : commanderCasts.partnerA,
      partnerB: partnerA ? commanderCasts.partnerB : 0,
    ).clamped(),
  );

  PlayerState dealDamage(int damage) => copyWith(lifePoints: life - damage);

  PlayerState dealCommanderDamage(
    int damage, {
    required int attackingPlayerIndex,
    required bool fromPartnerA,
  }) => copyWith(
    commanderDamageTaken: [
      for (int i = 0; i < commanderDamageTaken.length; i++)
        if (i == attackingPlayerIndex)
          (
            fromPartnerA:
                commanderDamageFrom(playerIndex: i, partnerA: true) +
                (fromPartnerA ? damage : 0),
            fromPartnerB:
                commanderDamageFrom(playerIndex: i, partnerA: false) +
                (fromPartnerA ? 0 : damage),
          ).clamped()
        else
          commanderDamageTaken[i].clamped(),
    ],
  );

  PlayerState addNewPlayer() {
    return copyWith(
      commanderDamageTaken: [
        ...commanderDamageTaken,
        (fromPartnerA: 0, fromPartnerB: 0),
      ],
    );
  }

  PlayerState removePlayer(int playerIndex) {
    return copyWith(
      commanderDamageTaken: [
        for (int i = 0; i < commanderDamageTaken.length; i++)
          if (i != playerIndex) commanderDamageTaken[i],
      ],
    );
  }

  PlayerState operator +(covariant PlayerStateDelta delta) {
    final n = max(
      commanderDamageTaken.length,
      delta.commanderDamageTaken.length,
    );

    return PlayerState(
      life: life + delta.life,
      commanderDamageTaken: [
        for (int i = 0; i < n; i++)
          (commanderDamageTaken.elementAtOrNull(i) ??
                  (fromPartnerA: 0, fromPartnerB: 0)) +
              delta.commanderDamageTaken.elementAtOrNull(i),
      ],
      counters: {
        for (final key in {...counters.keys, ...delta.counters.keys})
          key: amountOfCounters(key) + delta.amountOfCounters(key),
      }..removeWhere((key, value) => value == 0),
      commanderCasts: commanderCasts + delta.commanderCasts,
    );
  }

  PlayerStateDelta operator -(covariant PlayerState other) {
    if (identical(this, other)) {
      return PlayerStateDelta.zero(playerCount: commanderDamageTaken.length);
    }

    final n = max(
      commanderDamageTaken.length,
      other.commanderDamageTaken.length,
    );

    return PlayerStateDelta(
      life: life - other.life,
      commanderDamageTaken: [
        for (int i = 0; i < n; i++)
          (commanderDamageTaken.elementAtOrNull(i) ??
                  (fromPartnerA: 0, fromPartnerB: 0)) -
              other.commanderDamageTaken.elementAtOrNull(i),
      ],
      counters: {
        for (final key in {...counters.keys, ...other.counters.keys})
          if ((counters[key] ?? 0) - (other.counters[key] ?? 0) case int result)
            if (result != 0) key: result,
      },
      commanderCasts: commanderCasts - other.commanderCasts,
    );
  }

  /// since a player could have been added after the game started, the list of commander damage taken might not have an entry for the required player. later player states would be updated with a new entry
  int commanderDamageFrom({required int playerIndex, required bool partnerA}) =>
      (commanderDamageTaken.elementAtOrNull(playerIndex) ??
              (fromPartnerA: 0, fromPartnerB: 0))
          .from(partnerA);

  int amountOfCounters(Counter counter) => counters[counter] ?? 0;

  PlayerState.start({required int startingLifeTotal, required int playerCount})
    : life = startingLifeTotal,
      commanderDamageTaken = [
        for (int i = 0; i < playerCount; i++)
          (fromPartnerA: 0, fromPartnerB: 0),
      ],
      counters = {},
      commanderCasts = (partnerA: 0, partnerB: 0);

  bool isDead(int lethalPoisonCounters) =>
      life <= 0 ||
      commanderDamageTaken.any(
        (cmd) => cmd.fromPartnerA >= 21 || cmd.fromPartnerB >= 21,
      ) ||
      (switch (counters[Counter.poison]) {
        null => false,
        int poisonCounters => poisonCounters >= lethalPoisonCounters,
      });

  const PlayerState({
    required this.life,
    required this.commanderDamageTaken,
    required this.counters,
    required this.commanderCasts,
  });

  static PlayerState fromOldPlayerState(
    OldPlayerState oldPlayerState, {
    required List<String> orderedPlayerNames,
  }) {
    return PlayerState(
      life: oldPlayerState.life,
      commanderDamageTaken: [
        for (final name in orderedPlayerNames)
          (
            fromPartnerA: oldPlayerState.damages[name]?.a ?? 0,
            fromPartnerB: oldPlayerState.damages[name]?.b ?? 0,
          ),
      ],
      counters: {
        for (final entry in oldPlayerState.counters.entries)
          if (entry.key == OldPlayerState.poisonKey)
            Counter.poison: entry.value,
      },
      commanderCasts: (
        partnerA: oldPlayerState.cast.a,
        partnerB: oldPlayerState.cast.b,
      ),
    );
  }

  PlayerState copyWith({
    int? lifePoints,
    List<CommanderDamage>? commanderDamageTaken,
    Map<Counter, int>? counters,
    CommanderCasts? commanderCasts,
  }) {
    return PlayerState(
      life: lifePoints ?? life,
      commanderDamageTaken: commanderDamageTaken ?? this.commanderDamageTaken,
      counters: counters ?? this.counters,
      commanderCasts: commanderCasts ?? this.commanderCasts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'life': life,
      'commanderDamageTaken': [
        for (final cmd in commanderDamageTaken) cmd.toMap(),
      ],
      'counters': {
        for (final entry in counters.entries) entry.key.name: entry.value,
      },
      'commanderCasts': commanderCasts.toMap(),
    };
  }

  factory PlayerState.fromMap(Map<String, dynamic> map) {
    return PlayerState(
      life: map['life'] as int,
      commanderDamageTaken: <CommanderDamage>[
        for (final cmdm in map['commanderDamageTaken'] as List)
          CommanderDamageExtension.fromMap(cmdm as Map<String, dynamic>),
      ],
      counters: <Counter, int>{
        for (final entry in (map['counters'] as Map).entries)
          Counter.values.firstWhere((c) => c.name == entry.key):
              entry.value as int,
      },
      commanderCasts: CommanderCastsExtension.fromMap(
        map['commanderCasts'] as Map<String, dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerState.fromJson(String source) =>
      PlayerState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerState(lifePoints: $life, commanderDamageTaken: $commanderDamageTaken, counters: $counters, commanderCasts: $commanderCasts)';
  }

  @override
  bool operator ==(covariant PlayerState other) {
    if (identical(this, other)) return true;

    return other.life == life &&
        listEquals(other.commanderDamageTaken, commanderDamageTaken) &&
        mapEquals(other.counters, counters) &&
        other.commanderCasts == commanderCasts;
  }

  @override
  int get hashCode {
    return life.hashCode ^
        commanderDamageTaken.hashCode ^
        counters.hashCode ^
        commanderCasts.hashCode;
  }
}

class PlayerStateDelta extends PlayerState {
  PlayerStateDelta({
    required super.life,
    required super.commanderDamageTaken,
    required super.counters,
    required super.commanderCasts,
  });

  List<DeltaKind> get deltaKinds => [
    if (life != 0) LifeDelta(signOrZero: life.signOrZero),
    for (final counter in counters.keys)
      CounterDelta(
        counter: counter,
        signOrZero: amountOfCounters(counter).signOrZero,
      ),
    if (commanderCasts.partnerA != 0)
      CommanderCastDelta(signOrZero: commanderCasts.partnerA.signOrZero),
    if (commanderCasts.partnerB != 0)
      CommanderCastDelta(signOrZero: commanderCasts.partnerB.signOrZero),
    for (int i = 0; i < commanderDamageTaken.length; i++) ...[
      if (commanderDamageTaken[i].fromPartnerA != 0 ||
          commanderDamageTaken[i].fromPartnerB != 0)
        CommanderDamageDelta(signOrZero: 1.signOrZero),
    ],
  ];

  PlayerStateDelta.zero({required int playerCount})
    : super(
        life: 0,
        commanderDamageTaken: [
          for (int i = 0; i < playerCount; i++)
            (fromPartnerA: 0, fromPartnerB: 0),
        ],
        counters: const {},
        commanderCasts: (partnerA: 0, partnerB: 0),
      );
}

enum SignOrZero { negative, zero, positive }

extension on int {
  SignOrZero get signOrZero {
    if (this > 0) return SignOrZero.positive;
    if (this < 0) return SignOrZero.negative;
    return SignOrZero.zero;
  }
}

sealed class DeltaKind {
  const DeltaKind({required this.signOrZero});

  final SignOrZero signOrZero;

  @override
  bool operator ==(covariant DeltaKind other) {
    if (identical(this, other)) return true;

    return other.signOrZero == signOrZero && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => signOrZero.hashCode;
}

final class CounterDelta extends DeltaKind {
  final Counter counter;
  const CounterDelta({required this.counter, required super.signOrZero});
  @override
  bool operator ==(covariant CounterDelta other) {
    if (identical(this, other)) return true;

    return other.signOrZero == signOrZero &&
        other.runtimeType == runtimeType &&
        other.counter == counter;
  }

  @override
  int get hashCode => signOrZero.hashCode ^ counter.hashCode;
}

final class LifeDelta extends DeltaKind {
  const LifeDelta({required super.signOrZero});
}

final class CommanderDamageDelta extends DeltaKind {
  const CommanderDamageDelta({required super.signOrZero});
}

final class CommanderCastDelta extends DeltaKind {
  const CommanderCastDelta({required super.signOrZero});
}
