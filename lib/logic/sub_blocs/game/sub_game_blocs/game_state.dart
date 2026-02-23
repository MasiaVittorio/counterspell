import 'package:counter_spell/core.dart';
// import 'package:flutter/foundation.dart';

class CSGameState {
  void dispose() {
    gameState.dispose();
    futureActions.dispose();
  }

  //====================================
  // Values

  final PersistentVar<GameState> gameState;
  final BlocVar<List<GameAction>> futureActions;

  final CSGame parent;

  //====================================
  // Getters

  bool get forwardable => futureActions.value.isNotEmpty;
  bool get backable => pastLenght > 1;
  bool forgettable(int index) => pastLenght > index + 1;
  bool mergableWithPrevious(int index) => pastLenght > index + 2;
  int get pastLenght => gameState.value.historyLenght;

  //====================================
  // Constructor
  CSGameState(this.parent)
      : gameState = PersistentVar<GameState>(
          key: "counterspell_bloc_game_state_blocvar_gameState",
          initVal: defaultGameState,
          toJson: (s) => s.toJson(),
          fromJson: (j) => GameState.fromJson(j),
          readCallback: (state) => afterReadGameState(state, parent),
        ),
        futureActions = BlocVar<List<GameAction>>([]);

  static void afterReadGameState(GameState afterReadState, CSGame parent) {
    parent.gameHistory.listController.refresh(afterReadState.historyLenght);
    parent.gameGroup.reactToGameState(afterReadState);
  }

  static GameState get defaultGameState {
    return GameState.start(
        _kNames,
        {
          for (final counter in Counter.defaultList) counter.longName,
        },
        startingLife: 40);
  }

  //====================================
  // Actions
  void applyAction(GameAction action, {bool clearFutures = true}) {
    if (_applyAction(action, clearFutures: clearFutures)) {
      parent.gameHistory.forward();
    }
    parent.parent.achievements.gameActionPerformed(action);
  }

  bool _applyAction(GameAction action, {bool clearFutures = true}) {
    //the action should be provided as already normalized by the action bloc!
    if (action is GANull) return false;

    gameState.value.applyAction(action);
    gameState.refresh();
    if (clearFutures) futureActions.set(<GameAction>[]);

    return true;
  }

  void back() {
    if (backable) {
      final dataList = parent.gameHistory.data;
      //this reversed index is due to the list UI: it goes from right to
      //left so it needs to be reversed. also, since the last data is always a null data
      //(the current state without changes), we start at 1 instead of 0
      final outgoingData = dataList[dataList.length - 2];
      _back();
      parent.gameHistory.back(outgoingData, dataList.first.time);
      parent.parent.tutorial.reactToHistoryBackOrForward();
    }
  }

  void _back() {
    assert(backable);
    futureActions.value
        .add(gameState.value.back(parent.gameAction.currentCounterMap));
    gameState.refresh();
    futureActions.refresh();
  }

  void forward() {
    if (forwardable) {
      _forward();
      parent.gameHistory.forward();
      parent.parent.tutorial.reactToHistoryBackOrForward();
    }
  }

  void _forward() {
    assert(forwardable);
    _applyAction(
      futureActions.value.removeLast(),
      // .normalizeOnLast(gameState.value),
      //normalizing the future action should be a good practice
      //but we are fairly sure that it wont cause any trouble
      clearFutures: false,
    );
    futureActions.refresh();
  }

  void forgetPast(int index) {
    //index = 0 -> as if was back
    final indexFromHistory = index + 1;
    if (forgettable(index)) {
      final dataList = parent.gameHistory.data;
      //this reversed index is due to the list UI: it goes from right to
      //left so it needs to be reversed. also, since the last data is always a null data
      //(the current state without changes), we start at 1 instead of 0
      final outgoingData = dataList[dataList.length - 1 - indexFromHistory];
      _forgetPast(index);
      parent.gameHistory
          .animateForget(indexFromHistory, outgoingData, dataList.first.time);
    }
  }

  void _forgetPast(int index) {
    assert(forgettable(index));

    for (int i = 0; i <= index; ++i) {
      //"<=" important
      _back();
    }
    futureActions.value.removeLast();
    for (int i = 0; i < index; ++i) {
      //"< " important
      _forward();
    }
    futureActions.refresh();
  }

  void mergeWithPrevious(int indexFromHistory) {
    // index from history will be 1 for the first element (would be zero for
    // the current state but that does not represent an action so it doesn't
    // make sense to call merge from 0)
    // if 6 actions were made, history data will be 7 because there are 6 actions and a current game state
    //
    int index = indexFromHistory - 1;
    if (mergableWithPrevious(index)) {
      final dataList = parent.gameHistory.data;
      //this reversed index is due to the list UI: it goes from right to
      //left so it needs to be reversed. also, since the last data is always a null data
      //(the current state without changes), we start at 1 instead of 0
      final outgoingDataThat = dataList[dataList.length - 1 - indexFromHistory];
      final outgoingDataPrev =
          dataList[dataList.length - 1 - (indexFromHistory + 1)];
      _mergeWithPrevious(index);
      parent.gameHistory.animateForget(
          indexFromHistory, outgoingDataThat, dataList.first.time);
      parent.gameHistory.animateForget(
          indexFromHistory, outgoingDataPrev, dataList.first.time);
      parent.gameHistory.animateRemember(indexFromHistory);
    }
  }

