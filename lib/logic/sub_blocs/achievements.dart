import 'package:counter_spell_new/core.dart';

class CSAchievements extends BlocBase {
  //=================================
  // Disposer ===================
  @override
  void dispose() {
    map.dispose();
    todo.dispose();
  }

  //=================================
  // Values ===================
  final CSBloc parent;
  late BlocMap<String?,Achievement> map;
  late PersistentVar<Set<String>> todo;
  bool _mapReading = true;
  bool _todoReading = true;
  bool _checked = false; //if the check method is already been launched


  //===================================
  // Constructor ===================
  CSAchievements(this.parent){
    const bool reset = false;
    map = BlocMap<String?,Achievement>(
      Achievements.map,
      key: "counterspell_bloc_achievementsBloc_blocMap_mapOfAchievements",
      itemToJson: (item) => item!.json,
      jsonToItem: (json) => Achievement.fromJson(json),
      readCallback: (_){
        _mapReading = false;
        checkNewAchievements(reset);
      }
    );
    todo = PersistentVar<Set<String>>(
      initVal: const <String>{
        Achievements.countersShortTitle,
        Achievements.vampireShortTitle,
        Achievements.rollerShortTitle,
      },
      key: "counterspell_bloc_achievementsBloc_blocVar_todo_list",
      toJson: (s) => <String>[...s],
      fromJson: (j) => <String>{for(final s in (j as List)) s as String},
      copier: (s) => <String>{...s},
      readCallback: (_){
        _todoReading = false;
        checkNewAchievements(reset);
      }
    );

  }



  //=======================================
  // Methods ===================

  // ===> Checkers

  void checkNewAchievements([bool forceResetDev = false]){

    if(_todoReading) return;
    if(_mapReading) return;
    if(_checked) return;
    _checked = true;

    /// checks if new achievements are made by the dev and must be saved in this variable
    for(final entry in Achievements.map.entries){
      map.value[entry.key] 
        = (forceResetDev) 
          ? entry.value 
          : map.value[entry.key]
              ?.updateStats(entry.value) 
                ?? entry.value;
    }
    map.refresh();

    if(forceResetDev){
      todo.set(const <String>{
        Achievements.countersShortTitle,
        Achievements.vampireShortTitle,
        Achievements.rollerShortTitle,
      });
    }

    /// checks if the todoList is not filled but there are achievements not golden yet anyway
    /// useful for when the dev changes the gold target of an achievement
    if(todo.value.length < 3){
      bool changed = false;
      for(final a in Achievements.map.values){
        if(todo.value.length < 3
        && !map.value[a.shortTitle]!.gold
        && !todo.value.contains(a.shortTitle)
        ){
          todo.value.add(a.shortTitle);
          changed = true;
        }
      }
      if(changed) todo.refresh();
    }

  }

  void checkSnackBar(Achievement oldOne, Achievement newOne){
    if(newOne.medal.biggerThan(oldOne.medal)){
      parent.stage.showSnackBar(StageSnackBar(
        title: Text(newOne.shortTitle),
        subtitle: Text("Reached: ${newOne.medal.name}"),
        secondary: MedalIcon(newOne.medal),
        scrollable: true,
        onTap: () => parent.stage.showAlert(
          AchievementsAlert(initialDone: newOne.gold,),
          size: AchievementsAlert.height,
        ),
      ));
    }
  }

  void checkNewTODO(String achievement){
    if(map.value[achievement]!.gold){
      todo.value.remove(achievement);

      final Achievement? newUndone = map.value.values.firstWhere(
        (a) => !a!.gold && !todo.value.contains(a.shortTitle), 
        orElse: () => null,
      );

      if(newUndone != null){
        todo.value.add(newUndone.shortTitle);
      }
      todo.refresh();
    }
  }


  // ===> Interact with achievements
  bool achieve(String shortTitle, String? key){
    if(!todo.value.contains(shortTitle)) {
      return false;
    }

    final Achievement? oldAchievement 
        = map.value[shortTitle] 
        ?? Achievements.mapQuality[shortTitle];

    if(oldAchievement == null) return false;
    if(oldAchievement is QualityAchievement){
      final Achievement newAchievement = oldAchievement.achieve(key); 
      map.value[shortTitle] = newAchievement;
      map.refresh(key: shortTitle);
      checkNewTODO(shortTitle);
      checkSnackBar(oldAchievement, newAchievement);
      return true;
    } else {
      return false;
    }
  }

  bool incrementBy(String shortTitle, int by){
    if(!todo.value.contains(shortTitle)) {
      return false;
    }

    final Achievement? oldAchievement 
        = map.value[shortTitle] 
        ?? Achievements.mapQuantity[shortTitle];

    if(oldAchievement == null) return false;
    if(oldAchievement is QuantityAchievement){
      final Achievement newAchievement = oldAchievement.incrementBy(by); 
      map.value[shortTitle] = newAchievement;
      map.refresh(key: shortTitle);
      checkNewTODO(shortTitle);
      checkSnackBar(oldAchievement, newAchievement);
      return true;
    } else {
      return false;
    }
  }
  bool increment(String shortTitle) => incrementBy(shortTitle, 1);

  bool reset(String shortTitle, {bool force = false}){
    final Achievement? achievement 
        = map.value[shortTitle] 
        ?? Achievements.map[shortTitle];
    if(achievement == null) return false;
    if(achievement.gold && !(force)) return false;
    map.value[shortTitle] = achievement.reset;
    map.refresh(key: shortTitle);
    if(!todo.value.contains(shortTitle)){
      todo.value.add(shortTitle);
      while(todo.value.length > 3){
        todo.value.remove(todo.value.firstWhere((t) => t != shortTitle));
      }
      todo.refresh();
    }
    return true;
  }





  //====================================================
  // Single achievements methods ===================

  void gameActionPerformed(GameAction action){

    if(!todo.value.contains(Achievements.vampireShortTitle) 
      && !todo.value.contains(Achievements.vampireShortTitle)) {
      return;
    }

    if(action is GAComposite){
      final Set<int> increments = <int>{
        for(final a in action.actionList.values)
          if(a is PALife) a.increment,
      };
      if(increments.length > 1){
        incrementBy(Achievements.vampireShortTitle, increments.first.abs());
      }
    }
    if(action is GALife){
      if(action.selected.values.any((v) => v==null)){
        incrementBy(Achievements.vampireShortTitle, action.increment.abs());
      }
    }
  }

  void gameRestarted(GameRestartedFrom? from){
    if(!todo.value.contains(Achievements.uiExpertShortTitle)) {
      return;
    }
    if(from == null) {
      return;
    }
    achieve(Achievements.uiExpertShortTitle, from.name);
    reset(Achievements.countersShortTitle, force: false);
  }

  void playGroupEdited(bool fromClosedPanel){
    if(!todo.value.contains(Achievements.uiExpertShortTitle)) {
      return;
    }
    achieve(Achievements.uiExpertShortTitle, fromClosedPanel ? "Playgroup panel" : "Playgroup menu");
  }

  void counterChosen(String? newCounterLongName)
    => achieve(Achievements.countersShortTitle, newCounterLongName);

  void flippedOrRolled()
    => increment(Achievements.rollerShortTitle);
}

