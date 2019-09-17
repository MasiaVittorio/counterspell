import 'package:counter_spell_new/structure/pages.dart';
import 'package:flutter/material.dart';

const Color DELETE_COLOR = const Color(0xFFE45356);

enum DarkStyle {
  dark,
  nightBlack,
  amoled,
  nightBlue,
}
const String _kDark = "Dark";
const String _kNightBlack = "Night Black";
const String _kAmoled = "Amoled";
const String _kNightBlue = "Night Blue";

class CSTheme {
  final Map<CSPage, Color> pageColors;
  //CSPage.commander => cast!
  final Color commanderAttack;
  final Color commanderDefence;
  final Color accent;
  final bool light;
  final DarkStyle darkStyle;

  bool get dark => !this.light;
  
  const CSTheme({
    @required this.pageColors,
    @required this.commanderAttack,
    @required this.commanderDefence,
    @required this.accent,
    @required this.light,
    this.darkStyle = DarkStyle.dark,
  });

  CSTheme copy() => CSTheme(
    pageColors: {
      for(final entry in pageColors.entries)
        entry.key: entry.value,
    },
    commanderAttack: Color(this.commanderAttack.value+0),
    commanderDefence: Color(this.commanderAttack.value+0),
    accent: Color(this.accent.value +0),
    light: this.light ? true : false,
    darkStyle: this.darkStyle,
  );

  CSTheme copyWith({
    Map<CSPage, Color> pageColors,
    Color accent,
    bool light,
    DarkStyle darkStyle,
    Color commanderAttack,
    Color commanderDefence,
  }) => CSTheme(
    commanderAttack: commanderAttack ?? this.commanderAttack,
    commanderDefence: commanderDefence ?? this.commanderDefence,
    pageColors: pageColors ?? {
      for(final entry in this.pageColors.entries)
        entry.key: entry.value,
    },
    accent: accent ?? Color(this.accent.value +0),
    light: light ?? (this.light ? true : false),
    darkStyle: darkStyle ?? this.darkStyle,
  );

  CSTheme.fromJson(Map<String,dynamic> json):
    this.commanderAttack = Color(json["commander_attack"]),
    this.commanderDefence = Color(json["commander_defence"]),
    this.pageColors = {
      for(final entry in json["page_colors"].entries)
        STRING_TO_CSPAGE[entry.key] : Color(entry.value),
    },
    this.accent = Color(json["accent"]),
    this.light = json["light"],
    this.darkStyle = darkNamesMapReversed[json["dark_style"]];

  Map<String,dynamic> toJson() => {
    "commander_attack": this.commanderAttack.value,
    "commander_defence": this.commanderDefence.value,
    "page_colors": {
      for(final entry in this.pageColors.entries)
        CSPAGE_TO_STRING[entry.key] : entry.value.value,
    },
    "accent": this.accent.value,
    "light": this.light,
    "dark_style": darkNamesMap[this.darkStyle],
  };

  //so the primary text theme is always white
  static const primary = const Color(0xFF263133);
  ThemeData get data => ThemeData(
    splashFactory: InkRipple.splashFactory,
    highlightColor: Colors.transparent,

    brightness: light ? Brightness.light : Brightness.dark,

    canvasColor: this.canvasColor,
    scaffoldBackgroundColor: this.scaffoldBackgroundColor,

    primaryColor: primary,

    accentColor: accent,

    textTheme: light ? _textThemeLight : _textThemeDark,
    primaryTextTheme: _textTheme,
    accentTextTheme: _textTheme,
    iconTheme: IconThemeData(opacity: 0.75, color: light ? Colors.black : Colors.white),
    accentIconTheme: IconThemeData(opacity: 1.0, color: getContrast(accent)),
    primaryIconTheme: IconThemeData(opacity: 1.0, color: getContrast(primary)),
  );

  static Color getContrast(Color color) 
    => isDark(color)
      ? Colors.white 
      : Colors.black;

  static bool isDark(Color color) 
    => ThemeData.estimateBrightnessForColor(color) 
    == Brightness.dark;

  bool isEqualTo(CSTheme other)
    => this.accent == other.accent
    && this.light == other.light
    && this.darkStyle == other.darkStyle;

