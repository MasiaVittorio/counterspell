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
  late BlocMap<String?,Achievement> map;
  late PersistentVar<Set<String?>> todo;
  bool _mapReading = true;
  bool _todoReading = true;
  bool _checked = false; //if the check method is already been launched


  //===================================
  // Constructor ===================
  CSAchievements(this.parent){
    final bool reset = false;
    this.map = BlocMap<String?,Achievement>(
      Achievements.map,
      key: "counterspell_bloc_achievementsBloc_blocMap_mapOfAchievements",
      itemToJson: (item) => item!.json,
      jsonToItem: (json) => Achievement.fromJson(json),
      readCallback: (_){
        _mapReading = false;
        this.checkNewAchievements(reset);
      }
    );
    this.todo = PersistentVar<Set<String?>>(
      initVal: const <String?>{
        Achievements.countersShortTitle,
        Achievements.vampireShortTitle,
        Achievements.rollerShortTitle,
      },
      key: "counterspell_bloc_achievementsBloc_blocVar_todo_list",
      toJson: (s) => <String?>[...s],
      fromJson: (j) => <String?>{...(j as List) as Iterable<String?>},
      copier: (s) => <String?>{...s},
      readCallback: (_){
        _todoReading = false;
        this.checkNewAchievements(reset);
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
      this.map.value[entry.key] 
        = (forceResetDev ?? false) 
          ? entry.value 
          : this.map.value[entry.key]
              ?.updateStats(entry.value) 
                ?? entry.value;
    }
    this.map.refresh();

    if(forceResetDev ?? false){
      this.todo.set(const <String?>{
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
      this.parent.stage!.showSnackBar(StageSnackBar(
        title: Text(newOne.shortTitle!),
        subtitle: Text("Reached: ${newOne.medal.name}"),
        secondary: MedalIcon(newOne.medal),
        scrollable: true,
        onTap: () => parent.stage!.showAlert(
          AchievementsAlert(initialDone: newOne.gold,),
          size: AchievementsAlert.height,
        ),
      ));
    }
  }

  void checkNewTODO(String achievement){
    if(this.map.value[achievement]!.gold){
      this.todo.value.remove(achievement);

      final Achievement? newUndone = this.map.value.values.firstWhere(
        (a) => !a!.gold && !this.todo.value.contains(a.shortTitle), 
        orElse: () => null,
      );

      if(newUndone != null){
        this.todo.value.add(newUndone.shortTitle);
      }
      this.todo.refresh();
    }
  }


  // ===> Interact with achievements
  bool achieve(String shortTitle, String? key){
    if(!this.todo.value.contains(shortTitle))
      return false;

    final Achievement? oldAchievement 
        = this.map.value[shortTitle] 
        ?? Achievements.mapQuality[shortTitle];

    if(oldAchievement == null) return false;
    if(oldAchievement is QualityAchievement){
      final Achievement newAchievement = oldAchievement.achieve(key); 
      this.map.value[shortTitle] = newAchievement;
      this.map.refresh(key: shortTitle);
      this.checkNewTODO(shortTitle);
      this.checkSnackBar(oldAchievement, newAchievement);
      return true;
    } else return false;
  }

  bool incrementBy(String shortTitle, int by){
    if(!this.todo.value.contains(shortTitle))
      return false;

    final Achievement? oldAchievement 
        = this.map.value[shortTitle] 
        ?? Achievements.mapQuantity[shortTitle];

    if(oldAchievement == null) return false;
    if(oldAchievement is QuantityAchievement){
      final Achievement newAchievement = oldAchievement.incrementBy(by ?? 0); 
      this.map.value[shortTitle] = newAchievement;
      this.map.refresh(key: shortTitle);
      this.checkNewTODO(shortTitle);
      this.checkSnackBar(oldAchievement, newAchievement);
      return true;
    } else return false;
  }
  bool increment(String shortTitle) => this.incrementBy(shortTitle, 1);

  bool reset(String? shortTitle, {bool force = false}){
    final Achievement? achievement 
        = this.map.value[shortTitle] 
        ?? Achievements.map[shortTitle!];
    if(achievement == null) return false;
    if(achievement.gold && !(force ?? false)) return false;
    this.map.value[shortTitle] = achievement.reset;
    this.map.refresh(key: shortTitle);
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
      && !todo.value.contains(Achievements.vampireShortTitle))
      return;

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

  void gameRestarted(GameRestartedFrom? from){
    if(!todo.value.contains(Achievements.uiExpertShortTitle)) 
      return;
    if(from == null) 
      return;
    this.achieve(Achievements.uiExpertShortTitle, from.name);
    this.reset(Achievements.countersShortTitle, force: false);
  }

  void playGroupEdited(bool fromClosedPanel){
    if(!todo.value.contains(Achievements.uiExpertShortTitle)) 
      return;
    this.achieve(Achievements.uiExpertShortTitle, fromClosedPanel ? "Playgroup panel" : "Playgroup menu");
  }

  void counterChosen(String? newCounterLongName)
    => this.achieve(Achievements.countersShortTitle, newCounterLongName);

  void flippedOrRolled()
    => this.increment(Achievements.rollerShortTitle);
}

