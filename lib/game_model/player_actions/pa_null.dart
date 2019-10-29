import '../model.dart';

class PANull extends PlayerAction {
  const PANull();

  @override
  PlayerState apply(PlayerState state) {
    return state;
  }

  @override
  PlayerAction normalizeOn(PlayerState state)
    => PANull.instance;

  static const PANull instance = const PANull();
}

