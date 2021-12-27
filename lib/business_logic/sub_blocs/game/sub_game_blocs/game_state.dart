import 'package:counter_spell_new/core.dart';
// import 'package:flutter/foundation.dart';


class CSGameState {

  void dispose(){
    this.gameState.dispose();
    this.futureActions.dispose();
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
  int get pastLenght => gameState.value.historyLenght;


  //====================================
  // Constructor
  CSGameState(this.parent): 
    gameState = PersistentVar<GameState>(
      key: "counterspell_bloc_game_state_blocvar_gameState",
      initVal: GameState.start(_kNames, {
        for(final counter in Counter.defaultList)
          counter.longName,
      }, startingLife: 40),
      toJson: (s) => s.toJson(),
      // toJson: (state) async {
      //   ///This serialization may be heavy due to long history and quick and repeated edits on this var
      //   ///Can therefore risk skipping frames on the UI Thread. Let's spawn an isolate to handle it
      //   final result = await compute(
      //     _serializeGameState,
      //     state,
      //   );
      //   return result;
      // },
      fromJson: (j) => GameState.fromJson(j),
      readCallback: (afterReadState) 
        => parent.gameHistory.listController.refresh(
          afterReadState.historyLenght
        ),
    ),
    futureActions = BlocVar<List<GameAction>>([]);



  //====================================
  // Actions
  void applyAction(GameAction action, {bool clearFutures = true}){
    if(_applyAction(action, clearFutures: clearFutures)){
      this.parent.gameHistory.forward();
    }
    this.parent.parent.achievements.gameActionPerformed(action);
  }
  bool _applyAction(GameAction action, {bool clearFutures = true}){
    //the action should be provided as already normalized by the action bloc!
    if(action is GANull) return false;

    this.gameState.value.applyAction(action);
    this.gameState.refresh();
    if(clearFutures) this.futureActions.set(<GameAction>[]);

    return true;
  }

  void back(){
    if(backable){
      final dataList = this.parent.gameHistory.data;
      //this reversed index is due to the list UI: it goes from right to 
      //left so it needs to be reversed. also, since the last data is always a null data
      //(the current state without changes), we start at 1 instead of 0
      final outgoingData = dataList[dataList.length - 2];
      this._back();
      this.parent.gameHistory.back(outgoingData, dataList.first.time);
    }
  }
  void _back(){
    assert(backable);
    this.futureActions.value.add(
      this.gameState.value.back(this.parent.gameAction.currentCounterMap)
    );
    this.gameState.refresh();
    this.futureActions.refresh();
  }
  void forward(){
    if(forwardable){
      this._forward();
      this.parent.gameHistory.forward();
    }
  }
  void _forward(){
    assert(forwardable);
    this._applyAction(
      futureActions.value
        .removeLast(),
        // .normalizeOnLast(gameState.value),
        //normalizing the future action should be a good practice
        //but we are fairly sure that it wont cause any trouble
      clearFutures: false,
    );
    this.futureActions.refresh();
  }

  void forgetPast(int index){
    //index = 0 -> as if was back
    if(forgettable(index)){
      final dataList = this.parent.gameHistory.data;
      //this reversed index is due to the list UI: it goes from right to 
      //left so it needs to be reversed. also, since the last data is always a null data
      //(the current state without changes), we start at 1 instead of 0
      final outgoingData = dataList[dataList.length - 2 - index];
      _forgetPast(index);
      this.parent.gameHistory.forget(index+1, outgoingData, dataList.first.time);
    }
  }

  void _forgetPast(int index){
    assert(forgettable(index));

    for(int i=0; i<=index; ++i){
      //"<=" important
      this._back();
    }
    this.futureActions.value.removeLast();
    for(int i=0; i< index; ++i){
      //"< " important
      this._forward();
    }
    this.futureActions.refresh();

  }

  /// This is the method callable by the UI, all the other restart-related methods 
  /// are to be considered private use of the Business Logic
  void restart(
    GameRestartedFrom? from, {
      bool avoidPrompt = false, 
      bool avoidClosingPanel = false, /// for auto restart on changing life
    }
  ) async {
    //check if the game is to be saved and the prompt to chose the winner is displayed
    final bool promptShown = this.parent.parent.pastGames.saveGame(
      this.gameState.value, 
      commandersA: this.parent.gameGroup.cardsA.value, 
      commandersB: this.parent.gameGroup.cardsB.value,
      avoidPrompt: avoidPrompt,
    );
    //actually resets the game
    _resetGame(this.gameState.value.newGame(
      startingLife: this.parent.currentStartingLife,
      keepCommanderSettings: this.parent.parent.settings!.gameSettings.keepCommanderSettingsBetweenGames.value,
    ));
    //exit history page (or any other) or the menu
    this.parent.parent.stage!.mainPagesController.goToPage(CSPage.life);
    if(!promptShown) {
      if(!avoidClosingPanel){
        this.parent.parent.stage!.closePanelCompletely();
      }
    }

    this.parent.parent.achievements.gameRestarted(from);
  }

  void startNew(Set<String> names){
    this.parent.gameGroup.newGroup(names.toList());
    _resetGame(GameState.start(
      names, 
      <String>{for(final counter in this.parent.gameAction.counterSet.list) 
        counter.longName
      },
      startingLife: this.parent.currentStartingLife,
    ));
  }
  void _resetGame(GameState newGameState){
    this.gameState.set(newGameState);
    this.parent.gameHistory.listController.refresh(1);
    this.futureActions.set(<GameAction>[]);
  }


  void renamePlayer(String? oldName, String newName){
    if(oldName == null){
      return;
    }
    if(oldName == "" || newName == ""){
      return;
    }
    if(!this.gameState.value.players.containsKey(oldName)){
      return;
    }
    if(this.gameState.value.players.containsKey(newName)){
      return;
    }
    this.gameState.value.renamePlayer(oldName, newName);
    this.parent.gameGroup.rename(oldName, newName);
    this.gameState.refresh();
    this.parent.gameHistory.listController.rebuild();
  }
  void deletePlayer(String name){
    if(!gameState.value.players.containsKey(name)){
      return;
    }
    if(gameState.value.players.length <= 1){
      return;
    }
    this.gameState.value.deletePlayer(name);
    this.parent.gameGroup.deletePlayer(name);
    // this.parent.gameHistory.deletePlayerReferences(name);
    this.gameState.refresh();
    this.parent.gameHistory.listController.rebuild();
  }
  void addNewPlayer(String name){
    if(name == ""){
      return;
    }
    if(this.gameState.value.players.containsKey(name)){
      return;
    }
    this.gameState.value.addNewPlayer(
      name, 
      startingLife: this.parent.currentStartingLife,
    );
    this.gameState.refresh();
    this.parent.gameGroup.newPlayer(name);
    this.parent.gameHistory.listController.rebuild();
  }

  void toggleHavePartner(String name){
    assert(gameState.value.players.containsKey(name));

    this.gameState.value.players[name]!.havePartnerB = 
      !this.gameState.value.players[name]!.havePartnerB!;
    this.gameState.value.players[name]!.usePartnerB = false;
    this.gameState.refresh();
  }
  
  void setHavePartner(String name, bool partner){
    assert(gameState.value.players.containsKey(name));

    this.gameState.value.players[name]!.havePartnerB = partner;
    this.gameState.value.players[name]!.usePartnerB = false;
    this.gameState.refresh();
  }

  bool toggleUsePartner(String name, {bool force = false}){
    assert(gameState.value.players.containsKey(name));

    if(!gameState.value.players[name]!.havePartnerB!){
      if(force){
        this.gameState.value.players[name]!.havePartnerB = true;
        this.gameState.refresh();
        return true;
      } else {
        return false; 
      }
    } 

    this.gameState.value.players[name]!.usePartnerB = 
      !this.gameState.value.players[name]!.usePartnerB!;
    this.gameState.refresh();
    return true;
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