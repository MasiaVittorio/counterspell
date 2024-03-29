import '../all.dart';

class GANull extends GameAction{

  const GANull();

  @override
  Map<String, PlayerAction> actions(Set<String> names) => {
    for(final n in names)
      n: PANull.instance,
  };

  @override
  GameAction normalizeOnLast(GameState state)
    => GANull.instance;

  static const GANull instance = GANull();
}