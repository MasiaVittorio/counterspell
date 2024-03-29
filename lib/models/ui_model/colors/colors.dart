import 'package:counter_spell_new/core.dart';


class CSColors {

  static const Color dark = Color(0xFF263133);
  static const Color blue = Color(0xFF0A4968); //defence
  static const Color darkBlueGoogle = Color(0xFF236A8D); //defence
  static const Color delete = Color(0xFFE45356);
  static const Color gold = Color(0xFFa19c36);

  static const Map<CSPage,Color> perPageLight = <CSPage,Color>{
    CSPage.history: Color(0xFF424242),
    CSPage.counters: Color(0xFF263133), 
    CSPage.life: Color(0xFF2E7D32), 
    CSPage.commanderCast: Color(0xFF00838F),
    CSPage.commanderDamage: Color(0xFF983146),
  };
  static const Map<CSPage,Color> perPageDark = <CSPage,Color>{
    CSPage.history: Color(0xFF303030),
    CSPage.counters: CSColors.dark, 
    CSPage.life: Color(0xFF004D40), 
    CSPage.commanderCast: Color(0xFF006064),
    CSPage.commanderDamage: Color(0xFF792738),
  };
  static const Map<CSPage,Color> perPageDarkGoogle = <CSPage,Color>{
    CSPage.history: Color(0xFF757575),
    CSPage.counters: Color(0xFF607D8B), 
    CSPage.life: Color(0xFF4CAF50), 
    CSPage.commanderCast: Color(0xFF00ACC1),
    CSPage.commanderDamage: Color(0xFF9D384D),
  };
  static const Map<CSPage,Color> perPageDarkBlue = <CSPage,Color>{
    CSPage.history: Color(0xFF303030),
    CSPage.counters: CSColors.dark, 
    CSPage.life: Color(0xFF222E3C), 
    CSPage.commanderCast: Color(0xFF006064),
    CSPage.commanderDamage: Color(0xFF792738),
  };

  static const Color primary = Color(0xFF263133);
  static const Color accent = Color(0xFF00BFA5);
  static const Color accentGoogle = Color(0xFF1976D2);

  static const Color nightBluePrimary = Color(0xFF222E3C);
  static const Color darkPrimary = Color(0xFF1E1E1E);
  static const Color nightBlackPrimary = Color(0xFF191919);
  static const Color amoledPrimary = Color(0xFF151515);

  static const Color nightBlueAccent = Color(0xFF64FFDA);
  static const Color darkAccent = Color(0xFFECEFF1);
  static const Color nightBlackAccent = Color(0xFFCFD8DC);
  static const Color amoledAccent = Color(0xFFCFD8DC);

  // static const Color darkBlue = Color(0xFF263238);//commander
  // static const Color red = Color(0xFF983146);//att
  // static const Color gold2 = Color(0xFFA6935C);//cast
  // static const Color gold = Color(0xFF827717); //Colors.lime[900];
  // static const Color grey = Color(0xFF515353);//history
  // static const Color darkGreen = Color(0xFF1C4F22);//life
  // static const Color green = Color(0xFF388E3C);//life
  // static const Color light = Color(0xFFF7F7F7);
  // static const Color lightGrey = Color(0xFFF8F8F9);

}
