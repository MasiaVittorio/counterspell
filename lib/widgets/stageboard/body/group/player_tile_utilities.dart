import 'package:counter_spell_new/core.dart';

class PTileUtils {
  //cn = circle number
  static Color cnColor(
    CSPage page,
    bool attacking,
    bool defending,
    Color pageColor,
    Color defenceColor,
    bool someoneAttacking,
  ){
    if(page == CSPage.commanderDamage){
      if(attacking){
        return pageColor;
      } else if(defending){
        return defenceColor;
      } else {
        if(someoneAttacking){
          return defenceColor.withOpacity(0.8);
        } else {
          return pageColor
              .withOpacity(0.5);
        }
      }
    } else {
      return pageColor;
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
    } else if(action is PACounter){
      return action.increment;
    } else if(action is PACombined){
      //this should occur when we have a commander damage with lifelink
      //from the attacker to himself
      final PADamage damage = action.actions.firstWhere((pa)=> pa is PADamage, orElse: ()=>null);
      if(damage != null){
        return damage.increment;
      }
      //if we ever make other strange automatically combined actions, we will need to add other logic to detect them here
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
    bool attackerUsingPartnerB,
    Counter counter,
  ){
    switch (page) {
      case CSPage.life:
        return playerState.life;
        break;
      case CSPage.counters:
        return playerState.counters[counter.longName] ?? 0;
        break;
      case CSPage.commanderCast:
        return playerState.cast.fromPartner(!usingPartnerB);
        break;
      case CSPage.commanderDamage:
        if(attackingName!=null && attackingName!=""){
          if(playerState.damages.containsKey(attackingName)){
            return playerState.damages[attackingName]?.fromPartner(!attackerUsingPartnerB) ?? 0;
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

  static String tileAnnotation(
    String name,
    CSPage page,
    bool rawSelected,
    String attacker,
    bool havingPartnerB,
    bool usingPartnerB,
    bool attackerHavingPartnerB,
    bool attackerUsingPartnerB,
  ){
    switch (page) {
      case CSPage.counters:
      case CSPage.life:
        if(rawSelected == null){
          return "Anti - Selected";
        }
        return "";
        break;
      case CSPage.commanderDamage:
        if(attacker==name){
          if(havingPartnerB){
            if(usingPartnerB){
              return "Attacking with Partner B";
            } else {
              return "Attacking with Partner A";
            }
          } else {
            return "Attacking";
          }
        } else if (attacker != ""){
          final string = "Dmg taken from $attacker";
          if(attackerHavingPartnerB){
            if(attackerUsingPartnerB){
              return string + " (B)";
            } else {
              return string + " (A)";
            }
          } else {
            return string;
          }
        }
        break;
      case CSPage.commanderCast:
        if(havingPartnerB){
          if(usingPartnerB){
            return "Second Partner (B)";
          } else {
            return "First Partner (A)";
          }
        } else {
          return "Single Commander";
        }
        break;
      default:
    }
    return "";
  }
  static String subString(String string, int len){
    final slen = string.length;
    if(slen > len){
      return string.substring(0,(len-1).clamp(0,double.infinity))+".";
    }
    return string;
}
}

