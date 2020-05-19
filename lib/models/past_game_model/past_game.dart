import 'package:counter_spell_new/core.dart';

class PastGame{

  //=======================================
  // Values
  final GameState state;
  String winner;
  final Map<String,MtgCard> commandersA; //player - commander B
  final Map<String,MtgCard> commandersB; //player - commander B
  String notes;
  final DateTime startingDateTime;


  //=======================================
  // Constructor(s)
  PastGame(this.winner, {
    @required this.state,
    this.notes = "",
    Map<String,MtgCard> commandersA,
    Map<String,MtgCard> commandersB,
    @required this.startingDateTime,
  }): 
    this.commandersA = <String,MtgCard>{
      for(final player in state.players.keys)
        player: commandersA != null ? commandersA[player] : null,
    },
    this.commandersB = <String,MtgCard>{
      for(final player in state.players.keys)
        if(state.players[player].havePartnerB)
          player: commandersB != null ? commandersB[player] : null
        else
          player: null,
    }
  {
    if(this.winner==null){
      this.winner = state.winner;
    } 
  }

  factory PastGame.fromState(GameState state, {
    Map<String,MtgCard> commandersA,
    Map<String,MtgCard> commandersB,
    String notes,
    @required DateTime dateTime,
  }){
    return PastGame(state.winner, 
      state: state,
      commandersA: commandersA,
      commandersB: commandersB,
      notes: notes,
      startingDateTime: dateTime ?? state.players.values.first.states.first.time,
    );
  }


  //=======================================
  // Serialize
  Map<String,dynamic> get toJson => <String,dynamic>{
    "winner": this.winner,
    "notes": this.notes,
    "state": this.state.toJson(),
    "dateTime": this.startingDateTime.millisecondsSinceEpoch,
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
    notes: json["notes"] ?? "",
    state: GameState.fromJson(json["state"]),
    commandersA: <String,MtgCard>{
      for(final entry in (json["commandersA"] as Map).entries)
        entry.key as String : entry.value == null ? null : MtgCard.fromJson(entry.value),
    },
    commandersB: <String,MtgCard>{
      for(final entry in (json["commandersB"] as Map).entries)
        entry.key as String : entry.value == null ? null : MtgCard.fromJson(entry.value),
    },
    startingDateTime: json["dateTime"] != null 
      ? DateTime.fromMillisecondsSinceEpoch(json["dateTime"])
      : json["state"]["startingTime"] ?? GameState.fromJson(json["state"]).firstTime,
  );

  //=========================================
  // Getters

  Duration get duration => this.state.lastTime.difference(this.startingDateTime).abs();

  bool commanderPlayed(MtgCard card){
    for(final commander in this.commandersA.values){
      if(commander?.oracleId == card.oracleId) return true;
    }
    for(final player in this.commandersB.keys){
      if(state.players[player].havePartnerB) //a card may still be set for commanderB on a next game without partners
        if(commandersB[player]?.oracleId == card.oracleId) return true;
    }
    return false;
  }
  Set<String> whoPlayedCommander(MtgCard card){
    return <String>{
      for(final entry in this.commandersA.entries)
        if(entry.value?.oracleId == card.oracleId)
          entry.key,
      for(final entry in this.commandersB.entries)
        if(state.players[entry.key].havePartnerB)
        if(entry.value?.oracleId == card.oracleId)
          entry.key,
    };
  }
  bool commanderPlayedBy(MtgCard card, String name){
    if(this.commandersA[name]?.oracleId == card.oracleId) return true;
    if(this.state.players[name].havePartnerB)
      if(this.commandersB[name]?.oracleId == card.oracleId) return true;
    return false;
  }
  List<MtgCard> commandersPlayedBy(String name) => <MtgCard>[
    if(this.commandersA[name] != null) this.commandersA[name],
    if(this.state.players[name].havePartnerB)
      if(this.commandersB[name] != null) this.commandersB[name],
  ];


}