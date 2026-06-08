import 'package:counter_spell/models/game/old_app/old_commander_settings.dart';
import 'package:counter_spell/models/game/old_app/old_player.dart';
import 'package:counter_spell/models/game/old_app/old_player_state.dart';

class OldGameState {
  //===================================
  // Values

  Map<String, OldPlayer> players;

  //===================================
  // Persistence

  Map<String, dynamic> toJson() => {
    'players': {
      for (final entry in players.entries) entry.key: entry.value.toJson(),
    },
  };

  factory OldGameState.fromJson(Map<String, dynamic> json) => OldGameState(
    players: {
      for (final entry in (json['players'] as Map<String, dynamic>).entries)
        entry.key: OldPlayer.fromJson(entry.value as Map<String, dynamic>),
    },
  );

  //===================================
  // Constructors

  OldGameState({required this.players});

  factory OldGameState.start(
    Set<String> names,
    Set<String> counters, {
    int startingLife = 20,
    Map<String, OldCommanderSettings>? settingsPartnersA =
        const <String, OldCommanderSettings>{},
    Map<String, OldCommanderSettings>? settingsPartnersB =
        const <String, OldCommanderSettings>{},
    Map<String, bool?> havePartnerB = const <String, bool?>{},
  }) => OldGameState(
    players: {
      for (final name in names)
        name: OldPlayer.start(
          name,
          names,
          counters,
          startingLife: startingLife,
          havePartnerB: havePartnerB[name] ?? false,
          settingsPartnerA: settingsPartnersA != null
              ? settingsPartnersA[name]
              : null,
          settingsPartnerB: settingsPartnersB != null
              ? settingsPartnersB[name]
              : null,
        ),
    },
  );

  //===================================
  // Getters

  Set<String> get names => players.keys.toSet();

  int get historyLenghtSafe {
    assert(players.isNotEmpty);

    final ls = [for (final player in players.values) player.states.length];

    final result = ls.first;
    for (final i in ls) {
      assert(i == result);
    }

    return result;
  }

  int get historyLenght {
    assert(players.isNotEmpty);
    return players.values.first.states.length;
  }

  String? get winner {
    final List<String> alives = [
      for (final player in players.values)
        if (player.states.last.isAlive) player.name,
    ];
    if (alives.length == 1) {
      return alives.first;
    } else {
      return null;
    }
  }

  int totalDamageDealtFrom(String attacker, {bool partnerA = true}) {
    int total = 0;
    for (final defender in players.values) {
      total += defender.states.last.damages[attacker]!.fromPartner(partnerA);
    }
    return total;
  }

  Map<String, OldPlayerState> get lastPlayerStates => {
    for (final entry in players.entries) entry.key: entry.value.states.last,
  };

  OldGameState get frozen {
    return OldGameState(
      players: {
        for (final player in players.values) player.name: player.frozen,
      },
    );
  }

  // Duration get duration => firstTime.difference(lastTime).abs();
  DateTime get firstTime => players.values.first.states.first.time;
  DateTime get lastTime => players.values.first.states.last.time;

  //===================================
  // History Actions

  OldGameState newGame({
    int startingLife = 20,
    bool? keepCommanderSettings = false,
  }) {
    return OldGameState.start(
      names,
      players.values.first.states.last.counters.keys.toSet(),
      startingLife: startingLife,
      havePartnerB: <String, bool?>{
        for (final player in players.values) player.name: player.havePartnerB,
      },
      settingsPartnersA: (keepCommanderSettings ?? false)
          ? <String, OldCommanderSettings>{
              for (final player in players.values)
                player.name: player.commanderSettingsA,
            }
          : null,
      settingsPartnersB: (keepCommanderSettings ?? false)
          ? <String, OldCommanderSettings>{
              for (final player in players.values)
                player.name: player.commanderSettingsB,
            }
          : null,
    );
  }

  //===================================
  // Group Actions

  void renamePlayer(String oldName, String newName) {
    assert(newName != '' && oldName != '');
    assert(players.containsKey(oldName));
    assert(!players.containsKey(newName));

    for (final player in players.values) {
      player.renamePlayer(oldName, newName);
    }
    players[newName] = players.remove(oldName)!;
  }

  void deletePlayer(String name) {
    assert(players.containsKey(name));
    players.remove(name);
    for (final player in players.values) {
      player.deletePlayerReferences(name);
    }
  }
}
