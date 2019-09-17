import 'package:counter_spell_new/models/game/model.dart';
import 'package:sidereus/sidereus.dart';

import '../game.dart';

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
      initVal: GameState.start(_kNames, startingLife: 40),
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
      this.gameState.value.back()
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
  void startNew(Set<String> names)
    => _resetGame(GameState.start(
      names, 
      startingLife: this.parent.currentStartingLife,
    ));
  void _resetGame(GameState newGameState){
    this.gameState.set(newGameState);
    this.parent.gameHistory.listController.refresh(1);
    this.futureActions.set(<GameAction>[]);
  }


  void renamePlayer(String oldName, String newName){
    this.gameState.value.renamePlayer(oldName, newName);
    this.gameState.refresh();
    this.parent.gameHistory.listController.rebuild();
  }
  void deletePlayer(String name){
    this.gameState.value.deletePlayer(name);
    this.gameState.refresh();
    this.parent.gameHistory.listController.rebuild();
  }
  void addNewPlayer(String name){
    this.gameState.value.addNewPlayer(
      name, 
      startingLife: this.parent.currentStartingLife,
    );
    this.parent.gameHistory.listController.rebuild();
  }


}

const _kNames = {
  "Tony",
  "Stan",
  "Peter",
  "Steve",
};