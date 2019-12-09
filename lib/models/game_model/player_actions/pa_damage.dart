import '../all.dart';
import 'package:flutter/widgets.dart';

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
      @required this.settings,
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
      settings: settings,
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
    //TODO: clamp on life and poison also? lol

    if(clamped == 0) 
      return PANull.instance;

    return PADamage(
      this.from,
      clamped,
      settings: this.settings,
      partnerA: this.partnerA,
      maxVal: this.maxVal,
      minLife: this.minLife,
    );
  }
}
