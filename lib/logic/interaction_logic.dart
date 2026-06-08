import 'package:counter_spell/logic/game_logic.dart';
import 'package:counter_spell/logic/pages_logic.dart';
import 'package:counter_spell/logic/settings_logic.dart';
import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:counter_spell/models/interaction/scroll_settings.dart';
import 'package:counter_spell/models/interaction/velocity_drag_update_details.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:sid_base/sid_base.dart';

class InteractionLogic extends LogicBase {
  final Reactive<int?> attackingPlayerIndex = Reactive(null);

  final Reactive<int?> defendingPlayerIndex = Reactive(null);

  late Reactive<List<bool?>> playersMultiSelection;
  late Reactive<List<bool>> usingPartnerA;

  final PersistentReactive<ScrollSettings> scrollSettings = PersistentReactive(
    ScrollSettings(),
    key: 'scrollSettings5',
    toJsonEncodable: (value) => value.toMap(),
    fromJsonDecoded: (jsonDecoded) => ScrollSettings.fromMap(jsonDecoded),
  );

  final selectedCounter = PersistentReactive<Counter>(
    Counter.poison,
    key: 'selectedCounter',
    toJsonEncodable: (value) => value.name,
    fromJsonDecoded: (jsonDecoded) =>
        Counter.values.firstWhere((element) => element.name == jsonDecoded),
  );

  double generalIncrementDouble = 0;
  final Reactive<int> generalIncrement = Reactive(0);
  final PersistentReactive<Duration> confirmationDelay = PersistentReactive(
    const Duration(milliseconds: 950),
    key: 'confirmationDelay',
    toJsonEncodable: (value) => value.inMilliseconds,
    fromJsonDecoded: (jsonDecoded) => Duration(milliseconds: jsonDecoded),
  );

  @override
  void dispose() {
    attackingPlayerIndex.dispose();
    defendingPlayerIndex.dispose();
    playersMultiSelection.dispose();
    usingPartnerA.dispose();
    scrollSettings.dispose();
    selectedCounter.dispose();
    generalIncrement.dispose();
    gameLogic.removeGameListener(_gameListener);
    pagesLogic.bodyPage.removeListener(_pagesListener);
    super.dispose();
  }

  final GameLogic gameLogic;
  final PagesLogic pagesLogic;
  final SettingsLogic settingsLogic; // for vibration check

  InteractionLogic({
    required this.gameLogic,
    required this.pagesLogic,
    required this.settingsLogic,
  }) {
    final n = gameLogic.readGame().playerCount;
    playersMultiSelection = Reactive([for (int i = 0; i < n; i++) false]);
    usingPartnerA = Reactive([for (int i = 0; i < n; i++) true]);
    gameLogic.addGameListener(_gameListener);
    pagesLogic.bodyPage.addListener(_pagesListener);
  }

  void _gameListener() {
    final n = gameLogic.readGame().playerCount;
    if (playersMultiSelection.value.length != n) {
      playersMultiSelection.update([for (int i = 0; i < n; i++) false]);
    }
    if (usingPartnerA.value.length != n) {
      usingPartnerA.update([for (int i = 0; i < n; i++) true]);
    }
  }

  void _pagesListener() {
    clearMultiSelection();
    deselectDefendingPlayer();
    deselectAttackingPlayer();
  }

  void applyGeneral() {
    if (pagesLogic.bodyPage.value != BodyPage.history) {
      gameLogic.editGame(
        (game) => game.applyGeneralInteraction(
          playersMultiSelection: playersMultiSelection.value,
          increment: generalIncrement.value,
          attackingPlayerIndex: attackingPlayerIndex.value,
          defendingPlayerIndex: defendingPlayerIndex.value,
          selectedCounter: selectedCounter.value,
          usingPartnerA: usingPartnerA.value,
          mode: pagesLogic.bodyPage.value.toInteractionMode()!,
        ),
      );
    }
    _editGeneralIncrement(0);
    clearMultiSelection();
    deselectDefendingPlayer();
  }

  void _editGeneralIncrement(double newValue) {
    generalIncrementDouble = newValue;
    final bool distinct = generalIncrement.update(
      newValue.abs().floor() * newValue.sign.round(),
    );
    if (distinct) {
      settingsLogic.vibrate();
    }
  }

  void advancedViewScrollUpdate({
    required VelocityDragUpdateDetails details,
    required double screenWidth,
  }) {
    _editGeneralIncrement(
      scrollSettings.value.editValue(
        value: generalIncrementDouble,
        vertical: false,
        details: details,
        screenWidth: screenWidth,
      ),
    );
  }

