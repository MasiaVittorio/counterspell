
import 'package:counter_spell_new/models/game/model.dart';
import 'package:flutter/widgets.dart';

class GALife extends GameAction{
  final Map<String,bool> selected;
  final int increment;
  final int minVal;
  final int maxVal;

  const GALife(
    this.increment, {
      @required this.selected,
      this.minVal,
      this.maxVal,
    }
  );

  @override
  Map<String, PlayerAction> actions(names) => {
    for(final name in names)
      name: PALife(
        selected.containsKey(name)
          ? {
            true: increment,
            null: -increment,
            false: 0,
          }[selected[name]]
          : 0,
        minVal: minVal,
        maxVal: maxVal,
      )
  };


}