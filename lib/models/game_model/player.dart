import 'all.dart';
import 'package:time/time.dart';

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
    "commanderSettingsA": commanderSettingsA.toJson(),
    "commanderSettingsB": commanderSettingsB.toJson(),
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
    required this.states, 
    required this.commanderSettingsA, 
    required this.commanderSettingsB, 
    required this.havePartnerB,
    required this.usePartnerB,
  }): assert(states.isNotEmpty);

  factory Player.start(
    String name, 
    Set<String> others,
    Set<String> counters,
    {
      required int startingLife,
      CommanderSettings? settingsPartnerA,
      CommanderSettings? settingsPartnerB,
      bool havePartnerB = false,
    }
  ) => Player(
      name, 
      commanderSettingsA: settingsPartnerA ?? CommanderSettings.defaultSettings,
      commanderSettingsB: settingsPartnerB ?? CommanderSettings.defaultSettings,
      havePartnerB: havePartnerB,
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
    checkFirstStateTime();
    states.add(
      states.last.applyAction(action)
    );
  }

  void checkFirstStateTime(){
    ///the first state is often very very in the frikking past because you restart the game 
    /// after you finish it, and then you use that restarted game waaay later (even days)
    if(states.length == 1){
      final DateTime fiveSecondsAgo = 5.seconds.ago;
      if(states.first.time.isBefore(fiveSecondsAgo)){
        final PlayerState firstState = states.first.hardCopy();
        states[0] = firstState.updateTime(fiveSecondsAgo);
      }
    }
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
        back(counterMap),
    ];

    applyAction(action);

    while(actions.isNotEmpty){
      applyAction(actions.removeLast());
    }

  }

  PlayerAction cancelAction(int stateIndex, Map<String,Counter> counterMap){
    assert(stateIndex >= 1 && stateIndex < states.length);

    List<PlayerAction> actions = [
      for(int i=states.length-1; i>=stateIndex; --i)
        back(counterMap),
    ];

    final result = actions.removeLast();

    while(actions.isNotEmpty){
      applyAction(actions.removeLast());
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
      commanderSettingsA = commanderSettingsA.toggleLifelink();
    } else {
      commanderSettingsB = commanderSettingsB.toggleLifelink();
    }
  }
  void toggleDamageDefendersLife(bool partnerA){
    if(partnerA){
      commanderSettingsA = commanderSettingsA.toggleDamageDefendersLife();
    } else {
      commanderSettingsB = commanderSettingsB.toggleDamageDefendersLife();
    }
  }
  void toggleInfect(bool partnerA){
    if(partnerA){
      commanderSettingsA = commanderSettingsA.toggleInfect();
    } else {
      commanderSettingsB = commanderSettingsB.toggleInfect();
    }
  }



  //================================================
  // Info getters
  int get totalLifeGained {
    int gained = 0;
    for(int i=states.length-1; i>0; --i){
      final int delta = states[i].life- states[i-1].life;
      if(delta > 0) gained += delta;
    }
    return gained;
  }
  int get totalLifeLost {
    int lost = 0;
    for(int i=states.length-1; i>0; --i){
      final int delta = states[i].life- states[i-1].life;
      if(delta < 0) lost -= delta;
    }
    return lost;
  }

  Player get frozen {
    return Player(name,
      havePartnerB: havePartnerB,
      usePartnerB: usePartnerB,
      commanderSettingsA: commanderSettingsA,
      commanderSettingsB: commanderSettingsB,
      states: [states.last],
    );
  }

  CommanderSettings commanderSettings(bool partnerA) 
    => partnerA ? commanderSettingsA : commanderSettingsB; 

  bool lifelink(bool partnerA) => commanderSettings(partnerA).lifelink;
  bool infect(bool partnerA) => commanderSettings(partnerA).infect;
  bool damageDefendersLife(bool partnerA) => commanderSettings(partnerA).damageDefendersLife;


}

