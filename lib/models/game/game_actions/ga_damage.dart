
import 'package:counter_spell_new/models/game/model.dart';
import 'package:flutter/widgets.dart';

class GADamage extends GameAction{
  final int increment;
  final int maxVal;
  final int minLife;
  final bool applyToLife;
  final String attacker;
  final String defender;
  final bool partnerA;

  const GADamage(
    this.increment, {
      @required this.defender,
      @required this.attacker,
      @required this.partnerA,
      this.maxVal,
      this.minLife,
      this.applyToLife = true,
    }
  );

  @override
  Map<String, PlayerAction> actions(names) => {
    for(final name in names)
      name: defender == name 
        ? PADamage(
          attacker,
          increment,
          partnerA: this.partnerA,
          applyToLife: this.applyToLife,
          minLife: this.minLife,
          maxVal: this.maxVal,
        )
        : PANull.instance,
  };


}