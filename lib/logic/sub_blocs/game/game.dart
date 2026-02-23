import 'package:counter_spell/core.dart';

class CSGame {
  void dispose() {
    gameState.dispose();
    gameAction.dispose();
  }

  //===============================
  // Values
  final CSBloc parent;
  late CSGameState gameState;
  late CSGameAction gameAction;
  late CSGameGroup gameGroup;
  late CSGameHistory gameHistory;

  //===============================
  // Getters

  int get currentStartingLife =>
      parent.settings.gameSettings.currentStartingLife;

  //===============================
  // Constructor
  CSGame(this.parent) {
    gameState = CSGameState(this);

    /// [CSGameGroup] Must be initialized after [CSGameState]
    gameGroup = CSGameGroup(this);

    /// [CSGameHistory] Must be initialized after [CSGameState]
    gameHistory = CSGameHistory(this);

    /// [CSGameAction] Must be initialized after [CSGameGroup]
    gameAction = CSGameAction(this);
  }
}
