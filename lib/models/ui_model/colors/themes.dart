import 'dart:convert';
import 'package:counter_spell_new/core.dart';


class CSColorScheme{
  final String? name;
  final Color primary;
  final Color accent;
  final Map<CSPage?,Color?> perPage;
  final bool? light;
  final DarkStyle? darkStyle;
  final Color defenceColor;
  final StageColorPlace colorPlace;

  const CSColorScheme(this.name,{
    required this.primary,
    required this.accent,
    required this.perPage,
    required this.light,
    required this.darkStyle,
    required this.defenceColor,
    required this.colorPlace,
  }): assert(primary != null),
      assert(accent != null),
      assert(defenceColor != null),
      assert(colorPlace != null),
      assert(perPage != null);

  CSColorScheme renamed(String newName) => CSColorScheme(
    newName,
    colorPlace: this.colorPlace,
    primary: this.primary,
    accent: this.accent,
    perPage: this.perPage,
    light: this.light,
    darkStyle: this.darkStyle,
    defenceColor: this.defenceColor,
  );

  Widget applyBaseTheme({required Widget child,}) => Theme(
    data: StageThemeUtils.getThemeData(
      accent: this.accent,
      brightness: this.light! ? Brightness.light : Brightness.dark,
      darkStyle: this.darkStyle,
      forcedPrimaryColorBrightness: null,
      primary: this.primary,
    ),
    child: child,
  );

  Map<String,dynamic> get toJson => {
    "name": this.name,
    "primary": this.primary.value,
    "accent": this.accent.value,
    "perPage": <String?,int>{
      for(final entry in this.perPage.entries) 
        CSPages.nameOf(entry.key) : entry.value!.value,
    },
    "light": this.light,
    "darkStyle": this.darkStyle.name,
    "defenceColor": this.defenceColor.value,
    "colorPlace": this.colorPlace.name,
  };

