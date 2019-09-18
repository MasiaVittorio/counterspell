import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:counter_spell_new/models/game/game_actions/ga_null.dart';
import 'package:counter_spell_new/models/game/model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:sidereus/bloc/bloc.dart';


import '../game.dart';

class CSGameAction {

  void dispose(){
    this.selected.dispose();
    newNamesSub.cancel();
    this.isCasting.dispose();
  }



  //==============================
  // Values

  final CSGame parent;

  StreamSubscription newNamesSub;
  
  //name -> true (selected) // false (unselected) // null (anti-selected)
  final BlocVar<Map<String,bool>> selected;

  final BlocVar<String> attackingPlayer = BlocVar("");
  final BlocVar<String> defendingPlayer = BlocVar("");


  //as opposed to commander damage
  final BlocVar<bool> isCasting;

  final PersistentSet<Counter> counterSet;



  //==============================
  // Constructor
  
  CSGameAction(this.parent): 
    selected = BlocVar(<String,bool>{}),
    counterSet = PersistentSet<Counter>(
      key: "bloc_game_action_blocvar_counterset",
      initList: DEFAULT_CUSTOM_COUNTERS,
      toJson: (list) => [
        for(final counter in list)
          counter.toJson(),
      ],
      fromJson: (jsonList) => [
        for(final json in jsonList)
          Counter.fromJson(json),
      ],
    ),
    isCasting = BlocVar<bool>(false)
  {
    //deselect names (and most importantly set the names as keys)
    //every time the ordered list of names changes

    /// [CSGameAction] Must be initialized after [CSGameGroup]
    newNamesSub = this.parent.gameGroup.names.behavior
      .map<String>((names) => names.toString())
      .distinct()
      .listen((s){
        this.selected.set({
          for(final name in this.parent.gameGroup.names.value)
            name: false,
        });
      }); 
  }




  //============================
  // Getters

  static GameAction action({
    @required int scrollerValue, 
    @required CSPage pageValue, 
    @required Map<String,bool> selectedValue,
    @required int minValue,
    @required int maxValue,
  }) {
    if(scrollerValue == 0)
      return GANull.instance;

    if(pageValue == CSPage.life){
      //if they are all deselected this is a null action!
      if(selectedValue.values.every((b) => b == false))
        return GANull.instance;

      return GALife(
        scrollerValue,
        selected: selectedValue,
        minVal: minValue,
        maxVal: maxValue,
      );
    }

    //if(pageValue  == CSPage.commander) bla bla bla
      //if(isCasting) bla bla bla
      //else bla bla bla
    //if(pageValue  == CSPage.counters) bla bla bla

    return GANull.instance;
  }
  static GameAction normalizedAction({
    @required int scrollerValue, 
    @required CSPage pageValue, 
    @required Map<String,bool> selectedValue,
    @required GameState gameState,
    @required int minValue,
    @required int maxValue,
  }) => action(
    pageValue: pageValue,
    scrollerValue: scrollerValue,
    selectedValue: selectedValue,
    minValue: minValue,
    maxValue: maxValue,
  ).normalizeOnLast(gameState);

  GameAction get currentNormalizedAction => normalizedAction(
    scrollerValue: parent.parent.scroller.intValue.value,
    pageValue: parent.parent.scaffold.page.value,
    selectedValue: selected.value,
    gameState: parent.gameState.gameState.value,
    minValue: parent.parent.settings.minValue.value,
    maxValue: parent.parent.settings.maxValue.value,
  );

  bool get isSomeoneAttacking => selected.value.keys.contains(attackingPlayer.value);
  bool get isSomeoneDefending => selected.value.keys.contains(defendingPlayer.value);
  //null means anti-selected! (so somewhat selected indeed)
  bool get isSomeoneSelected => selected.value.values.any((b) => b != false);
  bool get isScrolling => parent.parent.scroller.isScrolling.value;
  bool get actionPending 
    => isScrolling 
    || isSomeoneSelected
    || isSomeoneAttacking 
    || isSomeoneDefending;
  
  Map<String, Counter> get currentCounterMap => {
    for(final counter in counterSet.list)
      if(parent.parent.settings.enabledCounters.value[counter.longName])
        counter.longName : counter, 
  };



  //==============================
  // Actions 

  void clearSelection(){
    for(final key in selected.value.keys){
      selected.value[key] = false;
    }
    selected.refresh();
    defendingPlayer.set("");
    attackingPlayer.set("");
  }

  void toggleCasting(){
    this.isCasting.set(!this.isCasting.value);
  }

  //Do not call this manually, let it be called by the isScrolling's "onChanged" method
  // -> if you want to trigger this, just call scroller.forceComplete()
  void privateConfirm(){
    this.parent.gameState.applyAction(this.currentNormalizedAction);
    this.clearSelection();
    this.parent.parent.scroller.value = 0.0;
    this.parent.parent.scroller.intValue.set(0);
  }


}
