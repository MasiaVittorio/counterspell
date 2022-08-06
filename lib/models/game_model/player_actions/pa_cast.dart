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
      int? maxVal = PlayerState.kMaxValue,
    }
  ):  maxVal = maxVal ?? PlayerState.kMaxValue;

  @override
  PlayerState apply(PlayerState state) 
    => state.castAgain(increment, 
      partnerA: partnerA,
      maxCast: maxVal,
    );

  @override
  PlayerAction normalizeOn(PlayerState state) {
    final int alreadyThere = state.cast.fromPartner(partnerA);
    final int clamped = increment.clamp(
      _minVal - alreadyThere,
      maxVal - alreadyThere,
    );

    if(clamped == 0) {
      return PANull.instance;
    }

    return PACast(
      clamped,
      partnerA: partnerA,
      maxVal: maxVal,
    );
  }
}
