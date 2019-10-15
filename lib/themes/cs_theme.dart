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
  final Color commanderDefence;
  final Color accent;
  final bool light;
  final DarkStyle darkStyle;

  bool get dark => !this.light;
  
  const CSTheme({
    @required this.commanderDefence,
    @required this.accent,
    @required this.light,
    this.darkStyle = DarkStyle.dark,
  });

  CSTheme copy() => CSTheme(
    commanderDefence: Color(this.commanderDefence.value+0),
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
    commanderDefence: commanderDefence ?? this.commanderDefence,
    accent: accent ?? Color(this.accent.value +0),
    light: light ?? (this.light ? true : false),
    darkStyle: darkStyle ?? this.darkStyle,
  );

  CSTheme.fromJson(Map<String,dynamic> json):
    this.commanderDefence = Color(json["commander_defence"]),
    this.accent = Color(json["accent"]),
    this.light = json["light"],
    this.darkStyle = darkNamesMapReversed[json["dark_style"]];

  Map<String,dynamic> toJson() => {
    "commander_defence": this.commanderDefence.value,
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
  fontWeight: _fontWeight,
  color: _textColorLight,
);
const _bodyTextStyleLight = TextStyle(
  inherit: true,
  fontSize: 14.0,
  fontWeight: _fontWeight,
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
  fontWeight: _fontWeight,
  color: Color(0xCCFFFFFF),
);
const _bodyTextStyleDark = TextStyle(
  inherit: true,
  fontSize: 14.0,
  fontWeight: _fontWeight,
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
  fontWeight: _fontWeight,
);

const _bodyTextStyle = TextStyle(
  inherit: true,
  fontSize: 14.0,
  fontWeight: _fontWeight,
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


const _fontWeight = FontWeight.w600;