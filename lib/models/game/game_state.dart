import 'package:flutter/widgets.dart';
import 'model.dart';

class GameState {

  //===================================
  // Values

  final DateTime startingTime; 

  Map<String,Player> players;




  //===================================
  // Persistence

  Map<String, dynamic> toJson() => {
    "starting_time": startingTime.toString(),
    "players": {
      for(final entry in players.entries)
        entry.key : entry.value.toJson(),
    },
  };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
    startingTime: DateTime.parse(json["starting_time"]), 
    players: {
      for(final entry in (json["players"] as Map<String, dynamic>).entries)
        entry.key: Player.fromJson(entry.value as Map<String, dynamic>),
    }
  );




  //===================================
  // Constructors

  GameState({
    @required this.startingTime, 
    @required this.players
  });

  factory GameState.start(Set<String> names, {int startingLife = 20}) => GameState(
    startingTime: DateTime.now(),
    players: {
      for(final name in names)
        name: Player.start(name, names, startingLife: startingLife)
    }
  );




  //===================================
  // Getters

  Set<String> get names => players.keys.toSet();
  int historyLenghtSafe(){
    assert(players.isNotEmpty);

    final ls = [
      for(final player in players.values)
        player.states.length,
    ];

    final result = ls.first;
    for(final i in ls){
      assert(i == result);
    }

    return result;
  }
  int get historyLenght{
    assert(players.isNotEmpty);
    return players.values.first.states.length;
  }

  Map<String,PlayerState> get lastPlayerStates => {
    for(final entry in this.players.entries)
      entry.key: entry.value.states.last,
  };

  




  //===================================
  // History Actions

  void applyAction(GameAction action)
    => action.applyTo(this);

  GameAction back(){
    final Map<String,PlayerAction> actions = {
      for(final entry in players.entries)
        entry.key: entry.value.back(),
    };

    return GameAction.fromPlayerActions(actions);
  }

  GameState newGame({int startingLife = 20}){
    assert(startingLife != null);
    return GameState.start(
      this.names,
      startingLife: startingLife,
    );
  }

  GameAction cancelAction(int stateIndex){

    final Map<String,PlayerAction> actions = {
      for(final entry in players.entries)
        entry.key: entry.value.cancelAction(stateIndex),
    };

    return GameAction.fromPlayerActions(actions);
  }


  //===================================
  // Group Actions

  void renamePlayer(String oldName, String newName){
    assert(oldName != null && newName != null);
    assert(newName != "" && oldName != "");
    assert(players.containsKey(oldName));
    assert(!players.containsKey(newName));

    for(final player in players.values){
      player.renamePlayer(oldName, newName);
    }
    players[newName] = players.remove(oldName); 
  }

  void addNewPlayer(String name, {int startingLife = 20}){
    assert(startingLife != null);
    assert(!this.players.containsKey(name));
    assert(name != null);
    assert(name != "");

    final Player player = Player.start(
      name, 
      this.names,
      startingLife: startingLife
    );

    final int catchUp = historyLenght;
    while(player.states.length < catchUp){
      player.applyAction(PANull.instance);
    }

    this.players[player.name] = player;
  }

  void deletePlayer(String name){
    assert(players.containsKey(name));
    this.players.remove(name);
    for(final player in this.players.values){
      player.deletePlayerReferences(name);
    }
  }

}

