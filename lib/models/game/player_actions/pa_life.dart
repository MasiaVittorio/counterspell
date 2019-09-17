import '../model.dart';

class PALife extends PlayerAction {
  final int increment;
  final int minVal;
  final int maxVal;

  const PALife(
    this.increment, 
    {
      this.minVal = PlayerState.kMinValue, 
      this.maxVal = PlayerState.kMaxValue,
    }
  ):  assert(minVal != null),
      assert(maxVal != null);

  @override
  PlayerState apply(PlayerState state) 
    => state.incrementLife(increment, minVal: minVal, maxVal: maxVal);

  @override
  PlayerAction normalizeOn(PlayerState state) {
    final clamped = this.increment.clamp(
      this.minVal - state.life,
      this.maxVal - state.life,
    );

    if(clamped == 0) 
      return PANull.instance;

    return PALife(
      clamped,
      minVal: this.minVal,
      maxVal: this.maxVal,
    );
  }
}
