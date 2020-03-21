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
      Achievements.map,
      key: "counterspell_bloc_achievementsBloc_blocMap_map",
      itemToJson: (item) => item.json,
      jsonToItem: (json) => Achievement.fromJson(json),
    ),
    this.todo = PersistentVar<Set<String>>(
      initVal: const <String>{
        Achievements.countersShortTitle,
        Achievements.vampireShortTitle,
        Achievements.rollerShortTitle,
      },
      toJson: (s) => <String>[...s],
      fromJson: (j) => <String>{...(j as List)},
      key: "counterspell_bloc_achievementsBloc_blocVar_todo",
      copier: (s) => <String>{...s},
    ){
      final bool reset = false;
      if(this.map.reading){
        this.map.readCallback = (_) => this.checkNewAchievements(reset);
      } else {
        this.checkNewAchievements(reset);
      }
    }



  //=======================================
  // General methods ===================
  void checkNewAchievements([bool forceResetDev = false]) async {
    await Future.delayed(2.seconds);

    for(final entry in Achievements.map.entries){
      this.map.value[entry.key] 
        = (forceResetDev ?? false) 
          ? entry.value 
          : this.map.value[entry.key]
              ?.updateStats(entry.value) 
                ?? entry.value;
    }
    this.map.refresh();

    if(forceResetDev ?? false){
      this.todo.set(const <String>{
        Achievements.countersShortTitle,
        Achievements.vampireShortTitle,
        Achievements.rollerShortTitle,
      });
    }
  }

  bool achieve(String title, String key){
    final QualityAchievement oldAchievement 
        = this.map.value[title] 
        ?? Achievements.mapQuality[title];

    if(oldAchievement == null) return false;
    final Achievement newAchievement = oldAchievement.achieve(key); 
    this.map.value[title] = newAchievement;
    this.map.refresh(key: title);
    this.checkNewTODO(title);
    this.checkSnackBar(oldAchievement, newAchievement);
    return true;
  }

  bool incrementBy(String title, int by){
    final QuantityAchievement oldAchievement 
        = this.map.value[title] 
        ?? Achievements.mapQuantity[title];

    if(oldAchievement == null) return false;
    final Achievement newAchievement = oldAchievement.incrementBy(by ?? 0); 
    this.map.value[title] = newAchievement;
    this.map.refresh(key: title);
    this.checkNewTODO(title);
    this.checkSnackBar(oldAchievement, newAchievement);
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

  void checkSnackBar(Achievement oldOne, Achievement newOne){
    if(newOne.medal.biggerThan(oldOne.medal)){
      this.parent.stage.showSnackBar(StageSnackBar(
        title: Text(newOne.shortTitle),
        subtitle: Text("Reached: ${newOne.medal.name}"),
        secondary: MedalIcon(newOne.medal),
      ));
    }
  }

  void checkNewTODO(String achievement){
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

  void gameActionPerformed(GameAction action){
    if(action is GAComposite){
      final Set<int> increments = <int>{
        for(final a in action.actionList.values)
          if(a is PALife) a.increment,
      };
      if(increments.length > 1){
        this.incrementBy(Achievements.vampireShortTitle, increments.first.abs());
      }
    }
    if(action is GALife){
      if(action.selected.values.any((v) => v==null)){
        this.incrementBy(Achievements.vampireShortTitle, action.increment.abs());
      }
    }
  }

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