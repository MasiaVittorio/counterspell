import 'dart:async';
import 'package:counter_spell_new/models/game/game_actions/ga_damage.dart';
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
    attackingPlayer.dispose();
    defendingPlayer.dispose();
    counterSet.dispose();
  }



  //==============================
  // Values

  final CSGame parent;

  StreamSubscription newNamesSub;
  
  //name -> true (selected) // false (unselected) // null (anti-selected)
  final BlocVar<Map<String,bool>> selected;

  final BlocVar<String> attackingPlayer = BlocVar("");
  final BlocVar<String> defendingPlayer = BlocVar("");

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
    )
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
    @required String attacker,
    @required String defender,
    @required bool applyDamageToLife,
    @required Map<String,bool> usingPartnerB,
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

    if(pageValue == CSPage.commanderCast){
      if(selectedValue.values.every((b) => b == false))
        return GANull.instance;
      
      return GACast(
        scrollerValue,
        selected: selectedValue,
        maxVal: maxValue,
        usingPartnerB: usingPartnerB,
      );
    }

    if(pageValue == CSPage.commanderDamage){
      if(attacker != null && defender != null){
        if(attacker != "" && defender != ""){
          return GADamage(
            scrollerValue,
            attacker: attacker,
            defender: defender,
            applyToLife: applyDamageToLife,
            usingPartnerB: usingPartnerB,
            minLife: minValue,
            maxVal: maxValue,
          );
        }
      }
    }

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
    @required String attacker,
    @required String defender,
    @required Map<String,bool> usingPartnerB,
    @required bool applyDamageToLife,
  }) => action(
    pageValue: pageValue,
    scrollerValue: scrollerValue,
    selectedValue: selectedValue,
    minValue: minValue,
    maxValue: maxValue,
    attacker: attacker,
    defender: defender,
    usingPartnerB: usingPartnerB,
    applyDamageToLife: applyDamageToLife,
  ).normalizeOnLast(gameState);

  GameAction currentNormalizedAction(CSPage page) => normalizedAction(
    scrollerValue: parent.parent.scroller.intValue.value,
    pageValue: page,
    selectedValue: selected.value,
    gameState: parent.gameState.gameState.value,
    minValue: parent.parent.settings.minValue.value,
    maxValue: parent.parent.settings.maxValue.value,
    attacker: this.attackingPlayer.value,
    defender: this.defendingPlayer.value,
    applyDamageToLife: true, /////////////////////
    usingPartnerB: this.parent.gameGroup.usingPartnerB.value,
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
      // if(parent.parent.settings.enabledCounters.value[counter.longName])
        counter.longName : counter, 
  };



  //==============================
  // Actions 

  void clearSelection([bool alsoAttacker=true]){
    for(final key in selected.value.keys){
      selected.value[key] = false;
    }
    selected.refresh();
    defendingPlayer.set("");
    if(alsoAttacker) attackingPlayer.set("");
  }

  //Do not call this manually, let it be called by the isScrolling's "onChanged" method
  // -> if you want to trigger this, just call scroller.forceComplete()
  void privateConfirm(CSPage page){
    this.parent.gameState.applyAction(this.currentNormalizedAction(page));
    this.clearSelection(false);
    this.parent.parent.scroller.value = 0.0;
    this.parent.parent.scroller.intValue.set(0);
  }


}
