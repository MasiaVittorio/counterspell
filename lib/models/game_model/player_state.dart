import 'dart:math';

import 'all.dart';

import 'package:flutter/widgets.dart';

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
  int get totalDamageTaken {
    int sum = 0;
    for(final value in this.damages.values){
      sum += value.a;
      sum += value.b;
    }
    return sum;
  }

  bool get isAlive {
    if(life < 1) return false;
    for(final damage in this.damages.values){
      if(damage.a >= 21) return false;
      if(damage.b >= 21) return false;
    }
    if(counters[POISON.longName] >= 10){
      return false;
    }

    return true;
  }



  //===================================
  // Modifiers
  static const kMinValue = -99999999999999;
  static const kMaxValue = 999999999999999;
  PlayerState withLife(
    int life, {
      int minVal = kMinValue, 
      int maxVal = kMaxValue,
    }
  ) => PlayerState.now(
    life: life.clamp(minVal ?? kMinValue, maxVal ?? kMaxValue),
    cast: this.cast,
    damages: this.damages,
    counters: this.counters,
  );
  PlayerState incrementLife(
    int increment, {
      int minVal = kMinValue, 
      int maxVal = kMaxValue,
    }
  ) => this.withLife(this.life + increment, minVal: minVal, maxVal: maxVal);

  PlayerState withDamageFrom(String from, int damage, {
      bool partnerA = true,
      int maxDamage = kMaxValue,
  }) => PlayerState.now(
    life: this.life,
    cast: this.cast,
    counters: this.counters,
    damages: {
      for(final entry in this.damages.entries)
        if(entry.key == from) entry.key: entry.value
          .withDamage(damage, partnerA: partnerA, maxValue: maxDamage,)
        else entry.key: entry.value,
    },
  );
  PlayerState getDamage(String from, int howMuch, {
    bool partnerA = true, 
    bool applyToLife = true,
    int maxDamage = kMaxValue,
    int minLife = kMinValue,
  }){
    PlayerState result = this.withDamageFrom(
      from, 
      this.damages[from].fromPartner(partnerA) + howMuch, 
      partnerA: partnerA,
      maxDamage: maxDamage,
    );
    if(applyToLife){
      return result.incrementLife(-howMuch, 
        minVal: minLife ?? kMinValue, 
        maxVal: maxDamage ?? kMaxValue,
      );
    }
    return result;
  }

  PlayerState withCast(int cast, {bool partnerA=true, int maxCast = kMaxValue}) => PlayerState.now(
    life: this.life,
    damages: this.damages,
    counters: this.counters,
    cast: this.cast.withCast(cast, partnerA: partnerA, maxValue: maxCast),
  );
  PlayerState castAgain(int times, {bool partnerA, int maxCast = kMaxValue}) => this.withCast(
    this.cast.fromPartner(partnerA) + times,
    partnerA: partnerA,
    maxCast: maxCast,
  );

  PlayerState withCounter(Counter counter, int value, {
      int minValue = kMinValue, 
      int maxValue = kMaxValue
  }) => PlayerState.now(
    life: this.life,
    damages: this.damages,
    counters: (){
      Map<String,int> copy = Map.from(this.counters ?? <String,int>{});
      copy[counter.longName] = value.clamp(
        max(minValue, counter.minValue), 
        min(maxValue, counter.maxValue),
      );
      return copy;
    }(),
    cast: this.cast,
  );
  PlayerState incrementCounter(Counter counter, int increment, {
      int minValue = kMinValue, 
      int maxValue = kMaxValue
  }) => this.withCounter(
    counter, 
    (this.counters[counter.longName] ?? 0) + increment,
    minValue: minValue ?? kMinValue,
    maxValue: maxValue ?? kMaxValue,
  );



  //===================================
  // Persistence

  Map<String,dynamic> toJson() => {
    "life": life,
    "time": time.toString(),
    "cast": this.cast.json,
    "damages": <String,dynamic>{
      for(final entry in damages.entries)
        entry.key: entry.value.json,
    },
    "counters": this.counters,
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




  //====================================
  // Constructor

  PlayerState({
    @required this.life,
    @required this.time,
    @required this.damages,
    @required this.cast,
    @required this.counters,
  });
  
  factory PlayerState.now({
    @required int life,
    @required CommanderCast cast,
    @required Map<String,CommanderDamage> damages,
    @required Map<String,int> counters,
   }) => PlayerState(
    life: life,
    time: DateTime.now(),
    cast: cast,
    damages: damages,
    counters: counters,
  );

  factory PlayerState.start({
    @required int life,
    @required Set<String> others,
    @required Set<String> counters,
  }) => PlayerState.now(
    life: life,
    damages: {
      for(final name in others)
        name: CommanderDamage(0),
    },
    cast: CommanderCast(0),
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
    this.damages[newName] = this.damages.remove(oldName)
      ?? CommanderDamage(0);
  }

  void deletePlayerReferences(String name){
    this.damages.remove(name);
  }


  void addPlayerReferences(String newPlayerName){
    this.damages[newPlayerName] = CommanderDamage(0);
  }
  
}
