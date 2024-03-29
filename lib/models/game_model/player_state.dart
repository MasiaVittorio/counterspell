import 'dart:convert';
import 'dart:math';

import 'all.dart';


class PlayerState {


  //===================================
  // Values
  final DateTime time;

  final int life;

  //damage TAKEN
  final Map<String,CommanderDamage> damages;

  final CommanderCast cast;

  final Map<String,int> counters;


  //===================================
  // Getters
  int get totalCasts => cast.a + cast.b;
  int get totalDamageTaken {
    int sum = 0;
    for(final value in damages.values){
      sum += value.a;
      sum += value.b;
    }
    return sum;
  }

  bool get isAlive {
    if(life< 1) return false;
    for(final damage in damages.values){
      if(damage.a >= 21) return false;
      if(damage.b >= 21) return false;
    }
    if(counters[Counter.poison.longName]! >= 10){
      return false;
    }

    return true;
  }



  //===================================
  // Modifiers
  static const kMinValue = -99999999999999;
  static const kMaxValue = 999999999999999;
  PlayerState hardCopy() => PlayerState(
    life: life+ 0, 
    time: DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch + 0), 
    damages: <String,CommanderDamage>{for(final entry in damages.entries) entry.key: entry.value.copy(),}, 
    cast: cast.copy(), 
    counters: <String,int>{for(final entry in counters.entries) entry.key: entry.value + 0,},
  );

  PlayerState updateTime([DateTime? newTime]) => newTime == null
    ? PlayerState.now(
      life: life,
      cast: cast,
      damages: damages,
      counters: counters,
    )
    : PlayerState(
      time: newTime,
      life: life,
      cast: cast,
      damages: damages,
      counters: counters,
    );

  PlayerState withLife(
    int life, {
      int minVal = kMinValue, 
      int maxVal = kMaxValue,
    }
  ) => PlayerState.now(
    life: life.clamp(minVal, maxVal),
    cast: cast,
    damages: damages,
    counters: counters,
  );
  PlayerState incrementLife(
    int increment, {
      int minVal = kMinValue, 
      int maxVal = kMaxValue,
    }
  ) => withLife(life+ increment, minVal: minVal, maxVal: maxVal);

  PlayerState withDamageFrom(String from, int damage, {
      bool partnerA = true,
      int maxDamage = kMaxValue,
  }) => PlayerState.now(
    life: life,
    cast: cast,
    counters: counters,
    damages: {
      for(final entry in damages.entries)
        if(entry.key == from) entry.key: entry.value
          .withDamage(damage, partnerA: partnerA, maxValue: maxDamage,)
        else entry.key: entry.value,
    },
  );
  PlayerState getDamage(String from, int howMuch, {
    required CommanderSettings settings,
    bool partnerA = true, 
    int maxDamage = kMaxValue,
    int minLife = kMinValue,
  }){
    PlayerState result = withDamageFrom(
      from, 
      damages[from]!.fromPartner(partnerA) + howMuch, 
      partnerA: partnerA,
      maxDamage: maxDamage,
    );
    if(settings.damageDefendersLife){
      result = result.incrementLife(-howMuch, 
        minVal: minLife, 
        maxVal: maxDamage,
      );
    } else if(settings.infect){
      result = result.incrementCounter(Counter.poison, howMuch);
    }
    return result;
  }

  PlayerState withCast(int cast, {bool partnerA=true, int maxCast = kMaxValue}) => PlayerState.now(
    life: life,
    damages: damages,
    counters: counters,
    cast: this.cast.withCast(cast, partnerA: partnerA, maxValue: maxCast),
  );
  PlayerState castAgain(int times, {required bool partnerA, int maxCast = kMaxValue}) => withCast(
    cast.fromPartner(partnerA) + times,
    partnerA: partnerA,
    maxCast: maxCast,
  );

  PlayerState withCounter(Counter counter, int value, {
      int minValue = kMinValue, 
      int maxValue = kMaxValue
  }) => PlayerState.now(
    life: life,
    damages: damages,
    counters: (){
      Map<String,int> copy = Map.from(counters);
      copy[counter.longName] = value.clamp(
        max(minValue, counter.minValue), 
        min(maxValue, counter.maxValue),
      );
      return copy;
    }(),
    cast: cast,
  );
  PlayerState incrementCounter(Counter counter, int increment, {
      int minValue = kMinValue, 
      int maxValue = kMaxValue
  }) => withCounter(
    counter, 
    (counters[counter.longName] ?? 0) + increment,
    minValue: minValue,
    maxValue: maxValue,
  );



  //===================================
  // Persistence

  Map<String,dynamic> toJson() => {
    "life": life,
    "time": time.toString(),
    "cast": cast.json,
    "damages": <String,dynamic>{
      for(final entry in damages.entries)
        entry.key: entry.value.json,
    },
    "counters": counters,
  };

  factory PlayerState.fromJson(Map<String,dynamic> json) => PlayerState(
    life: json["life"],
    time: DateTime.parse(json["time"]),
    cast: CommanderCast.fromJson(json["cast"]),
    damages: <String,CommanderDamage>{
      for(final entry in ((json["damages"] ?? {}) as Map<String,dynamic>).entries)
        entry.key: CommanderDamage.fromJson(entry.value),
    },
    counters: <String,int>{
      for(final entry in ((json["counters"] ?? {}) as Map<String,dynamic>).entries)
        entry.key : entry.value as int,
    },
  );

  @override
  bool operator ==(Object other){
    if(other is PlayerState){
      if(jsonEncode(other.toJson()) == jsonEncode(toJson())){
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override int get hashCode => jsonEncode(toJson()).hashCode;


  //====================================
  // Constructor

  PlayerState({
    required this.life,
    required this.time,
    required this.damages,
    required this.cast,
    required this.counters,
  });
  
  factory PlayerState.now({
    required int life,
    required CommanderCast cast,
    required Map<String,CommanderDamage> damages,
    required Map<String,int> counters,
   }) => PlayerState(
    life: life,
    time: DateTime.now(),
    cast: cast,
    damages: damages,
    counters: counters,
  );

  factory PlayerState.start({
    required int life,
    required Set<String> others,
    required Set<String> counters,
  }) => PlayerState.now(
    life: life,
    damages: {
      for(final name in others)
        name: const CommanderDamage(0),
    },
    cast: const CommanderCast(0),
    counters: {
      for(final counter in counters)
        counter: 0,
    },
  );



  //====================================
  // History Actions

  PlayerState applyAction(PlayerAction action) 
    => action.apply(this);




  //====================================
  // Group Actions

  void renamePlayerReferences(String oldName, String newName){
    //not necessairly renamig this player,
    //maybe renaming an opponent and updating
    //the name keys on the commander damage maps.
    damages[newName] = damages.remove(oldName)
      ?? const CommanderDamage(0);
  }

  void deletePlayerReferences(String name){
    damages.remove(name);
  }


  void addPlayerReferences(String newPlayerName){
    damages[newPlayerName] = const CommanderDamage(0);
  }
  
}
