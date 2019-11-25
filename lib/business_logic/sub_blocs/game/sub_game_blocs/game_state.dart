import 'package:counter_spell_new/core.dart';


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
  bool get backable => gameState.value.historyLenght > 1;


  //====================================
  // Constructor
  CSGameState(this.parent): 
    gameState = PersistentVar<GameState>(
      key: "bloc_game_state_blocvar_gamestate",
      initVal: GameState.start(_kNames, {
        for(final counter in DEFAULT_CUSTOM_COUNTERS)
          counter.longName,
      }, startingLife: 40),
      toJson: (s) => s.toJson(),
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
    //the action should be provided as already normalized by the action bloc!
    if(action is GANull) return;

    this.gameState.value.applyAction(action);
    this.gameState.refresh();

    //this reversed index is due to the list UI: it goes from right to 
    //left so it needs to be reversed. also, since the last data is always a null data
    //(the current state without changes), we start at 1 instead of 0
    this.parent.gameHistory.forward(1);

    if(clearFutures) this.futureActions.set(<GameAction>[]);
  }

  void back(){
    if(backable){
      final dataList = this.parent.gameHistory.data;
      //this reversed index is due to the list UI: it goes from right to 
      //left so it needs to be reversed. also, since the last data is always a null data
      //(the current state without changes), we start at 1 instead of 0
      final outgoingData = dataList[dataList.length - 2];
      this._back();
      this.parent.gameHistory.back(1, outgoingData);
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
    }
  }
  void _forward(){
    assert(forwardable);
    this.applyAction(
      futureActions.value
        .removeLast(),
        // .normalizeOnLast(gameState.value),
        //normalizing the future action should be a good practice
        //but we are fairly sure that it wont cause any trouble
      clearFutures: false,
    );
    this.futureActions.refresh();
  }

  void restart()
    => _resetGame(this.gameState.value.newGame(
      startingLife: this.parent.currentStartingLife,
    ));
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


  void renamePlayer(String oldName, String newName){
    if(oldName == null || newName == null){
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
    if(name == null || name == ""){
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


}

const _kNames = {
  "Tony",
  "Stan",
  "Peter",
  "Steve",
};