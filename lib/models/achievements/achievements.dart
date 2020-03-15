import 'package:flutter/widgets.dart';
import 'package:counter_spell_new/core.dart'; 

abstract class Achievement {

  //=================================
  // Values =====================
  final String shortTitle;
  final String title;
  final String text;
  final int targetBronze;
  final int targetSilver;
  final int targetGold;


  //=====================================
  // Constructor =====================
  const Achievement(this.shortTitle,{
    @required this.title,
    @required this.text,
    @required this.targetBronze,
    @required this.targetSilver,
    @required this.targetGold,
  });

  //=====================================
  // Getters ========================
  int get count;
  bool get bronze => count >= targetBronze;
  bool get silver => count >= targetSilver;
  bool get gold => count >= targetGold;

  Achievement get reset; 

  Achievement updateStats(Achievement updated);

  //=====================================
  // Data ===========================
  static const String countersShortTitle = "Counters master";
  static const Achievement counters = QualityAchievement(
    countersShortTitle,
    title: "Track different counters in a single game",
    text: 'You can select a new counter in the "Counters" page by tapping on the icon at the right of the bottom panel',
    targets: <String,bool>{
      Counter.poisonLongName: false,
      Counter.experienceLongName: false,
      Counter.stormLongName: false,
      Counter.manaLongName: false,
      Counter.blessingLongName: false,
      Counter.monarchLongName: false,
      Counter.energyLongName: false,
    },
    targetBronze: 3,
    targetSilver: 5,
    targetGold: 7,
  );
  static const String uiExpertShortTitle = "UI expert";
  static const Achievement uiExpert = QualityAchievement(
    uiExpertShortTitle,
    title: "Restart the game or edit the playgroup in different ways",
    text: "You can use the closed panel's right button (History and Life pages) or the main menu's buttons (\"Game\" tab)",
    targets: <String,bool>{
      "Restart panel": false,
      "Restart menu": false,
      "Playgroup panel": false,
      "Playgroup menu": false,
    },
    targetBronze: 2,
    targetSilver: 3,
    targetGold: 4,
  );
  static const String rollerShortTitle = "The roller";
  static const Achievement roller = QuantityAchievement(
    rollerShortTitle,
    title: "Flip a ton of coins, roll a bunch of dice",
    text: 'Open the main menu. In the "Game" tab you\'ll find the "Random" button',
    currentCount: 0,
    targetBronze: 10,
    targetSilver: 25,
    targetGold: 50,
  );
  static const List<Achievement> all = [
    counters,
    uiExpert,
    roller,
  ];



  //=========================================
  // Persistence ========================
  dynamic get json;

  factory Achievement.fromJson(dynamic json){
    if(json["type"] == "quantity"){
      return QuantityAchievement.fromJson(json);
    } else {
      return QualityAchievement.fromJson(json);
    }
  }

}



class QuantityAchievement extends Achievement {

  //=================================
  // Values =====================
  final int currentCount;


  // =====================================
  // Constructor =====================
  const QuantityAchievement(String shortTitle, {
    String title,
    String text,
    @required this.currentCount,
    int targetBronze,
    int targetSilver,
    int targetGold,
  }) : super(
    shortTitle, 
    title: title, 
    text: text,
    targetBronze: targetBronze,
    targetSilver: targetSilver,
    targetGold: targetGold,
  );


  //=====================================
  // Getters ========================
  @override 
  int get count => this.currentCount;

  QuantityAchievement withCount(int newCount) => QuantityAchievement(
    this.shortTitle,
    title: this.title,
    text: this.text,
    targetBronze: this.targetBronze,
    targetSilver: this.targetSilver,
    targetGold: this.targetGold,
    currentCount: newCount,
  );

  QuantityAchievement get increment => withCount((this.count +1).clamp(0, this.targetGold));
  QuantityAchievement get decrement => withCount((this.count -1).clamp(0, this.targetGold));

  @override
  QuantityAchievement get reset => withCount(0);

  @override
  QuantityAchievement updateStats(Achievement updated){
    if(updated is QuantityAchievement && updated.shortTitle == this.shortTitle){
      return updated.withCount(this.count);
    } else return this;
  }

  //=========================================
  // Persistence ========================
  dynamic get json => <String,dynamic>{
    "type": "quantity",
    "title": this.title,
    "shortTitle": this.shortTitle,
    "text": this.text,
    "currentCount": this.currentCount,
    "targetBronze": this.targetBronze,
    "targetSilver": this.targetSilver,
    "targetGold": this.targetGold,
  };

  factory QuantityAchievement.fromJson(dynamic json)
   => QuantityAchievement(
    json["shortTitle"],
    title: json["title"],
    text: json["text"],
    currentCount: json["currentCount"],
    targetBronze: json["targetBronze"],
    targetSilver: json["targetSilver"],
    targetGold: json["targetGold"],
  );
}




class QualityAchievement extends Achievement {

  //=================================
  // Values =====================
  final Map<String,bool> targets;


  // =====================================
  // Constructor =====================
  const QualityAchievement(String shortTitle, {
    String title,
    String text,
    @required this.targets,
    int targetBronze,
    int targetSilver,
    int targetGold,
  }) : super(
    shortTitle, 
    title: title, 
    text: text,
    targetBronze: targetBronze,
    targetSilver: targetSilver,
    targetGold: targetGold,
  );



  //=====================================
  // Getters ========================

  @override
  int get count {
    int c = 0;
    for(final value in this.targets.values){
      if(value) ++c;
    }
    return c;
  }

  @override
  bool get bronze => this.count >= this.targetBronze;
  @override
  bool get silver => this.count >= this.targetSilver;
  @override
  bool get gold => this.count >= this.targetGold;

  QualityAchievement achieve(String key) => withTargets(<String,bool>{
    for(final entry in this.targets.entries)
      entry.key: entry.value || (entry.key == key),
  });

  QualityAchievement get reset => withTargets(<String,bool>{
    for(final entry in this.targets.entries)
      entry.key: false,
  });

  QualityAchievement withTargets(Map<String,bool> newTargets) => QualityAchievement(
    this.shortTitle,
    title: this.title,
    text: this.text,
    targetBronze: this.targetBronze,
    targetSilver: this.targetSilver,
    targetGold: this.targetGold,
    targets: newTargets,
  ); 
 

  @override
  QualityAchievement updateStats(Achievement updated){
    if(updated is QualityAchievement && updated.shortTitle == this.shortTitle){
      return updated.withTargets(this.targets);
    } else return this;
  }


  //=========================================
  // Persistence ========================
  dynamic get json => <String,dynamic>{
    "type": "quality",
    "title": this.title,
    "shortTitle": this.shortTitle,
    "text": this.text,
    "targets": this.targets,
    "targetBronze": this.targetBronze,
    "targetSilver": this.targetSilver,
    "targetGold": this.targetGold,
  };

  factory QualityAchievement.fromJson(dynamic json)
   => QualityAchievement(
    json["shortTitle"],
    title: json["title"],
    text: json["text"],
    targets: <String,bool>{for(final entry in (json["targets"] as Map<String,dynamic>).entries)
      entry.key: entry.value as bool,
    },
    targetBronze: json["targetBronze"],
    targetSilver: json["targetSilver"],
    targetGold: json["targetGold"],
  );
}