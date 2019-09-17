import 'package:counter_spell_new/models/game/game_state.dart';
import 'package:counter_spell_new/models/game/player_state.dart';
import 'package:counter_spell_new/models/game/types/damage_type.dart';
import 'package:flutter/material.dart';

class GameHistoryData{
  final Map<String, List<PlayerHistoryChange>> changes;
  final DateTime time;
  GameHistoryData(this.time, this.changes);

  factory GameHistoryData.fromStates(
    GameState gameState,
    int previous,
    int next,
    { Map<DamageType, bool> types = allTypesEnabled }
  ) => GameHistoryData(
    gameState.players.values.first.states[next].time,
    {
      for(final entry in gameState.players.entries)
        entry.key : PlayerHistoryChange.changesFromStates(
          previous: entry.value.states[previous],
          next: entry.value.states[next],
          types: types,
        ),
    }
  );
}

class PlayerHistoryChange{
  final int previous;
  final int next;
  final DamageType type;
  final bool attack;
  final String counterName;

  PlayerHistoryChange({
    @required this.type,
    @required this.previous,
    @required this.next,
    this.attack,
    this.counterName,
  }): 
    assert(!(type == DamageType.commanderDamage && attack == null)),
    assert(!(type == DamageType.counters && counterName == null));

  static List<PlayerHistoryChange> changesFromStates({
    @required PlayerState previous, 
    @required PlayerState next,
    @required Map<DamageType, bool> types,
  })
    => [
      if(previous.life != next.life)
        PlayerHistoryChange(
          previous: previous.life,
          next: next.life,
          type: DamageType.life,
        ),
    ];
}

class GameHistoryNull extends GameHistoryData {
  final GameState gameState;
  final int index;
  GameHistoryNull(
    this.gameState,
    this.index,
  ):super(null, null);

}