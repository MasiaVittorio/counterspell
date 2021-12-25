import 'game_state.dart';
import 'player_state.dart';
import 'types/counters.dart';
import 'types/damage_type.dart';

class GameHistoryData{
  final Map<String, List<PlayerHistoryChange>>? changes;
  final DateTime? time;
  GameHistoryData(this.time, this.changes);

  factory GameHistoryData.fromStates(
    GameState gameState,
    int previous,
    int next, { 
      required Map<DamageType, bool?> types,
      required Map<String?,Counter> counterMap,
    }
  ) {
    final allNext = {
      for(final eEntry in gameState.players.entries)
        eEntry.key : eEntry.value!.states[next],
    };
    final allPrevs = {
      for(final eEntry in gameState.players.entries)
        eEntry.key : eEntry.value!.states[previous],
    };
    return GameHistoryData(
      gameState.players.values.first!.states[next].time,
      {
        for(final entry in gameState.players.entries)
          entry.key : PlayerHistoryChange.changesFromStates(
            playerName: entry.key,
            nextOthers: allNext,
            previousOthers: allPrevs,
            previous: entry.value!.states[previous],
            next: entry.value!.states[next],
            types: types,
            havingPartnerB: <String,bool?>{
              for(final entry in gameState.players.entries)
                entry.key: entry.value!.havePartnerB,
            },
            counterMap: counterMap,
          ),
      }
    );
  }
}

class PlayerHistoryChange{
  final int? previous;
  final int? next;
  final DamageType type;
  final bool? attack;
  final Counter? counter;
  final bool? partnerA;

  PlayerHistoryChange({
    required this.type,
    required this.previous,
    required this.next,
    this.attack,
    this.counter,
    this.partnerA,
  }): 
    assert(!(type == DamageType.commanderDamage && (attack==null || (attack==true&&partnerA==null)))),
    assert(!(type == DamageType.commanderCast && partnerA==null)),
    assert(!(type == DamageType.counters && counter == null));

  static List<PlayerHistoryChange> changesFromStates({
    required String playerName,
    required PlayerState previous, 
    required PlayerState next,
    required Map<DamageType, bool?> types,
    required Map<String,PlayerState> previousOthers,
    required Map<String,PlayerState> nextOthers,
    required Map<String,bool?> havingPartnerB,
    required Map<String?,Counter> counterMap,
  }){
    return [
      if(previous.life != next.life)
        PlayerHistoryChange(
          previous: previous.life,
          next: next.life,
          type: DamageType.life,
        ),
      if(types[DamageType.commanderCast]!)
      if(previous.cast.a != next.cast.a)
        PlayerHistoryChange(
          type: DamageType.commanderCast,
          previous: previous.cast.a,
          next: next.cast.a,
          partnerA: true,
        ),
      if(havingPartnerB[playerName]==true)
      if(types[DamageType.commanderCast]!)
      if(previous.cast.b != next.cast.b)
        PlayerHistoryChange(
          type: DamageType.commanderCast,
          previous: previous.cast.b,
          next: next.cast.b,
          partnerA: false,
        ),
      if(types[DamageType.commanderDamage]!)
        ...(){
          //first player to have damaged our player is shown
          for(final damageEntry in previous.damages.entries){
            if(damageEntry.value.a != next.damages[damageEntry.key]!.a){
              return [PlayerHistoryChange(
                previous: damageEntry.value.a,
                next: next.damages[damageEntry.key]!.a,
                type: DamageType.commanderDamage,
                attack: false,
              )];
            }
            if(havingPartnerB[damageEntry.key]==true){
              if(damageEntry.value.b != next.damages[damageEntry.key]!.b){
                return [PlayerHistoryChange(
                  previous: damageEntry.value.b,
                  next: next.damages[damageEntry.key]!.b,
                  type: DamageType.commanderDamage,
                  attack: false,
                )];
              }
            }
          }
          return [];
        }() as Iterable<PlayerHistoryChange>,
      if(types[DamageType.commanderDamage]!)
        ...(){
          //first player to be damaged by our player is shown
          for(final otherPrev in previousOthers.entries){
            final otherNextValue = nextOthers[otherPrev.key]!;
            if(otherPrev.value.damages[playerName]!.a != otherNextValue.damages[playerName]!.a){
              return [PlayerHistoryChange(
                previous: otherPrev.value.damages[playerName]!.a,
                next: otherNextValue.damages[playerName]!.a,
                type: DamageType.commanderDamage,
                attack: true,
                partnerA: true,
              )];
            }
            if(havingPartnerB[playerName]==true){
              if(otherPrev.value.damages[playerName]!.b != otherNextValue.damages[playerName]!.b){
                return [PlayerHistoryChange(
                  previous: otherPrev.value.damages[playerName]!.b,
                  next: otherNextValue.damages[playerName]!.b,
                  type: DamageType.commanderDamage,
                  attack: true,
                  partnerA: false,
                )];
              }
            }
          }
          return [];

        }() as Iterable<PlayerHistoryChange>,
      if(types[DamageType.counters]!)
        ...(){
          final Set<String?> counters = {
            ...(previous.counters.keys),
            ...(next.counters.keys),
          };
          return [
            for(final name in counters)
              if((previous.counters[name] ?? 0) != (next.counters[name] ?? 0))
                PlayerHistoryChange(
                  type: DamageType.counters,
                  counter: counterMap[name],
                  next: next.counters[name] ?? 0,
                  previous: previous.counters[name] ?? 0,
                ),
          ];
        }()

    ];
  }

  static int damageDealt(String name, Map<String,PlayerState> others, bool partnerA){
    int sum = 0;
    for(final entry in others.entries){
      sum += entry.value.damages[name]!.fromPartner(partnerA);
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