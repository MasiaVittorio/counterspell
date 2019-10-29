
import 'package:counter_spell_new/game_model/model.dart';

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

  static const GANull instance = const GANull();
}