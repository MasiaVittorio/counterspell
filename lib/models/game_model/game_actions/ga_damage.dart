import '../all.dart';
import 'package:flutter/widgets.dart';

class GADamage extends GameAction{
  final int increment;
  final int maxVal;
  final int minLife;
  final String attacker;
  final String defender;
  final bool usingPartnerB;
  final CommanderSettings settings;

  const GADamage(
    this.increment, {
      @required this.defender,
      @required this.attacker,
      @required this.usingPartnerB,
      this.maxVal,
      this.minLife,
      @required this.settings,
    }
  );

  @override
  Map<String, PlayerAction> actions(names) => {
    for(final name in names)
      if(defender == name)
        name: PADamage(
          attacker,
          increment,
          partnerA: !(usingPartnerB ?? false),
          settings: this.settings,
          minLife: this.minLife,
          maxVal: this.maxVal,
        )
      else if(attacker == name && settings.lifelink)
        name: PALife(increment,
          minVal: this.minLife,
          maxVal: this.maxVal,
        )
      else 
        name: PANull.instance,
  };


}