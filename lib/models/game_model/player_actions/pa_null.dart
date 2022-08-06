import '../all.dart';

class PANull extends PlayerAction {
  const PANull();

  @override
  PlayerState apply(PlayerState state) {
    return state.updateTime();
  }

  @override
  PlayerAction normalizeOn(PlayerState state)
    => PANull.instance;

  static const PANull instance = PANull();
}

