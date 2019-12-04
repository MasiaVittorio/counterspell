import 'dart:convert';

import 'package:counter_spell_new/core.dart';


class CSColorScheme{
  final String name;
  final Color primary;
  final Color accent;
  final Map<CSPage,Color> perPage;

  const CSColorScheme(this.name,{
    @required this.primary,
    @required this.accent,
    @required this.perPage,
  }): assert(primary != null),
      assert(accent != null),
      assert(perPage != null);

  CSColorScheme renamed(String newName) => CSColorScheme(
    newName,
    primary: this.primary,
    accent: this.accent,
    perPage: this.perPage,
  );

  Map<String,dynamic> get toJson => {
    "name": name,
    "primary": primary.value,
    "accent": accent.value,
    "perPage": <String,int>{
      for(final entry in perPage.entries) 
        CSPages.nameOf(entry.key) : entry.value.value,
    },
  };

  static CSColorScheme fromJson(dynamic json) => CSColorScheme(
    json["name"],
    primary: Color(json["primary"]),
    accent: Color(json["accent"]),
    perPage: <CSPage,Color>{
      for(final entry in (json["perPage"] as Map).entries) 
        CSPages.fromName(entry.key as String): Color(entry.value as int),
    },
  );

  @override
  int get hashCode => jsonEncode(this.toJson).hashCode;

  @override
  bool operator ==(Object other){
    if(identical(other, this)) return true;
    if(this.runtimeType != other.runtimeType) return false;

    if(other is CSColorScheme){
      return this.name == other.name && this.equivalentTo(other);
    }

    return false;
  }

  bool equivalentTo(CSColorScheme other)
    => other.primary == this.primary
    && other.accent == this.accent
    && (<CSPage>{
      ...other.perPage.keys,
      ...this.perPage.keys,
    }.every((key) => this.perPage[key] == other.perPage[key]));

  static const String _defaultLightName = "Light default";
  static const CSColorScheme defaultLight = CSColorScheme(
    _defaultLightName,
    primary: CSColors.primary,
    accent: CSColors.accent, 
    perPage: CSColors.perPageLight,
  );
  static const String _defaultDarkName = "Dark default";
  static const CSColorScheme defaultDark = CSColorScheme(
    _defaultDarkName,
    primary: CSColors.darkPrimary,
    accent: CSColors.darkAccent, 
    perPage: CSColors.perPageDark,
  );
  static const String _defaultNightBlackName = "Night Black default";
  static const CSColorScheme defaultNightBlack = CSColorScheme(
    _defaultNightBlackName,
    primary: CSColors.nightBlackPrimary,
    accent: CSColors.nightBlackAccent, 
    perPage: CSColors.perPageDark,
  );
  static const String _defaultAmoledName = "Amoled default";
  static const CSColorScheme defaultAmoled = CSColorScheme(
    _defaultAmoledName,
    primary: CSColors.amoledPrimary,
    accent: CSColors.amoledAccent,
    perPage: CSColors.perPageDark,
  );
  static const String _defaultNightBlueName = "Night Blue default";
  static const CSColorScheme defaultNightBlue = CSColorScheme(
    _defaultNightBlueName,
    primary: CSColors.nightBluePrimary,
    accent: CSColors.nightBlueAccent,
    perPage: CSColors.perPageDarkBlue,
  );

  static CSColorScheme defaultScheme(bool light, DarkStyle style) => light
    ? defaultLight
    : darkSchemes[style];

  static const Map<DarkStyle,CSColorScheme> darkSchemes = <DarkStyle,CSColorScheme>{
    DarkStyle.nightBlack: defaultNightBlack,
    DarkStyle.nightBlue: defaultNightBlue,
    DarkStyle.dark: defaultDark,
    DarkStyle.amoled: defaultAmoled,
  };

  static const Map<String, CSColorScheme> defaults = <String,CSColorScheme>{
    _defaultLightName: CSColorScheme.defaultLight,
    _defaultDarkName: CSColorScheme.defaultDark,
    _defaultNightBlackName: CSColorScheme.defaultNightBlack,
    _defaultAmoledName: CSColorScheme.defaultAmoled,
    _defaultNightBlueName: CSColorScheme.defaultNightBlue,
  };
}


class CSColors {
  static const Color dark = const Color(0xFF263133);
  static const Color blue = const Color(0xFF0A4968); //defence
  static const Color delete = const Color(0xFFE45356);

  static const Map<CSPage,Color> perPageLight = const <CSPage,Color>{
    CSPage.history: Color(0xFF424242),
    CSPage.counters: Color(0xFF263133), 
    CSPage.life: Color(0xFF2E7D32), 
    CSPage.commanderCast: Color(0xFF00838F),
    CSPage.commanderDamage: const Color(0xFF983146),
  };
  static const Map<CSPage,Color> perPageDark = const <CSPage,Color>{
    CSPage.history: Color(0xFF303030),
    CSPage.counters: CSColors.dark, 
    CSPage.life: Color(0xFF004D40), 
    CSPage.commanderCast: Color(0xFF006064),
    CSPage.commanderDamage: Color(0xFF792738),
  };
  static const Map<CSPage,Color> perPageDarkBlue = const <CSPage,Color>{
    CSPage.history: Color(0xFF303030),
    CSPage.counters: CSColors.dark, 
    CSPage.life: Color(0xFF222E3C), 
    CSPage.commanderCast: Color(0xFF006064),
    CSPage.commanderDamage: Color(0xFF792738),
  };

  static const Color primary = const Color(0xFF263133);
  static const Color accent = const Color(0xFF00BFA5);

  static const Color nightBluePrimary = const Color(0xFF222E3C);
  static const Color darkPrimary = const Color(0xFF1E1E1E);
  static const Color nightBlackPrimary = const Color(0xFF191919);
  static const Color amoledPrimary = const Color(0xFF151515);

  static const Color nightBlueAccent = const Color(0xFF64FFDA);
  static const Color darkAccent = const Color(0xFFECEFF1);
  static const Color nightBlackAccent = const Color(0xFFCFD8DC);
  static const Color amoledAccent = const Color(0xFFCFD8DC);

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
