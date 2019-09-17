import 'package:counter_spell_new/blocs/sub_blocs/game/sub_game_blocs.dart/game_group.dart';
import 'package:counter_spell_new/blocs/sub_blocs/game/sub_game_blocs.dart/game_history.dart';

import 'sub_game_blocs.dart/game_action.dart';
import 'sub_game_blocs.dart/game_state.dart';

import '../../bloc.dart';

class CSGame {

  void dispose(){
    gameState.dispose();
    gameAction.dispose();
  }


  //===============================
  // Values
  final CSBloc parent;
  CSGameState gameState;
  CSGameAction gameAction;
  CSGameGroup gameGroup;
  CSGameHistory gameHistory;




  //===============================
  // Getters

  int get currentStartingLife => this.parent.settings.startingLife.value;


  //===============================
  // Constructor
  CSGame(this.parent){
    gameState = CSGameState(this);
    /// [CSGameGroup] Must be initialized after [CSGameState]
    gameGroup = CSGameGroup(this);
    /// [CSGameHistory] Must be initialized after [CSGameState]
    gameHistory = CSGameHistory(this);
    /// [CSGameAction] Must be initialized after [CSGameGroup]
    gameAction = CSGameAction(this);
  }

}