import 'all.dart';

class GameState {

  //===================================
  // Values

  Map<String,Player> players;


  //===================================
  // Persistence

  Map<String, dynamic> toJson() => {
    "players": {
      for(final entry in players.entries)
        entry.key : entry.value.toJson(),
    },
  };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
    players: {
      for(final entry in (json["players"] as Map<String, dynamic>).entries)
        entry.key: Player.fromJson(entry.value as Map<String, dynamic>),
    }
  );




  //===================================
  // Constructors

  GameState({
    required this.players
  });

  factory GameState.start(
    Set<String> names, 
    Set<String> counters, {
      int startingLife = 20,
      Map<String,CommanderSettings>? settingsPartnersA = const <String,CommanderSettings>{},
      Map<String,CommanderSettings>? settingsPartnersB = const <String,CommanderSettings>{},
      Map<String,bool?>  havePartnerB = const <String,bool>{},
    }
  ) => GameState(
    players: {
      for(final name in names)
        name: Player.start(
          name, 
          names, 
          counters, 
          startingLife: startingLife,
          havePartnerB: havePartnerB[name] ?? false,
          settingsPartnerA: settingsPartnersA != null ? settingsPartnersA[name] : null,
          settingsPartnerB: settingsPartnersB != null ? settingsPartnersB[name] : null,
        ),
    }
  );




  //===================================
  // Getters

  Set<String> get names => players.keys.toSet();
  
  int get historyLenghtSafe {
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

  String? get winner {
    final List<String> alives = [
      for(final player in this.players.values)
        if(player.states.last.isAlive) 
          player.name,
    ];
    if(alives.length == 1){
      return alives.first;
    } else {
      return null;
    }
  }

  int totalDamageDealtFrom(String attacker, {bool partnerA = true}){
    int total = 0;
    for(final defender in players.values){
      total += defender.states.last.damages[attacker]!.fromPartner(partnerA);
    }
    return total;
  }

  Map<String,PlayerState> get lastPlayerStates => {
    for(final entry in this.players.entries)
      entry.key: entry.value.states.last,
  };

  GameState get frozen {
    return GameState(
      players: {for(final player in this.players.values)
        player.name: player.frozen,
      },
    );
  }

  // Duration get duration => firstTime.difference(lastTime).abs();
  DateTime get firstTime => this.players.values.first.states.first.time;
  DateTime get lastTime => this.players.values.first.states.last.time;

  




  //===================================
  // History Actions

  void applyAction(GameAction action)
    => action.applyTo(this);

  GameAction back(Map<String,Counter> counterMap){
    final Map<String,PlayerAction> actions = {
      for(final entry in players.entries)
        entry.key: entry.value.back(counterMap),
    };

    return GameAction.fromPlayerActions(actions);
  }

  GameState newGame({int startingLife = 20, bool? keepCommanderSettings = false}){
    return GameState.start(
      this.names,
      this.players.values.first.states.last.counters.keys.toSet(),
      startingLife: startingLife,
      havePartnerB: <String,bool?>{
        for(final player in this.players.values)
          player.name : player.havePartnerB,
      },
      settingsPartnersA: (keepCommanderSettings ?? false) 
        ? <String,CommanderSettings>{
          for(final player in this.players.values)
            player.name : player.commanderSettingsA,
        }
        : null,
      settingsPartnersB: (keepCommanderSettings ?? false) 
        ? <String,CommanderSettings>{
          for(final player in this.players.values)
            player.name : player.commanderSettingsB,
        }
        : null,
    );
  }

  GameAction cancelAction(int stateIndex, Map<String,Counter>counterMap){

    final Map<String,PlayerAction> actions = {
      for(final entry in players.entries)
        entry.key: entry.value.cancelAction(stateIndex, counterMap),
    };

    return GameAction.fromPlayerActions(actions);
  }


  //===================================
  // Group Actions

  void renamePlayer(String oldName, String newName){
    assert(newName != "" && oldName != "");
    assert(players.containsKey(oldName));
    assert(!players.containsKey(newName));

    for(final player in players.values){
      player.renamePlayer(oldName, newName);
    }
    players[newName] = players.remove(oldName)!; 
  }

  void addNewPlayer(String name, {int startingLife = 20}){
    assert(!this.players.containsKey(name));
    assert(name != "");

    final Player player = Player.start(
      name, 
      {...this.names, name},
      this.players.values.first.states.last.counters.keys.toSet(),
      startingLife: startingLife
    );

    final int catchUp = historyLenght;
    while(player.states.length < catchUp){
      player.applyAction(PANull.instance);
    }

    for(final player in players.values){
      player.addPlayerReferences(name);
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

