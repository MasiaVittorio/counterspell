import 'package:counter_spell_new/structure/pages.dart';

import 'cs_theme.dart';
import 'package:flutter/material.dart';

const Map<String, CSTheme> csDefaultThemesLight = {
  "Light Default" : const CSTheme(
    pageColors: const {
      CSPage.history: Color(0xFF424242),
      CSPage.counters: Color(0xFF263133), 
      CSPage.life: Color(0xFF2E7D32), 
      CSPage.commander: Color(0xFF00838F),
    },
    commanderAttack: const Color(0xFF983146),
    commanderDefence: MyColors.blue,
    accent: const Color(0xFF64FFDA), 
    light: true,
  ),
};


const Map<String, CSTheme> csDefaultThemesDark = {
  "Night Blue Default" : const CSTheme(
    pageColors: const {
      CSPage.history: Color(0xFF303030),
      CSPage.counters: MyColors.dark, 
      CSPage.life: Color(0xFF004D40), 
      CSPage.commander: Color(0xFF006064),
    },
    commanderAttack: const Color(0xFF792738),
    commanderDefence: MyColors.blue,
    accent: const Color(0xFF64FFDA), 
    light: false,
    darkStyle: DarkStyle.nightBlue,
  ),
  "Night Black Default" : const CSTheme(
    pageColors: const {
      CSPage.history: Color(0xFF303030),
      CSPage.counters: MyColors.dark, 
      CSPage.life: Color(0xFF004D40), 
      CSPage.commander: Color(0xFF006064),
    },
    commanderAttack: const Color(0xFF792738),
    commanderDefence: MyColors.blue,
    accent: const Color(0xFF212121),
    light: false,
    darkStyle: DarkStyle.nightBlack,
  ),
};




class MyColors {
  static const Color dark = Color(0xFF263133);
  static const Color light = Color(0xFFF7F7F7);
  static const Color lightGrey = Color(0xFFF8F8F9);

  static const Color darkBlue = Color(0xFF263238);//commander

  static const Color shadow = Colors.black45;

  static const Color darkGreen = Color(0xFF1C4F22);//life
  static const Color green = Color(0xFF388E3C);//life

  static const Color blue = Color(0xFF0A4968);//def
  static const Color red = Color(0xFF983146);//att

  static const Color gold2 = Color(0xFFA6935C);//cast
  static const Color gold = Color(0xFF827717); //Colors.lime[900];

  static const Color grey = Color(0xFF515353);//history

}
