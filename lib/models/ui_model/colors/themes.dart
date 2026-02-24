// ignore_for_file: avoid_debugPrint

import 'dart:convert';

import 'package:counter_spell/core.dart';

class CSColorScheme {
  final String name;
  final Color primary;
  final Color accent;
  final Map<CSPage, Color> perPage;
  final bool light;
  final DarkStyle darkStyle;
  final Color defenseColor;
  final StageColorPlace colorPlace;

  const CSColorScheme(
    this.name, {
    required this.primary,
    required this.accent,
    required this.perPage,
    required this.light,
    required this.darkStyle,
    required this.defenseColor,
    required this.colorPlace,
  });

  CSColorScheme renamed(String newName) => CSColorScheme(
        newName,
        colorPlace: colorPlace,
        primary: primary,
        accent: accent,
        perPage: perPage,
        light: light,
        darkStyle: darkStyle,
        defenseColor: defenseColor,
      );

  Widget applyBaseTheme({
    required Widget child,
  }) =>
      Theme(
        data: StageThemeUtils.getThemeData(
          accent: accent,
          brightness: light ? Brightness.light : Brightness.dark,
          darkStyle: darkStyle,
          primary: primary,
        ),
        child: child,
      );

  Map<String, dynamic> get toJson => {
        "name": name,
        "primary": primary.toARGB32(),
        "accent": accent.toARGB32(),
        "perPage": <String, int?>{
          for (final entry in perPage.entries)
            CSPages.nameOf(entry.key)!: entry.value.toARGB32(),
        },
        "light": light,
        "darkStyle": darkStyle.name,
        "defenseColor": defenseColor.toARGB32(),
        "colorPlace": colorPlace.name,
      };

  static CSColorScheme fromJson(dynamic json) => CSColorScheme(
        json["name"],
        primary: Color(json["primary"]),
        accent: Color(json["accent"]),
        perPage: <CSPage, Color>{
          for (final entry in (json["perPage"] as Map).entries)
            CSPages.fromName(entry.key as String)!:
                Color((entry.value ?? 0) as int),
        },
        light: json["light"],
        darkStyle: json["darkStyle"] == null
            ? DarkStyle.nightBlue
            : DarkStyle.fromName(json["darkStyle"]),
        defenseColor: Color(json["defenseColor"] ??
            ((StageColorPlaces.fromName(json["colorPlace"]).isTexts)
                ? CSColors.darkBlueGoogle.toARGB32()
                : CSColors.blue.toARGB32())),
        colorPlace: StageColorPlaces.fromName(json["colorPlace"]),
      );

  @override
  int get hashCode => jsonEncode(toJson).hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (runtimeType != other.runtimeType) return false;

    if (other is CSColorScheme) {
      return name == other.name && equivalentTo(other);
    }