  Color get canvasColor => light 
    ? Colors.grey.shade50
    : _darkCanvasColors[this.darkStyle];

  Color get scaffoldBackgroundColor => light 
    ? Colors.grey.shade200 
    : _darkBackgroundColors[this.darkStyle];
}


const Map<DarkStyle, String> darkNamesMap = <DarkStyle, String>{
  DarkStyle.dark : _kDark,
  DarkStyle.nightBlack : _kNightBlack,
  DarkStyle.amoled : _kAmoled,
  DarkStyle.nightBlue : _kNightBlue,
};
const Map<String, DarkStyle> darkNamesMapReversed = <String, DarkStyle>{
  _kDark: DarkStyle.dark,
  _kNightBlack: DarkStyle.nightBlack ,
  _kAmoled: DarkStyle.amoled,
  _kNightBlue: DarkStyle.nightBlue,
};

DarkStyle nextDarkStyle(DarkStyle style) => <DarkStyle, DarkStyle>{
  DarkStyle.dark : DarkStyle.nightBlack,
  DarkStyle.nightBlack : DarkStyle.amoled,
  DarkStyle.amoled : DarkStyle.nightBlue,
  DarkStyle.nightBlue : DarkStyle.dark,
}[style];

const Map<DarkStyle, Color> _darkCanvasColors = <DarkStyle, Color>{
  DarkStyle.dark : Color(0xFF303030),
  DarkStyle.nightBlack : Color(0xFF141414),
  DarkStyle.amoled : Color(0xFF000000),
  DarkStyle.nightBlue : Color(0xFF1C2733),
};

const Map<DarkStyle, Color> _darkBackgroundColors = <DarkStyle, Color>{
  DarkStyle.dark : Color(0xFF212121),
  DarkStyle.nightBlack : Color(0xFF000000),
  DarkStyle.amoled : Color(0xFF000000),
  DarkStyle.nightBlue : Color(0xFF151D26),
};

const Color _textColorLight = Color(0xA5000000);

const _textStyleLight = TextStyle(
  inherit: true,
  fontWeight: FontWeight.w700,
  color: _textColorLight,
);
const _bodyTextStyleLight = TextStyle(
  inherit: true,
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
  color: _textColorLight,
);

const _textThemeLight = TextTheme(
  body1: _bodyTextStyleLight,
  body2: _textStyleLight,
  title: _textStyleLight,
  display1: _textStyleLight,
  display2: _textStyleLight,
  display3: _textStyleLight,
  display4: _textStyleLight,
  headline: _textStyleLight,
  subhead: _textStyleLight,
  caption: _textStyleLight,
  button: _textStyleLight,
  subtitle: _textStyleLight,
  overline: _textStyleLight,
);

const _textStyleDark = TextStyle(
  inherit: true,
  fontWeight: FontWeight.w700,
  color: Color(0xCCFFFFFF),
);
const _bodyTextStyleDark = TextStyle(
  inherit: true,
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
  color: Color(0xCCFFFFFF),
);

const _textThemeDark = TextTheme(
  body1: _bodyTextStyleDark,
  body2: _textStyleDark,
  title: _textStyleDark,
  display1: _textStyleDark,
  display2: _textStyleDark,
  display3: _textStyleDark,
  display4: _textStyleDark,
  headline: _textStyleDark,
  subhead: _textStyleDark,
  caption: _textStyleDark,
  button: _textStyleDark,
  subtitle: _textStyleDark,
  overline: _textStyleDark,
);

const _textStyle = TextStyle(
  inherit: true,
  fontWeight: FontWeight.w700,
);

const _bodyTextStyle = TextStyle(
  inherit: true,
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
);

const _textTheme = TextTheme(
  body1: _bodyTextStyle,
  body2: _textStyle,
  title: _textStyle,
  display1: _textStyle,
  display2: _textStyle,
  display3: _textStyle,
  display4: _textStyle,
  headline: _textStyle,
  subhead: _textStyle,
  caption: _textStyle,
  button: _textStyle,
  subtitle: _textStyle,
  overline: _textStyle,
);
