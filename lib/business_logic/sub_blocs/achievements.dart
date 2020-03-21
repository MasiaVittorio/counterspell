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
      <String,Achievement>{for(final a in Achievements.all) a.shortTitle: a},
      key: "counterspell_bloc_achievementsBloc_blocMap_map",
      itemToJson: (item) => item.json,
      jsonToItem: (json) => Achievement.fromJson(json),
    ),
    this.todo = PersistentVar<Set<String>>(
      initVal: <String>{
        Achievements.counters.shortTitle,
        Achievements.uiExpert.shortTitle,
        Achievements.roller.shortTitle,
      },
      toJson: (s) => <String>[...s],
      fromJson: (j) => <String>{...(j as List)},
      key: "counterspell_bloc_achievementsBloc_blocVar_todo",
    ){
      this.checkNewAchievements();
    }



  //=======================================
  // General methods ===================
  void checkNewAchievements() async {
    await Future.delayed(2.seconds);


    for(final achievement in Achievements.all){
      this.map.value[achievement.shortTitle] 
        = this.map.value[achievement.shortTitle]
          ?.updateStats(achievement) 
            ?? achievement;
    }
    this.map.refresh();
  }

  bool achieve(String title, String key){
    final QualityAchievement achievement 
        = this.map.value[title] 
        ?? Achievements.mapQuality[title];
    if(achievement == null) return false;
    this.map.value[title] = achievement.achieve(key);
    this.map.refresh(key: title);
    this.check(title);
    return true;
  }

  bool incrementBy(String title, int by){
    final QuantityAchievement achievement 
        = this.map.value[title] 
        ?? Achievements.mapQuantity[title];
    if(achievement == null) return false;
    this.map.value[title] = achievement.incrementBy(by ?? 0);
    this.map.refresh(key: title);
    this.check(title);
    return true;
  }
  bool increment(String title) => this.incrementBy(title, 1);

  bool reset(String title, {bool force = false}){
    final Achievement achievement 
        = this.map.value[title] 
        ?? Achievements.map[title];
    if(achievement == null) return false;
    if(achievement.gold && !(force ?? false)) return false;
    this.map.value[title] = achievement.reset;
    this.map.refresh(key: title);
    return true;
  }

  void check(String achievement){
    if(this.map.value[achievement].gold){
      this.todo.value.remove(achievement);

      final Achievement newUndone = this.map.value.values.firstWhere(
        (a) => !a.gold && !this.todo.value.contains(a.shortTitle), 
        orElse: () => null,
      );

      if(newUndone != null){
        this.todo.value.add(newUndone.shortTitle);
      }
      this.todo.refresh();
    }
  }




  //====================================================
  // Single achievements methods ===================

  void restarted(bool fromClosedPanel){
    this.achieve(Achievements.uiExpertShortTitle, fromClosedPanel ? "Restart panel" : "Restart menu");
    this.reset(Achievements.countersShortTitle, force: false);
  }

  void playGroupEdited(bool fromClosedPanel)
    => this.achieve(Achievements.uiExpertShortTitle, fromClosedPanel ? "Playgroup panel" : "Playgroup menu");

  void countered(String newCounterLongName)
    => this.achieve(Achievements.countersShortTitle, newCounterLongName);

  void flippedOrRolled()
    => this.increment(Achievements.rollerShortTitle);
}