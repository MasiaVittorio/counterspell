import 'package:counter_spell_new/models/game/model.dart';
import 'package:flutter/widgets.dart';

class PlayerState {


  //===================================
  // Values
  final DateTime time;

  final int life;

  //LOW PRIORITY: implementa commander damage (insieme a rename references e delete references)



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
  );
  PlayerState incrementLife(
    int increment, {
      int minVal = kMinValue, 
      int maxVal = kMaxValue,
    }
  ) => this.withLife(this.life + increment, minVal: minVal, maxVal: maxVal);



  //===================================
  // Persistence

  Map<String,dynamic> toJson() => {
    "life": life,
    "time": time.toString(),
  };

  factory PlayerState.fromJson(Map<String,dynamic> json) => PlayerState(
    life: json["life"],
    time: DateTime.parse(json["time"]),
  );




  //====================================
  // Constructor

  PlayerState({
    @required this.life,
    @required this.time,
  });
  
  factory PlayerState.now({
    @required int life,
  }) => PlayerState(
    life: life,
    time: DateTime.now(),
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
