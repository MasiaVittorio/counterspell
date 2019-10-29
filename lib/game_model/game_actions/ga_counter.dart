
import 'package:counter_spell_new/game_model/model.dart';
import 'package:counter_spell_new/game_model/player_actions/pa_counter.dart';
import 'package:counter_spell_new/game_model/types/counters.dart';
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
  Map<String, PlayerAction> actions(names) {
    if(counter.uniquePlayer){
      int number = [for(final name in names) if(selected[name] != false) name].length;
      assert(number <= 1);

    }
    return {
      for(final name in names)
        name: !selected.containsKey(name)
          ? PANull.instance
          : selected[name] == false 
            ? this.counter.uniquePlayer 
              ? PACounterReset(this.counter) 
              : PANull.instance
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


}