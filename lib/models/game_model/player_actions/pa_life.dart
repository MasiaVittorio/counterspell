import '../all.dart';

class PALife extends PlayerAction {
  final int increment;
  final int minVal;
  final int maxVal;

  const PALife(
    this.increment, 
    {
      int? minVal = PlayerState.kMinValue, 
      int? maxVal = PlayerState.kMaxValue,
    }
  ):  minVal = minVal ?? PlayerState.kMinValue,
      maxVal = maxVal ?? PlayerState.kMaxValue;

  @override
  PlayerState apply(PlayerState state) 
    => state.incrementLife(increment, minVal: minVal, maxVal: maxVal);

  @override
  PlayerAction normalizeOn(PlayerState state) {
    final num clamped = increment.clamp(
      minVal - state.life,
      maxVal - state.life,
    );

    if(clamped == 0) {
      return PANull.instance;
    }

    return PALife(
      clamped as int,
      minVal: minVal,
      maxVal: maxVal,
    );
  }
}
