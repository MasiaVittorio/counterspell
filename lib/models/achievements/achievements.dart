import 'package:flutter/widgets.dart';

abstract class Achievement {

  //=================================
  // Values =====================
  final String shortTitle;
  final String title;
  final String text;
  // final int count;
  // final int targetBronze;
  // final int targetSilver;
  // final int targetGold;


  //=====================================
  // Constructor =====================
  const Achievement(this.shortTitle,{
    @required this.title,
    @required this.text,
  });

  //=====================================
  // Getters ========================
  bool get bronze;
  bool get silver;
  bool get gold;

  // Achievement withCount(int newCount) => Achievement(
  //   this.shortTitle,
  //   title: this.title,
  //   text: this.text,
  //   targetBronze: this.targetBronze,
  //   targetSilver: this.targetSilver,
  //   targetGold: this.targetGold,
  //   count: newCount,
  // );

  // Achievement get increment => withCount(this.count +1);
  // Achievement get decrement => withCount((this.count -1).clamp(0, 99999999999));


  //=====================================
  // Data ===========================

  static const Achievement counters = QuantityAchievement(
    "Counters master",
    title: "Track different counters in a single game",
    text: 'You can select a new counter in the "Counters" page by tapping on the icon at the right of the bottom panel',
    count: 0,
    targetSilver: 3,
    targetBronze: 5,
    targetGold: 7,
  );
  static const Achievement uiExpert = QualityAchievement(
    "UI expert",
    title: "Restart the game or edit the playgroup in different ways",
    text: "You can use the closed panel's right button (History and Life pages) or the main menu's buttons (\"Game\" tab)",
    targets: <String,bool>{
      "Restart panel": false,
      "Restart menu": false,
      "Playgroup panel": false,
      "Playgroup menu": false,
    },
    targetSilver: 2,
    targetBronze: 3,
    targetGold: 4,
  );
  static const List<Achievement> all = [
    counters,
    uiExpert,
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
  final int count;
  final int targetBronze;
  final int targetSilver;
  final int targetGold;


  // =====================================
  // Constructor =====================
  const QuantityAchievement(String shortTitle, {
    String title,
    String text,
    @required this.count,
    @required this.targetBronze,
    @required this.targetSilver,
    @required this.targetGold,
  }) : super(shortTitle, title: title, text: text);


  //=====================================
  // Getters ========================
  @override
  bool get bronze => this.count >= this.targetBronze;
  @override
  bool get silver => this.count >= this.targetSilver;
  @override
  bool get gold => this.count >= this.targetGold;

  QuantityAchievement withCount(int newCount) => QuantityAchievement(
    this.shortTitle,
    title: this.title,
    text: this.text,
    targetBronze: this.targetBronze,
    targetSilver: this.targetSilver,
    targetGold: this.targetGold,
    count: newCount,
  );

  QuantityAchievement get increment => withCount(this.count +1);
  QuantityAchievement get decrement => withCount((this.count -1).clamp(0, 99999999999));


  //=========================================
  // Persistence ========================
  dynamic get json => <String,dynamic>{
    "type": "quantity",
    "title": this.title,
    "shortTitle": this.shortTitle,
    "text": this.text,
    "count": this.count,
    "targetBronze": this.targetBronze,
    "targetSilver": this.targetSilver,
    "targetGold": this.targetGold,
  };

  factory QuantityAchievement.fromJson(dynamic json)
   => QuantityAchievement(
    json["shortTitle"],
    title: json["title"],
    text: json["text"],
    count: json["count"],
    targetBronze: json["targetBronze"],
    targetSilver: json["targetSilver"],
    targetGold: json["targetGold"],
  );
}




class QualityAchievement extends Achievement {

  //=================================
  // Values =====================
  final Map<String,bool> targets;
  final int targetBronze;
  final int targetSilver;
  final int targetGold;


  // =====================================
  // Constructor =====================
  const QualityAchievement(String shortTitle, {
    String title,
    String text,
    @required this.targets,
    @required this.targetBronze,
    @required this.targetSilver,
    @required this.targetGold,
  }) : super(shortTitle, title: title, text: text);


  //=====================================
  // Getters ========================

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

  QualityAchievement achieve(String key) => QualityAchievement(
    this.shortTitle,
    title: this.title,
    text: this.text,
    targetBronze: this.targetBronze,
    targetSilver: this.targetSilver,
    targetGold: this.targetGold,
    targets: <String,bool>{
      for(final entry in this.targets.entries)
        entry.key: entry.value || (entry.key == key),
    },
  );


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