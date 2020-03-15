import 'package:counter_spell_new/core.dart';

enum Medal {
  bronze,
  silver,
  gold,
}

class AchieveUI{
  static const Color lightGold = Color(0xFFAF9500);
  static const Color oldGold = Color(0xFFC9B037);
  static const Color lightSilver = Color(0xFFD7D7D7);
  static const Color philippineSilver = Color(0xFFB4B4B4);
  static const Color philippineBronze = Color(0xFF6A3805);
  static const Color metallicBronze = Color(0xFFAD8A56);

  static const Map<Medal,Color> _onLight = <Medal,Color>{
    Medal.bronze: philippineBronze,
    Medal.silver: philippineSilver,
    Medal.gold: lightGold,
  };
  static const Map<Medal,Color> _onDark = <Medal,Color>{
    Medal.bronze: metallicBronze,
    Medal.silver: philippineSilver,
    Medal.gold: oldGold,
  };

  static const Map<Brightness,Map<Medal,Color>> _brightnessMap = <Brightness,Map<Medal,Color>>{
    Brightness.dark: _onDark,
    Brightness.light: _onLight,
  };

  static Color colorOnBrightness(Medal medal, Brightness brightness) => _brightnessMap[brightness][medal];

  static Color colorOnTheme(Medal medal, ThemeData theme) => colorOnBrightness(medal, theme.brightness);
}