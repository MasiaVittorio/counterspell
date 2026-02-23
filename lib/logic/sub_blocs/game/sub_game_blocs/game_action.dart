import 'dart:async';

import 'package:counter_spell/core.dart';

class CSGameAction {
  void dispose() {
    selected.dispose();
    newNamesSub.cancel();
    attackingPlayer.dispose();
    defendingPlayer.dispose();
    counterSet.dispose();
  }

  //==============================
  // Values

  final CSGame parent;

  late StreamSubscription newNamesSub;

  //name -> true (selected) // false (unselected) // null (anti-selected)
  final BlocVar<Map<String, bool?>> selected;

  final BlocVar<String> attackingPlayer = BlocVar("");
  final BlocVar<String> defendingPlayer = BlocVar("");

  final PersistentSet<Counter> counterSet;

  //==============================
  // Constructor

  CSGameAction(this.parent)
      : selected = BlocVar(<String, bool?>{}),
        counterSet = PersistentSet<Counter>(
          key: "bloc_game_action_blocvar_counterset_6",
          initList: Counter.defaultList,
          toJson: (list) => [
            for (final counter in list) counter.toJson(),
          ],
          fromJson: (jsonList) => [
            for (final json in jsonList) Counter.fromJson(json),
          ],
        ) {
    //deselect names (and most importantly set the names as keys)
    //every time the ordered list of names changes

    /// [CSGameAction] Must be initialized after [CSGameGroup]
    newNamesSub = parent.gameGroup.orderedNames.behavior
        .map<String>((names) => names.toString())
        .distinct()
        .listen((s) {
      selected.set(<String, bool?>{
        for (final name in parent.gameGroup.orderedNames.value) name: false,
      });
    });
  }

  //============================
  // Getters

  static GameAction action({
    required int scrollerValue,
    required CSPage? pageValue,
    required Map<String, bool?> selectedValue,
    required int minValue,
    required int maxValue,
    required String attacker,
    required GameState gameState,
    required String defender,
    required Counter counter,
  }) {
    if (scrollerValue == 0) return GANull.instance;

    if (pageValue == CSPage.life) {
      //if they are all deselected this is a null action!
      if (selectedValue.values.every((b) => b == false)) return GANull.instance;

      return GALife(
        scrollerValue,
        selected: selectedValue,
        minVal: minValue,
        maxVal: maxValue,
      );
    }

    if (pageValue == CSPage.commanderCast) {
      if (selectedValue.values.every((b) => b == false)) return GANull.instance;

      return GACast(
        scrollerValue,
        selected: selectedValue,
        maxVal: maxValue,
        usingPartnerB: <String, bool?>{
          for (final entry in gameState.players.entries)
            entry.key: entry.value.usePartnerB,
        },
      );
    }

    if (pageValue == CSPage.commanderDamage) {
      if (attacker != "" && defender != "") {
        return GADamage(
          scrollerValue,
          attacker: attacker,
          defender: defender,
          usingPartnerB: gameState.players[attacker]!.usePartnerB,
          minLife: minValue,
          maxVal: maxValue,
          settings: gameState.players[attacker]!
              .commanderSettings(!gameState.players[attacker]!.usePartnerB),
        );
      }
    }

    if (pageValue == CSPage.counters) {
      return GACounter(
        scrollerValue,
        counter,
        minVal: minValue,
        maxVal: maxValue,
        selected: selectedValue,
      );
    }

    return GANull.instance;
  }

  static GameAction normalizedAction({
    required int scrollerValue,
    required CSPage? pageValue,
    required Map<String, bool?> selectedValue,
    required GameState gameState,
    required int minValue,
    required int maxValue,
    required String attacker,
    required String defender,
    required Counter counter,
  }) =>
      action(
        pageValue: pageValue,
        scrollerValue: scrollerValue,
        selectedValue: selectedValue,
        minValue: minValue,
        maxValue: maxValue,
        attacker: attacker,
        gameState: gameState,
        defender: defender,
        counter: counter,
      ).normalizeOnLast(gameState);

  GameAction currentNormalizedAction(CSPage? page) => normalizedAction(
        scrollerValue: parent.parent.scroller.intValue.value,
        pageValue: page,
        selectedValue: selected.value,
        gameState: parent.gameState.gameState.value,
        minValue: parent.parent.settings.gameSettings.minValue.value,
        maxValue: parent.parent.settings.gameSettings.maxValue.value,
        attacker: attackingPlayer.value,
        defender: defendingPlayer.value,
        counter: counterSet.variable.value,
      );

  bool get isSomeoneAttacking =>
      selected.value.keys.contains(attackingPlayer.value);
  bool get isSomeoneDefending =>
      selected.value.keys.contains(defendingPlayer.value);
  //null means anti-selected! (so somewhat selected indeed)
  bool get isSomeoneSelected => selected.value.values.any((b) => b != false);
  bool get isScrolling => parent.parent.scroller.isScrolling.value;
  bool get actionPending =>
      isScrolling ||
      isSomeoneSelected ||
      isSomeoneAttacking ||
      isSomeoneDefending;

  Map<String, Counter> get currentCounterMap => {
        for (final counter in counterSet.list)
          // if(parent.parent.settings.enabledCounters.value[counter.longName])
          counter.longName: counter,
      };

  //==============================
  // Actions

  void clearSelection([bool alsoAttacker = true]) {
    for (final key in parent.gameState.gameState.value.names) {
      selected.value[key] = false;
    }
    selected.refresh();
    defendingPlayer.set("");
    if (alsoAttacker) attackingPlayer.set("");
  }

  //Do not call this manually, let it be called by the isScrolling's "onChanged" method
  // -> if you want to trigger this, just call scroller.forceComplete()
  void privateConfirm(CSPage? page) {
    final GameAction action = currentNormalizedAction(page);
    parent.gameState.applyAction(action);
    clearSelection(false);
    parent.parent.scroller.value = 0.0;
    parent.parent.scroller.intValue.set(0);
  }

  void chooseCounterByLongName(String newCounterLongName) {
    counterSet.choose(
      counterSet.list.indexWhere(
        (counter) => counter.longName == newCounterLongName,
      ),
    );
    parent.parent.achievements.counterChosen(newCounterLongName);
    parent.parent.tutorial.reactToCounterBeingPicked();
  }
}
