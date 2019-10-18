import 'package:flutter/material.dart';

const Color DELETE_COLOR = const Color(0xFFE45356);

class CSTheme {
  final Color commanderDefence;
  final Color accent;

  
  const CSTheme({
    @required this.commanderDefence,
    @required this.accent,
  });

  CSTheme copy() => CSTheme(
    commanderDefence: Color(this.commanderDefence.value+0),
    accent: Color(this.accent.value +0),
  );

  CSTheme copyWith({
    Color accent,
    Color commanderDefence,
  }) => CSTheme(
    commanderDefence: commanderDefence ?? this.commanderDefence,
    accent: accent ?? Color(this.accent.value +0),
  );

  CSTheme.fromJson(Map<String,dynamic> json):
    this.commanderDefence = Color(json["commander_defence"]),
    this.accent = Color(json["accent"]);

  Map<String,dynamic> toJson() => {
    "commander_defence": this.commanderDefence.value,
    "accent": this.accent.value,
  };

  //so the primary text theme is always white
  // static const primary = const Color(0xFF263133);

  static Color getContrast(Color color) 
    => isDark(color)
      ? Colors.white 
      : Colors.black;

  static bool isDark(Color color) 
    => ThemeData.estimateBrightnessForColor(color) 
    == Brightness.dark;

  bool isEqualTo(CSTheme other)
    => this.accent == other.accent
    && this.commanderDefence == other.commanderDefence;

}
