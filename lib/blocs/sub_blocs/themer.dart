import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/models/game/types/damage_type.dart';
import 'package:counter_spell_new/models/game/types/type_ui.dart';
import 'package:counter_spell_new/structure/damage_types_to_pages.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/themes/preset_themes.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

import '../bloc.dart';

class CSThemer {

  void dispose(){
    theme.dispose();
  }

  //================================
  // Values
  final CSBloc parent;
  final PersistentVar<CSTheme> theme;



  //================================
  // Getters

  CSTheme get currentTheme => theme.value;



  //================================
  // Constructor
  CSThemer(this.parent): 
    theme = PersistentVar(
      key: "bloc_themer_blocvar_themeset",
      initVal: csDefaultThemesLight.values.first,
      toJson: (theme) => theme.toJson(),
      fromJson: (json) => CSTheme.fromJson(json),
    );





  //=================================
  // Helper Functions

  // static Widget _applyThemeAnimated(ThemeData theme, Widget child) 
  //   => DefaultTextStyle.merge(
  //     style: theme.textTheme.body1,
  //     child: ListTileTheme.merge(
  //       iconColor: theme.iconTheme.color,
  //       child: RadioSliderTheme(
  //         data: RadioSliderThemeData(
  //           selectedColor: RightContrast(theme).onCanvas,
  //         ),
  //         child: AnimatedTheme(
  //           duration: MyDurations.fast,
  //           data: theme,
  //           child: child,
  //         ),
  //       ),
  //     ),
  //   );
  // static Widget applyTheme(ThemeData theme, Widget child) 
  //   => DefaultTextStyle(
  //     style: theme.textTheme.body1,
  //     child: RadioSliderTheme(
  //       data: RadioSliderThemeData(
  //         selectedColor: theme.brightness == Brightness.dark 
  //           ? theme.colorScheme.onSurface
  //           : RightContrast(theme).onCanvas,
  //       ),
  //       child: Theme(
  //         data: theme,
  //         child: ListTileTheme.merge(
  //           iconColor: theme.iconTheme.color,
  //           child: child,
  //         ),
  //       ),
  //     ),
  //   );




  //============================
  // Animated Builder Functions
  //============================


  // static Color getScreenColor({
  //   @required CSTheme theme, 
  //   @required CSPage page, 
  //   @required bool casting, 
  //   @required bool open,
  //   @required Map<CSPage,StageBoardPage> pageThemes,
  // }){
  //     if(open){ //panel
  //       return theme.data.primaryColor;
  //     }
  //     // if(page == CSPage.commander && !casting){
  //     //   return theme.commanderAttack;
  //     // }
  //     return pageThemes[page].primaryColor;
  // }

  static Color getHistoryChipColor({
    @required DamageType type,
    @required bool attack,
    @required CSTheme theme,
    @required Map<CSPage,Color> pageColors,
  }){
    if(type == DamageType.commanderDamage){
      return attack ? pageColors[CSPage.commanderDamage] : theme.commanderDefence;
    } else {
      return pageColors[damageToPage[type]];
    }
  }

  static IconData getHistoryChangeIcon({
    @required CSTheme theme,
    @required DamageType type,
    @required bool attack,
    @required Map<String,Counter> counters,
    @required String counterName,
  }){
    if(type == DamageType.commanderDamage){
      return attack ? CSTypesUI.attackIconOne : CSTypesUI.defenceIconFilled;
    } else if (type == DamageType.counters){
      return counters[counterName].icon;
    } else {
      return CSTypesUI.typeIconsFilled[type];
    }
  }




}

// TODO: animated theme  dalla stageboard