import 'all.dart';


abstract class GameAction{

  //=============================
  // To be abstracted

  const GameAction();
  Map<String,PlayerAction> actions(Set<String> names);

  GameAction normalizeOnLast(GameState state) {
    final map = actions(state.names);
    final normalizedMap = {
      for(final entry in map.entries)
        entry.key : entry.value.normalizeOn(
          state.players[entry.key]!.states.last,
        )
    };
    return GameAction.fromPlayerActions(normalizedMap);
  }


  //=============================
  // Factory

  factory GameAction.fromPlayerActions(
    Map<String,PlayerAction> actions
  ){
    if(actions.values.every((action) => action is PANull)) {
      return GANull.instance;
    }

    return GAComposite(actions);
  }




  //=============================
  // Actions

  void applyTo(GameState state){
    final Map<String, PlayerAction> map = actions(
      state.names
    );

    for(final entry in state.players.entries){
      entry.value.applyAction(
        map[entry.key]!
      );
    }

  }

}


