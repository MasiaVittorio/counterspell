import 'package:flutter/widgets.dart';
import 'all.dart';

class Player {

  //===================================
  // Values

  String name;
  CommanderSettings commanderSettingsA;
  CommanderSettings commanderSettingsB;
  bool havePartnerB;
  bool usePartnerB;
  
  List<PlayerState> states = [];




  //===================================
  // Persistence

  Map<String, dynamic> toJson() => {
    "name": name,
    "havePartnerB": havePartnerB,
    "usePartnerB": usePartnerB,
    "commanderSettingsA": this.commanderSettingsA.toJson,
    "commanderSettingsB": this.commanderSettingsB.toJson,
    "states": [
      for(final state in states)
        state.toJson(),
    ],
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    json["name"],
    havePartnerB: json["havePartnerB"],
    usePartnerB: json["usePartnerB"],
    commanderSettingsA: CommanderSettings.fromJson(json["commanderSettingsA"]),
    commanderSettingsB: CommanderSettings.fromJson(json["commanderSettingsB"]),
    states: [
      for(final stateJson in json["states"])
        PlayerState.fromJson(stateJson),
    ] 
  );



  //===================================
  // Constructors

  Player(this.name, {
    @required this.states, 
    @required this.commanderSettingsA, 
    @required this.commanderSettingsB, 
    @required this.havePartnerB,
    @required this.usePartnerB,
  }): 
    assert(name != null),
    assert(states != null),
    assert(commanderSettingsA != null),
    assert(commanderSettingsB != null),
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
      commanderSettingsA: CommanderSettings.defaultSettings,
      commanderSettingsB: CommanderSettings.defaultSettings,
      havePartnerB: false,
      usePartnerB: false,
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


  //================================================
  // Settings action
  void toggleLifelink(bool partnerA){
    if(partnerA){
      this.commanderSettingsA = this.commanderSettingsA.toggleLifelink();
    } else {
      this.commanderSettingsB = this.commanderSettingsB.toggleLifelink();
    }
  }
  void toggleDamageDefendersLife(bool partnerA){
    if(partnerA){
      this.commanderSettingsA = this.commanderSettingsA.toggleDamageDefendersLife();
    } else {
      this.commanderSettingsB = this.commanderSettingsB.toggleDamageDefendersLife();
    }
  }
  void toggleInfect(bool partnerA){
    if(partnerA){
      this.commanderSettingsA = this.commanderSettingsA.toggleInfect();
    } else {
      this.commanderSettingsB = this.commanderSettingsB.toggleInfect();
    }
  }



  //================================================
  // Info getters
  int get totalLifeGained {
    int gained = 0;
    for(int i=this.states.length-1; i>0; --i){
      final int delta = states[i].life - states[i-1].life;
      if(delta > 0) gained += delta;
    }
    return gained;
  }
  int get totalLifeLost {
    int lost = 0;
    for(int i=this.states.length-1; i>0; --i){
      final int delta = states[i].life - states[i-1].life;
      if(delta < 0) lost -= delta;
    }
    return lost;
  }

  CommanderSettings commanderSettings(bool partnerA) 
    => partnerA ? this.commanderSettingsA : this.commanderSettingsB; 

  bool lifelink(bool partnerA) => this.commanderSettings(partnerA).lifelink;
  bool infect(bool partnerA) => this.commanderSettings(partnerA).infect;
  bool damageDefendersLife(bool partnerA) => this.commanderSettings(partnerA).damageDefendersLife;


}

