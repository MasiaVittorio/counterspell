
import 'package:counter_spell_new/models/game/model.dart';
import 'package:counter_spell_new/models/game/player_actions/pa_counter.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:flutter/widgets.dart';

class GACounter extends GameAction{
  final Map<String,bool> selected;
  final Counter counter;
  final int increment;
  final int minVal;
  final int maxVal;

  const GACounter(
    this.increment, 
    this.counter, {
      @required this.selected,
      @required this.minVal,
      @required this.maxVal,
    }
  );

  @override
  Map<String, PlayerAction> actions(names) => {
    for(final name in names)
      name: !selected.containsKey(name)
        ? PANull.instance
        : selected[name] == false 
          ? PANull.instance
          : PACounter(
            selected[name] == null 
              ? -increment
              : increment, // true
            this.counter,
            maxVal: maxVal,
            minVal: minVal,
          ),
  };


}