  void advancedViewTapPlayer(int playerIndex) {
    switch (pagesLogic.bodyPage.value) {
      case BodyPage.history:
        pagesLogic.bodyPage.update(BodyPage.life);
        clearMultiSelection();
        deselectDefendingPlayer();
        deselectAttackingPlayer();
        return;
      case final BodyPage page:
        tapPlayer(playerIndex, mode: page.toInteractionMode()!);
    }
  }

  void tapPlayer(int playerIndex, {required InteractionMode mode}) {
    switch (mode) {
      case InteractionMode.counters:
      case InteractionMode.life:
      case InteractionMode.cast:
        togglePlayer(playerIndex: playerIndex);
        return;
      case InteractionMode.damage:
        clearMultiSelection();
        deselectDefendingPlayer();
        if (attackingPlayerIndex.value == playerIndex) {
          deselectAttackingPlayer();
        } else {
          selectAttackingPlayer(playerIndex: playerIndex);
        }
        return;
    }
  }

  void advancedViewScrollStart(int playerIndex) {
    switch (pagesLogic.bodyPage.value) {
      case BodyPage.history:
        return;
      case BodyPage.counters:
      case BodyPage.life:
      case BodyPage.cast:
        if (playersMultiSelection.value[playerIndex] == false) {
          selectPlayer(playerIndex: playerIndex);
        }
        return;
      case BodyPage.damage:
        if (attackingPlayerIndex.value == null) return;
        selectDefendingPlayer(playerIndex: playerIndex);
    }
  }

  void selectCounter(Counter counter) {
    selectedCounter.update(counter);
  }

  void usePartnerA(int playerIndex) {
    updatePartnerA(playerIndex, true);
  }

  void usePartnerB(int playerIndex) {
    updatePartnerA(playerIndex, false);
  }

  void updatePartnerA(int playerIndex, bool value) {
    if (playerIndex >= usingPartnerA.value.length) {
      _gameListener();
      if (playerIndex >= usingPartnerA.value.length) return;
    }
    usingPartnerA.value[playerIndex] = value;
    usingPartnerA.refresh();
  }

  void togglePartnerA(int playerIndex) {
    updatePartnerA(playerIndex, !usingPartnerA.value[playerIndex]);
  }

  void selectAttackingPlayer({required int playerIndex}) {
    attackingPlayerIndex.update(playerIndex);
  }

  void deselectAttackingPlayer() {
    attackingPlayerIndex.update(null);
  }

  void selectDefendingPlayer({required int playerIndex}) {
    defendingPlayerIndex.update(playerIndex);
  }

  void deselectDefendingPlayer() {
    defendingPlayerIndex.update(null);
  }

  void antiSeselectPlayer({required int playerIndex}) {
    updatePlayerSelection(playerIndex: playerIndex, value: null);
  }

  void deselectPlayer({required int playerIndex}) {
    updatePlayerSelection(playerIndex: playerIndex, value: false);
  }

  void selectPlayer({required int playerIndex}) {
    updatePlayerSelection(playerIndex: playerIndex, value: true);
  }

  void togglePlayer({required int playerIndex}) {
    updatePlayerSelection(
      playerIndex: playerIndex,
      value: playersMultiSelection.value[playerIndex] == true ? false : true,
    );
  }

  void updatePlayerSelection({required int playerIndex, required bool? value}) {
    playersMultiSelection.value[playerIndex] = value;
    int count = 0;
    for (final v in playersMultiSelection.value) {
      if (v == null || v == true) ++count;
    }
    if (count < 2) {
      for (int i = 0; i < playersMultiSelection.value.length; i++) {
        if (playersMultiSelection.value[i] == null) {
          playersMultiSelection.value[i] = true;
        }
      }
    }
    playersMultiSelection.refresh();
  }

  void clearMultiSelection() {
    playersMultiSelection.value = [
      for (final _ in playersMultiSelection.value) false,
    ];
    playersMultiSelection.refresh();
  }

  void cancelAdvancedInteraction() {
    clearMultiSelection();
    deselectDefendingPlayer();
    deselectAttackingPlayer();
    _editGeneralIncrement(0);
  }

  void cancelOngoingInteractionButKeepSelections() {
    deselectDefendingPlayer();
    _editGeneralIncrement(0);
  }

  void increase() {
    generalIncrement.update(generalIncrement.value + 1);
    settingsLogic.vibrate();
  }

  void decrease() {
    generalIncrement.update(generalIncrement.value - 1);
    settingsLogic.vibrate();
  }
}
