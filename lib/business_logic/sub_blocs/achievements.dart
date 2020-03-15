import 'package:counter_spell_new/core.dart';
import 'package:time/time.dart';

class CSAchievements extends BlocBase {
  //=================================
  // Disposer ===================
  @override
  void dispose() {
    this.map.dispose();
    this.todo.dispose();
  }

  //=================================
  // Values ===================
  final CSBloc parent;
  final BlocMap<String,Achievement> map;
  final PersistentVar<Set<String>> todo;

  //===================================
  // Constructor ===================
  CSAchievements(this.parent):
    this.map = BlocMap<String,Achievement>(
      <String,Achievement>{for(final a in Achievement.all) a.shortTitle: a},
      key: "counterspell_bloc_achievementsBloc_blocMap_map",
      itemToJson: (item) => item.json,
      jsonToItem: (json) => Achievement.fromJson(json),
    ),
    this.todo = PersistentVar<Set<String>>(
      initVal: <String>{
        Achievement.counters.shortTitle,
        Achievement.uiExpert.shortTitle,
        Achievement.roller.shortTitle,
      },
      toJson: (s) => <String>[...s],
      fromJson: (j) => <String>{...(j as List)},
      key: "counterspell_bloc_achievementsBloc_blocVar_todo",
    ){
      this.checkNewAchievements();
    }

  void checkNewAchievements() async {
    await Future.delayed(2.seconds);


    for(final achievement in Achievement.all){
      this.map.value[achievement.shortTitle] 
        = this.map.value[achievement.shortTitle]
          ?.updateStats(achievement) 
            ?? achievement;
    }
    this.map.refresh();
  }

  void achieve(String achievement, String key){
    this.map.value[achievement] = (this.map.value[achievement] as QualityAchievement).achieve(key);
    this.map.refresh(key: achievement);
    this.check(achievement);
  }

  void increment(String achievement){
    this.map.value[achievement] = (this.map.value[achievement] as QuantityAchievement).increment;
    this.map.refresh(key: achievement);
    this.check(achievement);
  }

  void check(String achievement){
    if(this.map.value[achievement].gold){
      this.todo.value.remove(achievement);
      final Achievement newUndone = this.map.value.values.firstWhere((a) => !a.gold, orElse: () => null);
      if(newUndone != null){
        this.todo.value.add(newUndone.shortTitle);
      }
      this.todo.refresh();
    }
  }

  void reset(String achievement){
    Achievement a = this.map.value[achievement];
    if(a.gold) return;
    this.map.value[achievement] = a.reset;
    this.map.refresh();
  }

}