  void _mergeWithPrevious(int index) {
    // this index: 0 means the most recent action, not the most recent state
    assert(mergableWithPrevious(index));

    for (int i = 0; i <= index + 1; ++i) {
      //"<=" important
      _back();
      // so index == 0 means we will go back twice, which makes sense
    }

    final prev = futureActions.value.removeLast();
    final that = futureActions.value.removeLast();
    final names = parent.gameGroup.orderedNames.value.toSet();

    final initialState = GameState.fromJson(gameState.value.toJson());
    final evolvedState = GameState.fromJson(initialState.toJson());
    evolvedState.applyAction(prev);
    evolvedState.applyAction(that);

    final mergedAction = GameAction.fromPlayerActions({
      for (final name in names)
        name: PlayerAction.fromStates(
          previous: initialState.players[name]!.states.last,
          next: evolvedState.players[name]!.states.last,
          counterMap: parent.gameAction.currentCounterMap,
        ),
    });

    _applyAction(mergedAction, clearFutures: false);

    for (int i = 0; i <= index - 1; ++i) {
      _forward();
    }
    futureActions.refresh();
  }

  /// This is the method callable by the UI, all the other restart-related methods
  /// are to be considered private use of the Business Logic
  void restart(
    GameRestartedFrom? from, {
    bool avoidPrompt = false,
    bool avoidClosingPanel = false,

    /// for auto restart on changing life
  }) async {
    //check if the game is to be saved and the prompt to chose the winner is displayed
    final bool promptShown = parent.parent.pastGames.saveGame(
      gameState.value,
      commandersA: parent.gameGroup.cardsA.value,
      commandersB: parent.gameGroup.cardsB.value,
      avoidPrompt: avoidPrompt,
    );
    //actually resets the game
    _resetGame(gameState.value.newGame(
      startingLife: parent.currentStartingLife,
      keepCommanderSettings: parent
          .parent.settings.gameSettings.keepCommanderSettingsBetweenGames.value,
    ));
    //exit history page (or any other) or the menu
    parent.parent.stage.mainPagesController.goToPage(CSPage.life);
    if (!promptShown) {
      if (!avoidClosingPanel) {
        parent.parent.stage.closePanelCompletely();
      }
    }

    parent.parent.achievements.gameRestarted(from);
  }

  void startNew(Set<String> names) {
    parent.gameGroup.newGroup(names.toList());
    _resetGame(GameState.start(
      names,
      <String>{
        for (final counter in parent.gameAction.counterSet.list)
          counter.longName
      },
      startingLife: parent.currentStartingLife,
    ));
  }

  void _resetGame(GameState newGameState) {
    gameState.set(newGameState);
    parent.gameGroup.reactToGameState(newGameState);
    parent.gameHistory.listController.refresh(newGameState.historyLenght);
    futureActions.set(<GameAction>[]);
    parent.gameAction.clearSelection();
  }

  void overwriteGame(GameState newGameState) => _resetGame(newGameState);

  void renamePlayer(String? oldName, String newName) {
    if (oldName == null) {
      return;
    }
    if (oldName == "" || newName == "") {
      return;
    }
    if (!gameState.value.players.containsKey(oldName)) {
      return;
    }
    if (gameState.value.players.containsKey(newName)) {
      return;
    }
    gameState.value.renamePlayer(oldName, newName);
    parent.gameGroup.rename(oldName, newName);
    gameState.refresh();
    parent.gameHistory.listController.rebuild();
  }

  void deletePlayer(String name) {
    if (!gameState.value.players.containsKey(name)) {
      return;
    }
    if (gameState.value.players.length <= 1) {
      return;
    }
    gameState.value.deletePlayer(name);
    parent.gameGroup.deletePlayer(name);
    // this.parent.gameHistory.deletePlayerReferences(name);
    gameState.refresh();
    parent.gameHistory.listController.rebuild();
  }

  void addNewPlayer(String name) {
    if (name == "") {
      return;
    }
    if (gameState.value.players.containsKey(name)) {
      return;
    }
    gameState.value.addNewPlayer(
      name,
      startingLife: parent.currentStartingLife,
    );
    gameState.refresh();
    parent.gameGroup.newPlayer(name);
    parent.gameHistory.listController.rebuild();
  }

  void toggleHavePartner(String name) {
    assert(gameState.value.players.containsKey(name));

    gameState.value.players[name]!.havePartnerB =
        !gameState.value.players[name]!.havePartnerB;
    gameState.value.players[name]!.usePartnerB = false;
    gameState.refresh();

    parent.parent.tutorial.reactToHavingPartnerToggle();
  }

  void setHavePartner(String name, bool partner) {
    assert(gameState.value.players.containsKey(name));

    gameState.value.players[name]!.havePartnerB = partner;
    gameState.value.players[name]!.usePartnerB = false;
    gameState.refresh();
  }

  bool toggleUsePartner(String name, {bool force = false}) {
    assert(gameState.value.players.containsKey(name));

    late final bool result;
    if (!gameState.value.players[name]!.havePartnerB) {
      if (force) {
        gameState.value.players[name]!.havePartnerB = true;
        gameState.refresh();
        result = true;
      } else {
        result = false;
      }
    } else {
      gameState.value.players[name]!.usePartnerB =
          !gameState.value.players[name]!.usePartnerB;
      gameState.refresh();
      result = true;
    }

    if (result) {
      parent.parent.tutorial.reactToUsingPartnerToggle();
    }

    return result;
  }
}

const _kNames = {
  "Tony",
  "Stan",
  "Peter",
  "Gwen",
};


// dynamic _serializeGameState(GameState gameState){
//   return gameState.toJson();
// }