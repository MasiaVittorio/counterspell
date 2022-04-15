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
    required this.title,
    required this.text,
    required this.targetBronze,
    required this.targetSilver,
    required this.targetGold,
  }): assert(targetGold >= targetSilver),
      assert(targetSilver >= targetBronze);

  //=====================================
  // Getters ========================
  int? get count;
  bool get bronze => count! >= targetBronze;
  bool get silver => count! >= targetSilver;
  bool get gold => count! >= targetGold;
  Medal? get medal => gold ? Medal.gold : silver ? Medal.silver : bronze ? Medal.bronze : null;
  int target(Medal m) => m == Medal.bronze 
    ? targetBronze
    : m == Medal.silver 
      ? targetSilver
      : m == Medal.gold 
        ? targetGold
        : 0;

  Medal get nextMedal {
    if(!bronze){
      if(targetBronze == targetSilver){
        if(targetGold == targetSilver){
          return Medal.gold;          
        } else {
          return Medal.silver;
        }
      } else {
        return Medal.bronze;
      }
    } else if(!silver){
      if(targetGold == targetSilver){
        return Medal.gold;
      } else {
        return Medal.silver;
      }
    } else if(!gold) {
      return Medal.gold;
    } else {
      return Medal.gold;
    }
  } 

  Achievement get reset; 

  /// For when the dev changes the properties of an achievement
  Achievement updateStats(Achievement updated);



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
  final int? currentCount;


  // =====================================
  // Constructor =====================
  const QuantityAchievement(String shortTitle, {
    required String title,
    required String text,
    required this.currentCount,
    required int targetBronze,
    required int targetSilver,
    required int targetGold,
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
  int? get count => this.currentCount;

  QuantityAchievement withCount(int? newCount) => QuantityAchievement(
    this.shortTitle,
    title: this.title,
    text: this.text,
    targetBronze: this.targetBronze,
    targetSilver: this.targetSilver,
    targetGold: this.targetGold,
    currentCount: newCount,
  );

  QuantityAchievement incrementBy(int by) => withCount((this.count! + by).clamp(0, this.targetGold));
  QuantityAchievement get increment => this.incrementBy(1);
  QuantityAchievement get decrement => this.incrementBy(-1);

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
    required String title,
    required String text,
    required this.targets,
    required int targetBronze,
    required int targetSilver,
    required int targetGold,
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

  QualityAchievement achieve(String? key) => withTargets(<String,bool>{
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