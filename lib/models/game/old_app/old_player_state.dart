import 'dart:convert';

import 'package:counter_spell/models/game/old_app/old_commander_damage.dart';

class OldPlayerState {
  //===================================
  // Values
  final DateTime time;

  final int life;

  //damage TAKEN
  final Map<String, OldCommanderDamage> damages;

  final OldCommanderCast cast;

  final Map<String, int> counters;

  //===================================
  // Getters
  int get totalCasts => cast.a + cast.b;
  int get totalDamageTaken {
    int sum = 0;
    for (final value in damages.values) {
      sum += value.a;
      sum += value.b;
    }
    return sum;
  }

  bool get isAlive {
    if (life < 1) return false;
    for (final damage in damages.values) {
      if (damage.a >= 21) return false;
      if (damage.b >= 21) return false;
    }
    if (counters[poisonKey]! >= 10) {
      return false;
    }

    return true;
  }

  static const poisonKey = 'Poison Counters';

  //===================================
  // Modifiers
  static const kMinValue = -99999999999999;
  static const kMaxValue = 999999999999999;
  OldPlayerState hardCopy() => OldPlayerState(
    life: life + 0,
    time: DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch + 0),
    damages: <String, OldCommanderDamage>{
      for (final entry in damages.entries) entry.key: entry.value.copy(),
    },
    cast: cast.copy(),
    counters: <String, int>{
      for (final entry in counters.entries) entry.key: entry.value + 0,
    },
  );

  OldPlayerState updateTime([DateTime? newTime]) => newTime == null
      ? OldPlayerState.now(
          life: life,
          cast: cast,
          damages: damages,
          counters: counters,
        )
      : OldPlayerState(
          time: newTime,
          life: life,
          cast: cast,
          damages: damages,
          counters: counters,
        );

  //===================================
  // Persistence

  Map<String, dynamic> toJson() => {
    'life': life,
    'time': time.toString(),
    'cast': cast.json,
    'damages': <String, dynamic>{
      for (final entry in damages.entries) entry.key: entry.value.json,
    },
    'counters': counters,
  };

  factory OldPlayerState.fromJson(Map<String, dynamic> json) => OldPlayerState(
    life: json['life'],
    time: DateTime.parse(json['time']),
    cast: OldCommanderCast.fromJson(json['cast']),
    damages: <String, OldCommanderDamage>{
      for (final entry
          in ((json['damages'] ?? {}) as Map<String, dynamic>).entries)
        entry.key: OldCommanderDamage.fromJson(entry.value),
    },
    counters: <String, int>{
      for (final entry
          in ((json['counters'] ?? {}) as Map<String, dynamic>).entries)
        entry.key: entry.value as int,
    },
  );

  @override
  bool operator ==(Object other) {
    if (other is OldPlayerState) {
      if (jsonEncode(other.toJson()) == jsonEncode(toJson())) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  int get hashCode => jsonEncode(toJson()).hashCode;

  //====================================
  // Constructor

  OldPlayerState({
    required this.life,
    required this.time,
    required this.damages,
    required this.cast,
    required this.counters,
  });

  factory OldPlayerState.now({
    required int life,
    required OldCommanderCast cast,
    required Map<String, OldCommanderDamage> damages,
    required Map<String, int> counters,
  }) => OldPlayerState(
    life: life,
    time: DateTime.now(),
    cast: cast,
    damages: damages,
    counters: counters,
  );

  factory OldPlayerState.start({
    required int life,
    required Set<String> others,
    required Set<String> counters,
  }) => OldPlayerState.now(
    life: life,
    damages: {for (final name in others) name: const OldCommanderDamage(0)},
    cast: const OldCommanderCast(0),
    counters: {for (final counter in counters) counter: 0},
  );

  //====================================
  // Group Actions

  void renamePlayerReferences(String oldName, String newName) {
    //not necessairly renamig this player,
    //maybe renaming an opponent and updating
    //the name keys on the commander damage maps.
    damages[newName] = damages.remove(oldName) ?? const OldCommanderDamage(0);
  }

  void deletePlayerReferences(String name) {
    damages.remove(name);
  }

  void addPlayerReferences(String newPlayerName) {
    damages[newPlayerName] = const OldCommanderDamage(0);
  }
}
