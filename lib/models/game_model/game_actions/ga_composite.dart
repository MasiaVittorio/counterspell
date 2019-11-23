import '../all.dart';

class GAComposite extends GameAction{
  final Map<String,PlayerAction> actionList;
  const GAComposite(this.actionList);

  @override
  Map<String, PlayerAction> actions(names) => actionList;

}