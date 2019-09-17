import 'package:flutter/widgets.dart';
import 'model.dart';

class Player {

  //===================================
  // Values

  String name;

  List<PlayerState> states = [];




  //===================================
  // Persistence

  Map<String, dynamic> toJson() => {
    "name": name,
    "states": [
      for(final state in states)
        state.toJson(),
    ]
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    json["name"],
    states: [
      for(final stateJson in json["states"])
        PlayerState.fromJson(stateJson),
    ] 
  );



  //===================================
  // Constructors

  Player(this.name, {@required this.states}): 
    assert(name != null),
    assert(states != null),
    assert(states.isNotEmpty);

  factory Player.start(String name, {int startingLife = 20}) 
    => Player(
      name, 
      states: [
        PlayerState(
          time: DateTime.now(),
          life: startingLife, 
        ),
      ]
    );




  //===================================
  // History Actions

  void applyAction(PlayerAction action){
    states.add(
      states.last.applyAction(action)
    );
  }

  PlayerAction back(){
    final PlayerState outgoingState = states.removeLast();
    return PlayerAction.fromStates(
      previous: states.last,
      next: outgoingState,
    );
  }

  void insertAction(int stateIndex, PlayerAction action){
    assert(stateIndex >= 1 && stateIndex < states.length);

    List<PlayerAction> actions = [
      for(int i=states.length-1; i>=stateIndex; --i)
        this.back(),
    ];

    this.applyAction(action);

    while(actions.isNotEmpty){
      this.applyAction(actions.removeLast());
    }

  }

  PlayerAction cancelAction(int stateIndex){
    assert(stateIndex >= 1 && stateIndex < states.length);

    List<PlayerAction> actions = [
      for(int i=states.length-1; i>=stateIndex; --i)
        this.back(),
    ];

    final result = actions.removeLast();

    while(actions.isNotEmpty){
      this.applyAction(actions.removeLast());
    }

    return result;
  }


  //===================================
  // Group Actions

  void renamePlayer(String oldName, String newName){
    //not necessairly renamig this player,
    //maybe renaming an opponent and updating
    //the name keys on the commander damage maps.
    if(oldName == name){
      name = newName;
    }
    for(final state in states){
      state.renamePlayerReferences(oldName, newName);
    }
  }

  void deletePlayerReferences(String name){
    for(final state in states){
      state.deletePlayerReferences(name);
    }
  }
  
}

