
import 'package:counter_spell_new/game_model/model.dart';

class GAComposite extends GameAction{
  final Map<String,PlayerAction> actionList;
  const GAComposite(this.actionList);

  @override
  Map<String, PlayerAction> actions(names) => actionList;

}