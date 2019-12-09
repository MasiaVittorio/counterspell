import 'dart:convert';
import 'package:counter_spell_new/core.dart';


class CSColorScheme{
  final String name;
  final Color primary;
  final Color accent;
  final Map<CSPage,Color> perPage;
  final bool light;
  final DarkStyle darkStyle;

  const CSColorScheme(this.name,{
    @required this.primary,
    @required this.accent,
    @required this.perPage,
    @required this.light,
    @required this.darkStyle,
  }): assert(primary != null),
      assert(accent != null),
      assert(perPage != null);

  CSColorScheme renamed(String newName) => CSColorScheme(
    newName,
    primary: this.primary,
    accent: this.accent,
    perPage: this.perPage,
    light: this.light,
    darkStyle: this.darkStyle,
  );

  Widget applyBaseTheme({@required Widget child}) => Stage.apllyTheme(
    child: child,
    light: this.light,
    darkStyle: this.darkStyle,
    primary: this.primary,
    accent: this.accent,
  );

  Map<String,dynamic> get toJson => {
    "name": this.name,
    "primary": this.primary.value,
    "accent": this.accent.value,
    "perPage": <String,int>{
      for(final entry in this.perPage.entries) 
        CSPages.nameOf(entry.key) : entry.value.value,
    },
    "light": this.light,
    "darkStyle": DarkStyles.nameOf(this.darkStyle),
  };

  static CSColorScheme fromJson(dynamic json) => CSColorScheme(
    json["name"],
    primary: Color(json["primary"]),
    accent: Color(json["accent"]),
    perPage: <CSPage,Color>{
      for(final entry in (json["perPage"] as Map).entries) 
        CSPages.fromName(entry.key as String): Color(entry.value as int),
    },
    light: json["light"],
    darkStyle: DarkStyles.fromName(json["darkStyle"]),
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
    }.every((key) => this.perPage[key] == other.perPage[key]))
    && other.light == this.light
    && (this.light || other.darkStyle == this.darkStyle);

  static const String _defaultLightName = "Light default";
  static const CSColorScheme defaultLight = CSColorScheme(
    _defaultLightName,
    primary: CSColors.primary,
    accent: CSColors.accent, 
    perPage: CSColors.perPageLight,
    light: true,
    darkStyle: null,
  );
  static const String _defaultDarkName = "Dark default";
  static const CSColorScheme defaultDark = CSColorScheme(
    _defaultDarkName,
    primary: CSColors.darkPrimary,
    accent: CSColors.darkAccent, 
    perPage: CSColors.perPageDark,
    light: false,
    darkStyle: DarkStyle.dark,
  );
  static const String _defaultNightBlackName = "Night Black default";
  static const CSColorScheme defaultNightBlack = CSColorScheme(
    _defaultNightBlackName,
    primary: CSColors.nightBlackPrimary,
    accent: CSColors.nightBlackAccent, 
    perPage: CSColors.perPageDark,
    light: false,
    darkStyle: DarkStyle.nightBlack,
  );
  static const String _defaultAmoledName = "Amoled default";
  static const CSColorScheme defaultAmoled = CSColorScheme(
    _defaultAmoledName,
    primary: CSColors.amoledPrimary,
    accent: CSColors.amoledAccent,
    perPage: CSColors.perPageDark,
    light: false,
    darkStyle: DarkStyle.amoled,
  );
  static const String _defaultNightBlueName = "Night Blue default";
  static const CSColorScheme defaultNightBlue = CSColorScheme(
    _defaultNightBlueName,
    primary: CSColors.nightBluePrimary,
    accent: CSColors.nightBlueAccent,
    perPage: CSColors.perPageDarkBlue,
    light: false,
    darkStyle: DarkStyle.nightBlue,
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