  static CSColorScheme fromJson(dynamic json) => CSColorScheme(
    json["name"],
    primary: Color(json["primary"]),
    accent: Color(json["accent"]),
    perPage: <CSPage?,Color>{
      for(final entry in (json["perPage"] as Map).entries) 
        CSPages.fromName(entry.key as String): Color(entry.value as int),
    },
    light: json["light"],
    darkStyle: DarkStyles.fromName(json["darkStyle"]),
    defenceColor: Color(json["defenceColor"] ?? CSColors.blue.value),
    colorPlace: StageColorPlaces.fromName(json["colorPlace"]),
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
    && (<CSPage?>{
      ...other.perPage.keys,
      ...this.perPage.keys,
    }.every((key) => this.perPage[key] == other.perPage[key]))
    && other.light == this.light
    && other.defenceColor == this.defenceColor
    && other.colorPlace == this.colorPlace
    && (other.darkStyle == this.darkStyle || this.light!);

  static const String _defaultLightName = "Light default";
  static const CSColorScheme defaultLight = CSColorScheme(
    _defaultLightName,
    primary: CSColors.primary,
    accent: CSColors.accent, 
    perPage: CSColors.perPageLight,
    light: true,
    darkStyle: null,
    defenceColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleLightName = "Light Google";
  static const CSColorScheme defaultGoogleLight = CSColorScheme(
    _defaultGoogleLightName,
    primary: CSColors.primary,
    accent: CSColors.accentGoogle, 
    perPage: CSColors.perPageLight,
    light: true,
    darkStyle: null,
    defenceColor: CSColors.blue,
    colorPlace: StageColorPlace.texts,
  );
  static const String _defaultDarkName = "Dark default";
  static const CSColorScheme defaultDark = CSColorScheme(
    _defaultDarkName,
    primary: CSColors.darkPrimary,
    accent: CSColors.darkAccent, 
    perPage: CSColors.perPageDark,
    light: false,
    darkStyle: DarkStyle.dark,
    defenceColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleDarkName = "Dark google";
  static const CSColorScheme defaultGoogleDark = CSColorScheme(
    _defaultGoogleDarkName,
    primary: CSColors.darkPrimary,
    accent: CSColors.darkAccent, 
    perPage: CSColors.perPageDarkGoogle,
    light: false,
    darkStyle: DarkStyle.dark,
    defenceColor: CSColors.darkBlueGoogle,
    colorPlace: StageColorPlace.texts,
  );
  static const String _defaultNightBlackName = "Night Black default";
  static const CSColorScheme defaultNightBlack = CSColorScheme(
    _defaultNightBlackName,
    primary: CSColors.nightBlackPrimary,
    accent: CSColors.nightBlackAccent, 
    perPage: CSColors.perPageDark,
    light: false,
    darkStyle: DarkStyle.nightBlack,
    defenceColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleNightBlackName = "Night Black google";
  static const CSColorScheme defaultGoogleNightBlack = CSColorScheme(
    _defaultGoogleNightBlackName,
    primary: CSColors.nightBlackPrimary,
    accent: CSColors.nightBlackAccent, 
    perPage: CSColors.perPageDarkGoogle,
    light: false,
    darkStyle: DarkStyle.nightBlack,
    defenceColor: CSColors.darkBlueGoogle,
    colorPlace: StageColorPlace.texts,
  );
  static const String _defaultAmoledName = "Amoled default";
  static const CSColorScheme defaultAmoled = CSColorScheme(
    _defaultAmoledName,
    primary: CSColors.amoledPrimary,
    accent: CSColors.amoledAccent,
    perPage: CSColors.perPageDark,
    light: false,
    darkStyle: DarkStyle.amoled,
    defenceColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleAmoledName = "Amoled google";
  static const CSColorScheme defaultGoogleAmoled = CSColorScheme(
    _defaultGoogleAmoledName,
    primary: CSColors.amoledPrimary,
    accent: CSColors.amoledAccent,
    perPage: CSColors.perPageDarkGoogle,
    light: false,
    darkStyle: DarkStyle.amoled,
    defenceColor: CSColors.darkBlueGoogle,
    colorPlace: StageColorPlace.texts,
  );
  static const String _defaultNightBlueName = "Night Blue default";
  static const CSColorScheme defaultNightBlue = CSColorScheme(
    _defaultNightBlueName,
    primary: CSColors.nightBluePrimary,
    accent: CSColors.nightBlueAccent,
    perPage: CSColors.perPageDarkBlue,
    light: false,
    darkStyle: DarkStyle.nightBlue,
    defenceColor: CSColors.blue,
    colorPlace: StageColorPlace.background,
  );
  static const String _defaultGoogleNightBlueName = "Night Blue google";
  static const CSColorScheme defaultGoogleNightBlue = CSColorScheme(
    _defaultGoogleNightBlueName,
    primary: CSColors.nightBluePrimary,
    accent: CSColors.nightBlueAccent,
    perPage: CSColors.perPageDarkGoogle,
    light: false,
    darkStyle: DarkStyle.nightBlue,
    defenceColor: CSColors.darkBlueGoogle,
    colorPlace: StageColorPlace.texts,
  );

  static CSColorScheme? defaultScheme(
    bool light, 
    DarkStyle style, 
    StageColorPlace colorPlace,
  ) => light
    ? colorPlace.isTexts ? defaultGoogleLight : defaultLight
    : colorPlace.isTexts ? darkSchemesGoogle[style] : darkSchemes[style];

  static const Map<DarkStyle,CSColorScheme> darkSchemes = <DarkStyle,CSColorScheme>{
    DarkStyle.nightBlack: defaultNightBlack,
    DarkStyle.nightBlue: defaultNightBlue,
    DarkStyle.dark: defaultDark,
    DarkStyle.amoled: defaultAmoled,
  };

  static const Map<DarkStyle,CSColorScheme> darkSchemesGoogle = <DarkStyle,CSColorScheme>{
    DarkStyle.nightBlack: defaultGoogleNightBlack,
    DarkStyle.nightBlue: defaultGoogleNightBlue,
    DarkStyle.dark: defaultGoogleDark,
    DarkStyle.amoled: defaultGoogleAmoled,
  };

  static const Map<String, CSColorScheme> defaults = <String,CSColorScheme>{
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
