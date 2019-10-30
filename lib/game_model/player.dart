import 'package:counter_spell_new/game_model/types/counters.dart';
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

  factory Player.start(
    String name, 
    Set<String> others,
    Set<String> counters,
    {
      int startingLife = 20
    }
  ) => Player(
      name, 
      states: [
        PlayerState.start(
          life: startingLife, 
          others: others,
          counters: counters,
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

  PlayerAction back(Map<String,Counter> counterMap){
    final PlayerState outgoingState = states.removeLast();
    return PlayerAction.fromStates(
      previous: states.last,
      next: outgoingState,
      counterMap: counterMap,
    );
  }

  void insertAction(int stateIndex, PlayerAction action, Map<String,Counter> counterMap){
    assert(stateIndex >= 1 && stateIndex < states.length);

    List<PlayerAction> actions = [
      for(int i=states.length-1; i>=stateIndex; --i)
        this.back(counterMap),
    ];

    this.applyAction(action);

    while(actions.isNotEmpty){
      this.applyAction(actions.removeLast());
    }

  }

  PlayerAction cancelAction(int stateIndex, Map<String,Counter> counterMap){
    assert(stateIndex >= 1 && stateIndex < states.length);

    List<PlayerAction> actions = [
      for(int i=states.length-1; i>=stateIndex; --i)
        this.back(counterMap),
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
  
  void addPlayerReferences(String newPlayerName){

    for(final state in states){
      state.addPlayerReferences(newPlayerName);
    }
  }
}

