import 'package:counter_spell/models/game/old_app/old_commander_settings.dart';
import 'package:counter_spell/models/game/old_app/old_player_state.dart';
import 'package:sid_base/sid_base.dart';

class OldPlayer {
  //===================================
  // Values

  String name;
  OldCommanderSettings commanderSettingsA;
  OldCommanderSettings commanderSettingsB;
  bool havePartnerB;
  bool usePartnerB;

  List<OldPlayerState> states = [];

  //===================================
  // Persistence

  Map<String, dynamic> toJson() => {
    'name': name,
    'havePartnerB': havePartnerB,
    'usePartnerB': usePartnerB,
    'commanderSettingsA': commanderSettingsA.toJson(),
    'commanderSettingsB': commanderSettingsB.toJson(),
    'states': [for (final state in states) state.toJson()],
  };

  factory OldPlayer.fromJson(Map<String, dynamic> json) => OldPlayer(
    json['name'],
    havePartnerB: json['havePartnerB'],
    usePartnerB: json['usePartnerB'],
    commanderSettingsA: OldCommanderSettings.fromJson(
      json['commanderSettingsA'],
    ),
    commanderSettingsB: OldCommanderSettings.fromJson(
      json['commanderSettingsB'],
    ),
    states: [
      for (final stateJson in json['states'])
        OldPlayerState.fromJson(stateJson),
    ],
  );

  //===================================
  // Constructors

  OldPlayer(
    this.name, {
    required this.states,
    required this.commanderSettingsA,
    required this.commanderSettingsB,
    required this.havePartnerB,
    required this.usePartnerB,
  }) : assert(states.isNotEmpty);

  factory OldPlayer.start(
    String name,
    Set<String> others,
    Set<String> counters, {
    required int startingLife,
    OldCommanderSettings? settingsPartnerA,
    OldCommanderSettings? settingsPartnerB,
    bool havePartnerB = false,
  }) => OldPlayer(
    name,
    commanderSettingsA:
        settingsPartnerA ?? OldCommanderSettings.defaultSettings,
    commanderSettingsB:
        settingsPartnerB ?? OldCommanderSettings.defaultSettings,
    havePartnerB: havePartnerB,
    usePartnerB: false,
    states: [
      OldPlayerState.start(
        life: startingLife,
        others: others,
        counters: counters,
      ),
    ],
  );

  //===================================
  // History Actions

  void checkFirstStateTime() {
    ///the first state is often very very in the frikking past because you restart the game
    /// after you finish it, and then you use that restarted game waaay later (even days)
    if (states.length == 1) {
      final DateTime fiveSecondsAgo = DateTime.now().subtract(5.seconds);
      if (states.first.time.isBefore(fiveSecondsAgo)) {
        final OldPlayerState firstState = states.first.hardCopy();
        states[0] = firstState.updateTime(fiveSecondsAgo);
      }
    }
  }

  //===================================
  // Group Actions

  void renamePlayer(String oldName, String newName) {
    //not necessairly renamig this player,
    //maybe renaming an opponent and updating
    //the name keys on the commander damage maps.
    if (oldName == name) {
      name = newName;
    }
    for (final state in states) {
      state.renamePlayerReferences(oldName, newName);
    }
  }

  void deletePlayerReferences(String name) {
    for (final state in states) {
      state.deletePlayerReferences(name);
    }
  }

  void addPlayerReferences(String newPlayerName) {
    for (final state in states) {
      state.addPlayerReferences(newPlayerName);
    }
  }

  //================================================
  // Settings action
  void toggleLifelink(bool partnerA) {
    if (partnerA) {
      commanderSettingsA = commanderSettingsA.toggleLifelink();
    } else {
      commanderSettingsB = commanderSettingsB.toggleLifelink();
    }
  }

  void toggleDamageDefendersLife(bool partnerA) {
    if (partnerA) {
      commanderSettingsA = commanderSettingsA.toggleDamageDefendersLife();
    } else {
      commanderSettingsB = commanderSettingsB.toggleDamageDefendersLife();
    }
  }

  void toggleInfect(bool partnerA) {
    if (partnerA) {
      commanderSettingsA = commanderSettingsA.toggleInfect();
    } else {
      commanderSettingsB = commanderSettingsB.toggleInfect();
    }
  }

  //================================================
  // Info getters
  int get totalLifeGained {
    int gained = 0;
    for (int i = states.length - 1; i > 0; --i) {
      final int delta = states[i].life - states[i - 1].life;
      if (delta > 0) gained += delta;
    }
    return gained;
  }

  int get totalLifeLost {
    int lost = 0;
    for (int i = states.length - 1; i > 0; --i) {
      final int delta = states[i].life - states[i - 1].life;
      if (delta < 0) lost -= delta;
    }
    return lost;
  }

  OldPlayer get frozen {
    return OldPlayer(
      name,
      havePartnerB: havePartnerB,
      usePartnerB: usePartnerB,
      commanderSettingsA: commanderSettingsA,
      commanderSettingsB: commanderSettingsB,
      states: [states.last],
    );
  }

  OldCommanderSettings commanderSettings(bool partnerA) =>
      partnerA ? commanderSettingsA : commanderSettingsB;

  bool lifelink(bool partnerA) => commanderSettings(partnerA).lifelink;
  bool infect(bool partnerA) => commanderSettings(partnerA).infect;
  bool damageDefendersLife(bool partnerA) =>
      commanderSettings(partnerA).damageDefendersLife;
}
