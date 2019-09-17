
import 'package:counter_spell_new/models/game/model.dart';

class GAComposite extends GameAction{
  final Map<String,PlayerAction> actionList;
  const GAComposite(this.actionList);

  @override
  Map<String, PlayerAction> actions(names) => actionList;

}