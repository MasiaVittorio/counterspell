import 'dart:math';
import '../all.dart';

class PACounter extends PlayerAction {
  final int increment;
  final int minVal;
  final int maxVal;
  final Counter counter;

  const PACounter(
    this.increment, 
    this.counter,
    {
      this.minVal = PlayerState.kMinValue, 
      this.maxVal = PlayerState.kMaxValue,
    }
  );

  @override
  PlayerState apply(PlayerState state) => state.incrementCounter(
    counter, 
    increment,
    minValue: minVal,
    maxValue: maxVal,
  );

  @override
  PlayerAction normalizeOn(PlayerState state) {
    final int current  = state.counters[counter.longName] ?? 0;
    final int clamped = increment.clamp(
      max<int>(minVal, counter.minValue) - current,
      min<int>(maxVal, counter.maxValue) - current,
    );

    if(clamped == 0) {
      return PANull.instance;
    }

    return PACounter(
      clamped,
      counter,
      minVal: minVal,
      maxVal: maxVal,
    );
  }
}


class PACounterReset extends PlayerAction {
  final Counter counter;

  const PACounterReset(
    this.counter,
  );

  @override
  PlayerState apply(PlayerState state) => state.incrementCounter(
    counter, 
    - state.counters[counter.longName]!,
  );

  @override
  PlayerAction normalizeOn(PlayerState state) {
    return PACounterReset(counter);
  }
}
