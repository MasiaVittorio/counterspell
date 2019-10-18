
import 'package:counter_spell_new/models/game/model.dart';
import 'package:flutter/widgets.dart';

class GACast extends GameAction{
  final Map<String,bool> selected;
  final int increment;
  final int maxVal;
  final bool partnerA;

  const GACast(
    this.increment, {
      @required this.selected,
      @required this.partnerA,
      this.maxVal,
    }
  );

  @override
  Map<String, PlayerAction> actions(names) => {
    for(final name in names)
      name: !selected.containsKey(name)
        ? PANull.instance
        : selected[name] == false 
          ? PANull.instance
          : PACast(
            selected[name] == null 
              ? -increment
              : increment, // true
            maxVal: maxVal,
            partnerA: partnerA,
          ),
  };


}