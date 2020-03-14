import 'package:counter_spell_new/core.dart';

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
      key: "counterspell_bloc_box_achievementsBloc_map",
      itemToJson: (item) => item.json,
      jsonToItem: (json) => Achievement.fromJson(json),
    ),
    this.todo = PersistentVar<Set<String>>(
      initVal: <String>{
        Achievement.counters.shortTitle,
        Achievement.uiExpert.shortTitle,
      },
      key: "counterspell_bloc_var_achievementsBloc_todo",
    );

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
      this.todo.value.add((this.map.value.values.firstWhere((a) => !a.gold)).shortTitle);
      this.todo.refresh();
    }
  }

}