import 'package:counter_spell_new/core.dart';

class CSThemer {

  void dispose(){
    defenceColor.dispose();
  }

  //================================
  // Values
  final CSBloc parent;
  final PersistentVar<Color> defenceColor;


  //================================
  // Constructor
  CSThemer(this.parent): 
    defenceColor = PersistentVar<Color>(
      key: "bloc_themer_blocvar_defenceColor",
      initVal: csDefaultDefenceColor,
      toJson: (color) => color.value,
      fromJson: (json) => Color(json),
    );


  static Color getHistoryChipColor({
    @required DamageType type,
    @required bool attack,
    @required Color defenceColor,
    @required Map<CSPage,Color> pageColors,
  }){
    if(type == DamageType.commanderDamage){
      return attack ? pageColors[CSPage.commanderDamage] : defenceColor;
    } else {
      return pageColors[damageToPage[type]];
    }
  }

  static IconData getHistoryChangeIcon({
    @required Color defenceColor,
    @required DamageType type,
    @required bool attack,
    @required Counter counter,
  }){
    if(type == DamageType.commanderDamage){
      return attack ? CSTypesUI.attackIconOne : CSTypesUI.defenceIconFilled;
    } else if (type == DamageType.counters){
      return counter.icon;
    } else {
      return CSTypesUI.typeIconsFilled[type];
    }
  }




}

// TODO: animated theme  dalla stageboard