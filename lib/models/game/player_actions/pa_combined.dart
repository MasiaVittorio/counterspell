import '../model.dart';

class PACombined extends PlayerAction {
  final List<PlayerAction> actions;

  const PACombined(
    this.actions, 
  );

  @override
  PlayerState apply(PlayerState state) {
    PlayerState s = state;
    for(final action in actions){
      s = action.apply(s);
    }
    return s;
  }

  @override
  PlayerAction normalizeOn(PlayerState state) 
    => PACombined([
      for(final action in this.actions)
        action.normalizeOn(state),
    ]);
}
