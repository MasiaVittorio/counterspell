import '../all.dart';

class PACast extends PlayerAction {
  final int increment;
  final int maxVal;
  final bool partnerA;

  static const _minVal = 0;
  const PACast(
    this.increment, 
    { 
      this.partnerA = true,
      int maxVal = PlayerState.kMaxValue,
    }
  ):  maxVal = maxVal ?? PlayerState.kMaxValue;

  @override
  PlayerState apply(PlayerState state) 
    => state.castAgain(this.increment, 
      partnerA: this.partnerA,
      maxCast: this.maxVal,
    );

  @override
  PlayerAction normalizeOn(PlayerState state) {
    final int alreadyThere = state.cast.fromPartner(this.partnerA);
    final int clamped = this.increment.clamp(
      _minVal - alreadyThere,
      this.maxVal - alreadyThere,
    );

    if(clamped == 0) 
      return PANull.instance;

    return PACast(
      clamped,
      partnerA: this.partnerA,
      maxVal: this.maxVal,
    );
  }
}
