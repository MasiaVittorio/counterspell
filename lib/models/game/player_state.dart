import 'package:counter_spell_new/models/game/model.dart';
import 'package:flutter/widgets.dart';

class CommanderDamage{
  //different partners
  final int a;
  final int b;

  int fromPartner(bool partnerA) => partnerA ? a:b;
  
  const CommanderDamage(this.a, [this.b = 0])
      : assert(a!=null && b!=null), 
        assert(a>=0 && b>=0);
 
  dynamic get json => <int>[this.a, this.b];
  static CommanderDamage fromJson(dynamic json) => CommanderDamage(
    (json as List)[0] as int,
    (json as List)[1] as int,
  ); 
  int get total => a+b;
  int getTotal({bool alsoB = true}) => a +  (alsoB==true ? b : 0);

  CommanderDamage withDamage(int damage, {
      bool partnerA = true, 
      int maxValue = PlayerState.kMaxValue
  }) => CommanderDamage(
    (partnerA ? damage : a).clamp(0, maxValue ?? PlayerState.kMaxValue),
    (!partnerA ? damage : b).clamp(0, maxValue ?? PlayerState.kMaxValue),
  );
}
class CommanderCast extends CommanderDamage{
  const CommanderCast(int a, [int b = 0]): super(a,b);
  static CommanderCast fromDamage(CommanderDamage damage)=> CommanderCast(damage.a ?? 0, damage.b ?? 0);
  static CommanderCast fromJson(dynamic json) => fromDamage(CommanderDamage.fromJson(json));
  CommanderCast withCast(int cast, {
      bool partnerA = true,
      int maxValue = PlayerState.kMaxValue,
  }) => CommanderCast(
    (partnerA ? cast : a).clamp(0, maxValue ?? PlayerState.kMaxValue),
    (!partnerA ? cast : b).clamp(0, maxValue ?? PlayerState.kMaxValue),
  );
}

class PlayerState {


  //===================================
  // Values
  final DateTime time;

  final int life;

  //damage TAKEN
  final Map<String,CommanderDamage> damages;

  final CommanderCast cast;

  //LOW PRIORITY: implementa commander damage (insieme a rename references e delete references)

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
    cast: this.cast.withCast(cast, partnerA: partnerA, maxValue: maxCast),
  );
  PlayerState castAgain(int times, {bool partnerA, int maxCast = kMaxValue}) => this.withCast(
    this.cast.fromPartner(partnerA) + times,
    partnerA: partnerA,
    maxCast: maxCast,
  );




  //===================================
  // Persistence

  Map<String,dynamic> toJson() => {
    "life": life,
    "time": time.toString(),
    "damages": <String,dynamic>{
      for(final entry in damages.entries)
        entry.key: entry.value.json,
    },
    "cast": this.cast.json,
  };

  factory PlayerState.fromJson(Map<String,dynamic> json) => PlayerState(
    life: json["life"],
    time: DateTime.parse(json["time"]),
    damages: <String,CommanderDamage>{
      for(final entry in (json["damages"] as Map<String,dynamic>).entries)
        entry.key: CommanderDamage.fromJson(entry.value),
    },
    cast: CommanderCast.fromJson(json["cast"]),
  );




  //====================================
  // Constructor

  PlayerState({
    @required this.life,
    @required this.time,
    @required this.damages,
    @required this.cast,
  });
  
  factory PlayerState.now({
    @required int life,
    @required CommanderCast cast,
    @required Map<String,CommanderDamage> damages,
   }) => PlayerState(
    life: life,
    time: DateTime.now(),
    cast: cast,
    damages: damages,
  );

  factory PlayerState.start({
    @required int life,
    @required Set<String> others,
  }) => PlayerState.now(
    life: life,
    damages: {
      for(final name in others)
        name: CommanderDamage(0),
    },
    cast: CommanderCast(0),
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

  }

  void deletePlayerReferences(String name){

  }

  
}
