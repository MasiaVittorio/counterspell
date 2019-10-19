import 'package:counter_spell_new/models/game/model.dart';
import 'package:counter_spell_new/models/game/player_action.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:flutter/material.dart';

class PTileUtils {
  //cn = circle number
  static Color cnColor(
    CSPage page,
    bool attacking,
    bool defending,
    Map<CSPage,Color> pageColors,
    CSTheme theme,
  ){
    if(page == CSPage.commanderDamage){
      if(attacking){
        return pageColors[CSPage.commanderDamage];
      } else if(defending){
        return theme.commanderDefence;
      } else {
        return pageColors[CSPage.commanderDamage]
            .withOpacity(0.5);
      }
    } else {
      return pageColors[page];
    }
  }



  static int cnIncrement(PlayerAction action){
    if(action is PALife){
      return action.increment;         
    } else if(action is PANull){
      return 0;
    } else if(action is PACast){
      return action.increment;
    } else if(action is PADamage){
      return action.increment;
    }
    return 0;
  }

  static double cnNumberOpacity(CSPage page, String whoIsAttacking,){
    if(page == CSPage.commanderDamage && (whoIsAttacking==null || whoIsAttacking==""))
      return 0.0;
    return 1.0;
  }

  static int cnValue(
    String name, 
    CSPage page, 
    String attackingName, 
    String defendingName, 
    bool usingPartnerB,
    PlayerState playerState,
    // Map<String,PlayerState> group,
  ){
    // final playerState = group[name];
    switch (page) {
      case CSPage.life:
        return playerState.life;
        break;
      case CSPage.counters:
        return 0; //LOWPRIORITY: implement counters
        break;
      case CSPage.commanderCast:
        return playerState.cast.fromPartner(!usingPartnerB);
        break;
      case CSPage.commanderDamage:
        if(attackingName!=null && attackingName!=""){
          if(playerState.damages.containsKey(attackingName)){
            return playerState.damages[attackingName]?.fromPartner(!usingPartnerB) ?? 0;
          }
        }
        return 0; //will be opaque anyway
        break;
      case CSPage.history:
        return 0;
        break;
      default:
    }
    return 0;
  }

}
