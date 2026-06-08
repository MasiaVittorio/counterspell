import 'package:counter_spell/models/game/old_app/old_game_state.dart';
import 'package:counter_spell/models/scryfall/card.dart';

class OldGameRecord {
  //=======================================
  // Values
  final OldGameState state;
  String? winner;
  final Map<String, MtgCard?> commandersA;

  /// player -> commander B
  final Map<String, MtgCard?> commandersB;

  /// player -> commander B
  String? notes;
  final DateTime startingDateTime;
  Map<String, Set<String>?> customStats;

  /// stat -> set of applicable players

  //=======================================
  // Constructor(s)
  OldGameRecord(
    this.winner, {
    required this.state,
    required this.notes,
    required Map<String, MtgCard?>? commandersA,
    required Map<String, MtgCard?>? commandersB,
    required this.startingDateTime,
    required this.customStats,
  }) : commandersA = <String, MtgCard?>{
         for (final player in state.players.keys)
           player: commandersA != null ? commandersA[player] : null,
       },
       commandersB = <String, MtgCard?>{
         for (final player in state.players.keys)
           if (state.players[player]!.havePartnerB)
             player: commandersB != null ? commandersB[player] : null
           else
             player: null,
       } {
    winner ??= state.winner;
  }

  factory OldGameRecord.fromState(
    OldGameState state, {
    Map<String, MtgCard>? commandersA,
    Map<String, MtgCard>? commandersB,
    String? notes,
    required DateTime dateTime,
  }) {
    return OldGameRecord(
      state.winner,
      state: state,
      commandersA: commandersA,
      commandersB: commandersB,
      notes: notes,
      customStats: <String, Set<String>>{},
      startingDateTime: dateTime,
      // ?? state.players.values.first!.states.first.time,
    );
  }

  //=======================================
  // Serialize
  Map<String, dynamic> get toJson => <String, dynamic>{
    'winner': winner,
    'notes': notes,
    'state': state.toJson(),
    'dateTime': startingDateTime.millisecondsSinceEpoch,
    'commandersA': <String, Map<String, dynamic>?>{
      for (final entry in commandersA.entries) entry.key: entry.value?.toMap(),
    },
    'commandersB': <String, Map<String, dynamic>?>{
      for (final entry in commandersB.entries) entry.key: entry.value?.toMap(),
    },
    'customStats': <String, List<String>>{
      for (final key in <String>{...customStats.keys})
        key: <String>[...(customStats[key] ?? const <String>{})],
    },
  };

  factory OldGameRecord.fromJson(Map<String, dynamic> json) => OldGameRecord(
    json['winner'],
    notes: json['notes'] ?? '',
    state: OldGameState.fromJson(json['state']),
    commandersA: <String, MtgCard?>{
      for (final entry in (json['commandersA'] as Map).entries)
        entry.key as String: entry.value == null
            ? null
            : MtgCard.fromMap(entry.value),
    },
    commandersB: <String, MtgCard?>{
      for (final entry in (json['commandersB'] as Map).entries)
        entry.key as String: entry.value == null
            ? null
            : MtgCard.fromMap(entry.value),
    },
    startingDateTime: json['dateTime'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['dateTime'])
        : json['state']['startingTime'] ??
              OldGameState.fromJson(json['state']).firstTime,
    customStats: json['customStats'] != null
        ? <String, Set<String>>{
            for (final key in <String>{
              ...(json['customStats'] as Map).keys as Iterable<String>,
            })
              key: <String>{
                ...(((json['customStats'] as Map)[key]) ?? const <String>[]),
              },
          }
        : <String, Set<String>>{},
  );

  //=========================================
  // Getters

  Duration get duration => state.lastTime.difference(startingDateTime).abs();

  bool commanderPlayed(MtgCard card) {
    for (final commander in commandersA.values) {
      if (commander?.oracleId == card.oracleId) return true;
    }
    for (final player in commandersB.keys) {
      if (state.players[player]!.havePartnerB) {
        //a card may still be set for commanderB on a next game without partners
        if (commandersB[player]?.oracleId == card.oracleId) {
          return true;
        }
      }
    }
    return false;
  }

  Set<String> whoPlayedCommander(MtgCard card) {
    return <String>{
      for (final entry in commandersA.entries)
        if (entry.value?.oracleId == card.oracleId) entry.key,
      for (final entry in commandersB.entries)
        if (state.players[entry.key]!.havePartnerB)
          if (entry.value?.oracleId == card.oracleId) entry.key,
    };
  }

  bool commanderPlayedBy(MtgCard card, String? name) {
    if (commandersA[name!]?.oracleId == card.oracleId) return true;
    if (state.players[name]!.havePartnerB) {
      if (commandersB[name]?.oracleId == card.oracleId) {
        return true;
      }
    }
    return false;
  }

  List<MtgCard?> commandersPlayedBy(String name) => <MtgCard?>[
    if (commandersA[name] != null) commandersA[name],
    if (state.players[name]?.havePartnerB ??
        false) // could be no player with that name in this game
      if (commandersB[name] != null) commandersB[name],
  ];
}
