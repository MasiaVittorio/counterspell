import '../model.dart';

class PADamage extends PlayerAction {
  final int increment;
  final int maxVal;
  final int minLife;
  final String from;
  final bool partnerA;
  final bool applyToLife;

  static const int minVal = 0;
  const PADamage(
    this.from,
    this.increment, 
    { 
      this.applyToLife = true,
      this.partnerA = true,
      int maxVal = PlayerState.kMaxValue,
      int minLife = PlayerState.kMinValue,
    }
  ):  maxVal = maxVal ?? PlayerState.kMaxValue,
      minLife = minLife ?? PlayerState.kMinValue;

  @override
  PlayerState apply(PlayerState state) 
    => state.getDamage(from, this.increment, 
      partnerA: partnerA, 
      applyToLife: this.applyToLife,
      maxDamage: this.maxVal,
      minLife: this.minLife,
    );

  @override
  PlayerAction normalizeOn(PlayerState state) {
    final int alreadyThere = state.damages[this.from].fromPartner(this.partnerA);
    final int clamped = this.increment.clamp(
      0 - alreadyThere,
      this.maxVal - alreadyThere,
    );

    if(clamped == 0) 
      return PANull.instance;

    return PADamage(
      this.from,
      clamped,
      applyToLife: this.applyToLife,
      partnerA: this.partnerA,
      maxVal: this.maxVal,
      minLife: this.minLife,
    );
  }
}
