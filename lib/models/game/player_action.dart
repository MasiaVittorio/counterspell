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

    if(previous.life != next.life)
      detectedAcions.add(PALife(
        next.life - previous.life, 
        minVal: minVal, 
        maxVal: maxVal
      ));
    //LOW PRIORITY: implementa detector per altre azioni

    if(detectedAcions.isEmpty)
      return PANull();

    if(detectedAcions.length == 1)
      return detectedAcions.first;

    return PACombined(detectedAcions);
  }

}
