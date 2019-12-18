import 'package:counter_spell_new/core.dart';


class PastGame{

  //=======================================
  // Values
  final GameState state;
  final DateTime dateTime;
  String winner;
  final Map<String,MtgCard> commandersA;
  final Map<String,MtgCard> commandersB;

  //=======================================
  // Constructor(s)
  PastGame(this.winner, {
    @required this.state,
    @required this.dateTime,
    Map<String,MtgCard> commandersA,
    Map<String,MtgCard> commandersB,
  }): 
    this.commandersA = <String,MtgCard>{
      for(final player in state.players.keys)
        player: commandersA != null ? commandersA[player] : null,
    },
    this.commandersB = <String,MtgCard>{
      for(final player in state.players.keys)
        player: commandersB != null ? commandersB[player] : null,
    }
  {
    if(this.winner==null){
      this.winner = state.winner;
    } 
  }

  factory PastGame.fromState(GameState state, {
    Map<String,MtgCard> commandersA,
    Map<String,MtgCard> commandersB,
  }){
    return PastGame(state.winner, 
      state: state,
      dateTime: state.players.values.first.states.last.time,
      commandersA: commandersA,
      commandersB: commandersB,
    );
  }


  //=======================================
  // Serialize
  Map<String,dynamic> get toJson => <String,dynamic>{
    "winner": this.winner,
    "state": this.state.toJson(),
    "dateTime": this.dateTime.millisecondsSinceEpoch,
    "commandersA": <String,Map<String,dynamic>>{
      for(final entry in this.commandersA.entries)
        entry.key: entry.value?.toJson() ?? null,
    },
    "commandersB": <String,Map<String,dynamic>>{
      for(final entry in this.commandersB.entries)
        entry.key: entry.value?.toJson() ?? null,
    },
  };

  factory PastGame.fromJson(dynamic json) => PastGame(
    json["winner"],
    state: GameState.fromJson(json["state"]),
    dateTime: DateTime.fromMillisecondsSinceEpoch(json["dateTime"]),
    commandersA: <String,MtgCard>{
      for(final entry in (json["commandersA"] as Map).entries)
        entry.key as String : entry.value == null ? null : MtgCard.fromJson(entry.value),
    },
    commandersB: <String,MtgCard>{
      for(final entry in (json["commandersB"] as Map).entries)
        entry.key as String : entry.value == null ? null : MtgCard.fromJson(entry.value),
    },
  );

  //=========================================
  // Getters
  bool commanderPlayed(MtgCard card){
    for(final commander in this.commandersA.values){
      if(commander?.oracleId == card.oracleId) return true;
    }
    for(final commander in this.commandersB.values){
      if(commander?.oracleId == card.oracleId) return true;
    }
    return false;
  }
  Set<String> whoPlayedCommander(MtgCard card){
    return <String>{
      for(final entry in this.commandersA.entries)
        if(entry.value?.oracleId == card.oracleId)
          entry.key,
      for(final entry in this.commandersB.entries)
        if(entry.value?.oracleId == card.oracleId)
          entry.key,
    };
  }
  bool commanderPlayedBy(MtgCard card, String name){
    if(this.commandersA[name]?.oracleId == card.oracleId) return true;
    if(this.commandersB[name]?.oracleId == card.oracleId) return true;
    return false;
  }


}