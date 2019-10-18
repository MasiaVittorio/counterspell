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
  ) {
    final allNext = {
      for(final eEntry in gameState.players.entries)
        eEntry.key : eEntry.value.states[next],
    };
    final allPrevs = {
      for(final eEntry in gameState.players.entries)
        eEntry.key : eEntry.value.states[previous],
    };
    return GameHistoryData(
      gameState.players.values.first.states[next].time,
      {
        for(final entry in gameState.players.entries)
          entry.key : PlayerHistoryChange.changesFromStates(
            playerName: entry.key,
            nextOthers: allNext,
            previousOthers: allPrevs,
            previous: entry.value.states[previous],
            next: entry.value.states[next],
            types: types,
          ),
      }
    );
  }
}

class PlayerHistoryChange{
  final int previous;
  final int next;
  final DamageType type;
  final bool attack;
  final String counterName;
  final bool partnerA;

  PlayerHistoryChange({
    @required this.type,
    @required this.previous,
    @required this.next,
    this.attack,
    this.counterName,
    this.partnerA,
  }): 
    assert(!(type == DamageType.commanderDamage && (attack==null || (attack==true&&partnerA==null)))),
    assert(!(type == DamageType.commanderCast && partnerA==null)),
    assert(!(type == DamageType.counters && counterName == null));

  static List<PlayerHistoryChange> changesFromStates({
    @required String playerName,
    @required PlayerState previous, 
    @required PlayerState next,
    @required Map<DamageType, bool> types,
    @required Map<String,PlayerState> previousOthers,
    @required Map<String,PlayerState> nextOthers,
  }){
    return [
      if(previous.life != next.life)
        PlayerHistoryChange(
          previous: previous.life,
          next: next.life,
          type: DamageType.life,
        ),
      if(types[DamageType.commanderCast])
      if(previous.cast.a != next.cast.a)
        PlayerHistoryChange(
          type: DamageType.commanderCast,
          previous: previous.cast.a,
          next: next.cast.a,
          partnerA: true,
        ),
      if(types[DamageType.commanderCast])
      if(previous.cast.b != next.cast.b)
        PlayerHistoryChange(
          type: DamageType.commanderCast,
          previous: previous.cast.b,
          next: next.cast.b,
          partnerA: false,
        ),
      if(types[DamageType.commanderDamage])
      if(previous.totalDamageTaken != next.totalDamageTaken)
        PlayerHistoryChange(
          type: DamageType.commanderDamage,
          previous: previous.totalDamageTaken,
          next: next.totalDamageTaken,
          attack: false,
        ),
      if(types[DamageType.commanderDamage])
        ...(){
          final prevDealtA = damageDealt(playerName, previousOthers , true);
          final nextDealtA = damageDealt(playerName, nextOthers     , true);
          final prevDealtB = damageDealt(playerName, previousOthers , false);
          final nextDealtB = damageDealt(playerName, nextOthers     , false);
          return <PlayerHistoryChange>[
            if(prevDealtA != nextDealtA)
              PlayerHistoryChange(
                type: DamageType.commanderCast,
                previous: prevDealtA,
                next: nextDealtA,
                partnerA: true,
              ),
            if(prevDealtB != nextDealtB)
              PlayerHistoryChange(
                type: DamageType.commanderCast,
                previous: prevDealtB,
                next: nextDealtB,
                partnerA: false,
              ),
          ];
        }()

    ];
  }

  static int damageDealt(String name, Map<String,PlayerState> others, bool partnerA){
    int sum = 0;
    for(final entry in others.entries){
      sum += entry.value.damages[name].fromPartner(partnerA);
    }
    return sum;
  }

}

class GameHistoryNull extends GameHistoryData {
  final GameState gameState;
  final int index;
  GameHistoryNull(
    this.gameState,
    this.index,
  ):super(null, null);

}