    return false;
  }

  bool equivalentTo(CSColorScheme other) {
    return other.primary == primary &&
        other.accent == accent &&
        (<CSPage>{
          ...other.perPage.keys,
          ...perPage.keys,
        }.every((key) => perPage[key] == other.perPage[key])) &&
        other.light == light &&
        other.defenseColor == defenseColor &&
        other.colorPlace == colorPlace &&
        (other.darkStyle == darkStyle || light);
  }

  static const String _defaultLightName = "Light Solid";
  static const CSColorScheme defaultLight = CSColorScheme(
    _defaultLightName,
    primary: CSColors.primary,
    accent: CSColors.accent,
    perPage: CSColors.perPageLight,
    light: true,
    darkStyle: DarkStyle.nightBlue,
    defenseColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleLightName = "Light Flat";
  static const CSColorScheme defaultGoogleLight = CSColorScheme(
    _defaultGoogleLightName,
    primary: CSColors.primary,
    accent: CSColors.accentGoogle,
    perPage: CSColors.perPageLight,
    light: true,
    darkStyle: DarkStyle.nightBlue,
    defenseColor: CSColors.blue,
    colorPlace: StageColorPlace.texts,
  );
  static const String _defaultDarkName = "Dark Solid";
  static const CSColorScheme defaultDark = CSColorScheme(
    _defaultDarkName,
    primary: CSColors.darkPrimary,
    accent: CSColors.darkAccent,
    perPage: CSColors.perPageDark,
    light: false,
    darkStyle: DarkStyle.dark,
    defenseColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleDarkName = "Dark Flat";
  static const CSColorScheme defaultGoogleDark = CSColorScheme(
    _defaultGoogleDarkName,
    primary: CSColors.darkPrimary,
    accent: CSColors.darkAccent,
    perPage: CSColors.perPageDarkGoogle,
    light: false,
    darkStyle: DarkStyle.dark,
    defenseColor: CSColors.darkBlueGoogle,
    colorPlace: StageColorPlace.texts,
  );
  static const String _defaultNightBlackName = "Night Black Solid";
  static const CSColorScheme defaultNightBlack = CSColorScheme(
    _defaultNightBlackName,
    primary: CSColors.nightBlackPrimary,
    accent: CSColors.nightBlackAccent,
    perPage: CSColors.perPageDark,
    light: false,
    darkStyle: DarkStyle.nightBlack,
    defenseColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleNightBlackName = "Night Black Flat";
  static const CSColorScheme defaultGoogleNightBlack = CSColorScheme(
    _defaultGoogleNightBlackName,
    primary: CSColors.nightBlackPrimary,
    accent: CSColors.nightBlackAccent,
    perPage: CSColors.perPageDarkGoogle,
    light: false,
    darkStyle: DarkStyle.nightBlack,
    defenseColor: CSColors.darkBlueGoogle,
    colorPlace: StageColorPlace.texts,
  );
  static const String _defaultAmoledName = "Amoled Solid";
  static const CSColorScheme defaultAmoled = CSColorScheme(
    _defaultAmoledName,
    primary: CSColors.amoledPrimary,
    accent: CSColors.amoledAccent,
    perPage: CSColors.perPageDark,
    light: false,
    darkStyle: DarkStyle.amoled,
    defenseColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleAmoledName = "Amoled Flat";
  static const CSColorScheme defaultGoogleAmoled = CSColorScheme(
    _defaultGoogleAmoledName,
    primary: CSColors.amoledPrimary,
    accent: CSColors.amoledAccent,
    perPage: CSColors.perPageDarkGoogle,
    light: false,
    darkStyle: DarkStyle.amoled,
    defenseColor: CSColors.darkBlueGoogle,
    colorPlace: StageColorPlace.texts,
  );
  static const String _defaultNightBlueName = "Night Blue Solid";
  static const CSColorScheme defaultNightBlue = CSColorScheme(
    _defaultNightBlueName,
    primary: CSColors.nightBluePrimary,
    accent: CSColors.nightBlueAccent,
    perPage: CSColors.perPageDarkBlue,
    light: false,
    darkStyle: DarkStyle.nightBlue,
    defenseColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleNightBlueName = "Night Blue Flat";
  static const CSColorScheme defaultGoogleNightBlue = CSColorScheme(
    _defaultGoogleNightBlueName,
    primary: CSColors.nightBluePrimary,
    accent: CSColors.nightBlueAccent,
    perPage: CSColors.perPageDarkGoogle,
    light: false,
    darkStyle: DarkStyle.nightBlue,
    defenseColor: CSColors.darkBlueGoogle,
    colorPlace: StageColorPlace.texts,
  );

  static CSColorScheme? defaultScheme(
    bool light,
    DarkStyle style,
    StageColorPlace colorPlace,
  ) =>
      light
          ? colorPlace.isTexts
              ? defaultGoogleLight
              : defaultLight
          : colorPlace.isTexts
              ? darkSchemesGoogle[style]
              : darkSchemes[style];

  static const Map<DarkStyle, CSColorScheme> darkSchemes =
      <DarkStyle, CSColorScheme>{
    DarkStyle.nightBlack: defaultNightBlack,
    DarkStyle.nightBlue: defaultNightBlue,
    DarkStyle.dark: defaultDark,
    DarkStyle.amoled: defaultAmoled,
  };

  static const Map<DarkStyle, CSColorScheme> darkSchemesGoogle =
      <DarkStyle, CSColorScheme>{
    DarkStyle.nightBlack: defaultGoogleNightBlack,
    DarkStyle.nightBlue: defaultGoogleNightBlue,
    DarkStyle.dark: defaultGoogleDark,
    DarkStyle.amoled: defaultGoogleAmoled,
  };

  static const Map<String, CSColorScheme> defaults = <String, CSColorScheme>{
    _defaultLightName: CSColorScheme.defaultLight,
    _defaultDarkName: CSColorScheme.defaultDark,
    _defaultNightBlackName: CSColorScheme.defaultNightBlack,
    _defaultAmoledName: CSColorScheme.defaultAmoled,
    _defaultNightBlueName: CSColorScheme.defaultNightBlue,
    _defaultGoogleLightName: CSColorScheme.defaultGoogleLight,
    _defaultGoogleDarkName: CSColorScheme.defaultGoogleDark,
    _defaultGoogleNightBlackName: CSColorScheme.defaultGoogleNightBlack,
    _defaultGoogleAmoledName: CSColorScheme.defaultGoogleAmoled,
    _defaultGoogleNightBlueName: CSColorScheme.defaultGoogleNightBlue,
  };
}
