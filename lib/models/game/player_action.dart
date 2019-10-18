import 'package:flutter/widgets.dart';

import 'model.dart';
import 'player_actions/actions.dart';

export 'player_actions/actions.dart';

abstract class PlayerAction{

  //=====================================
  // To be abstracted

  const PlayerAction();
  PlayerState apply(PlayerState state);
  PlayerAction normalizeOn(PlayerState state);


  //=====================================
  // Factory

  factory PlayerAction.fromStates({
    @required PlayerState previous,
    @required PlayerState next,
    int minVal, 
    int maxVal,
  }){
    List<PlayerAction> detectedAcions = [];

    final deltaLife = next.life - previous.life;
    if(deltaLife != 0)
      detectedAcions.add(PALife(
        deltaLife, 
        minVal: minVal, 
        maxVal: maxVal,
      ));

    for(final name in previous.damages.keys){
      final deltaA = next.damages[name].a - previous.damages[name].a;
      if(deltaA != 0)
        detectedAcions.add(PADamage( name, deltaA,
          applyToLife: false,
          partnerA: true,
          maxVal: maxVal,
          minLife: minVal,
        ));
      final deltaB = next.damages[name].b - previous.damages[name].b;
      if(deltaB != 0)
        detectedAcions.add(PADamage(name, deltaB,
          applyToLife: false,
          partnerA: false,
          maxVal: maxVal,
          minLife: minVal,
        ));
    }

    final deltaA = next.cast.a - previous.cast.a;
    if(deltaA != 0)
      detectedAcions.add(PACast(
        deltaA,
        partnerA: true,
        maxVal: maxVal,
      ));
    final deltaB = next.cast.b - previous.cast.b;
    if(deltaB != 0)
      detectedAcions.add(PACast(
        deltaB,
        partnerA: false,
        maxVal: maxVal,
      ));

    //LOW PRIORITY: implementa detector per altre azioni

    if(detectedAcions.isEmpty)
      return PANull();

    if(detectedAcions.length == 1)
      return detectedAcions.first;

    return PACombined(detectedAcions);
  }

}
