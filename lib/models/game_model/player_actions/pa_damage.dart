import '../all.dart';

class PADamage extends PlayerAction {
  final int increment;
  final int maxVal;
  final int minLife;
  final String from;
  final bool partnerA;
  final CommanderSettings settings;

  static const int minVal = 0;
  const PADamage(
    this.from,
    this.increment, 
    { 
      required this.settings,
      this.partnerA = true,
      int? maxVal = PlayerState.kMaxValue,
      int? minLife = PlayerState.kMinValue,
    }
  ):  maxVal = maxVal ?? PlayerState.kMaxValue,
      minLife = minLife ?? PlayerState.kMinValue;

  @override
  PlayerState apply(PlayerState state) 
    => state.getDamage(from, increment, 
      partnerA: partnerA, 
      settings: settings,
      maxDamage: maxVal,
      minLife: minLife,
    );

  @override
  PlayerAction normalizeOn(PlayerState state) {
    final int alreadyThere = state.damages[from]!.fromPartner(partnerA);
    final int clamped = increment.clamp(
      0 - alreadyThere,
      maxVal - alreadyThere,
    );

    if(clamped == 0) {
      return PANull.instance;
    }

    return PADamage(
      from,
      clamped,
      settings: settings,
      partnerA: partnerA,
      maxVal: maxVal,
      minLife: minLife,
    );
  }
}
