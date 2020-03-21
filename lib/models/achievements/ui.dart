import 'package:counter_spell_new/data/icon/material_community_icons.dart';
import 'package:flutter/material.dart';

enum Medal {
  bronze,
  silver,
  gold,
}

extension Names on Medal{
  static const Map<Medal,String> names = <Medal,String>{
    Medal.bronze: "Bronze",
    Medal.silver: "Silver",
    Medal.gold: "Gold",
  };
  static const Map<String,Medal> reverse = <String,Medal>{
    "Bronze": Medal.bronze,
    "Silver": Medal.silver,
    "Gold": Medal.gold,
  };
  String get name => names[this];
  static Medal fromName(String name) => reverse[name];
}

extension Compare on Medal{
  static const Map<Medal,Set<Medal>> biggers = <Medal,Set<Medal>>{
    null: <Medal>{Medal.bronze,Medal.silver,Medal.gold},
    Medal.bronze: <Medal>{Medal.silver, Medal.gold},
    Medal.silver: <Medal>{Medal.gold},
    Medal.gold: <Medal>{},
  };
  static const Map<Medal,Set<Medal>> smallers = <Medal,Set<Medal>>{
    null: <Medal>{},
    Medal.bronze: <Medal>{null},
    Medal.silver: <Medal>{Medal.bronze, null},
    Medal.gold: <Medal>{Medal.bronze, Medal.silver, null},
  };
  bool biggerThan(Medal other) => smallers[this].contains(other);
  bool smallerThan(Medal other) => biggers[this].contains(other);
}

class _UI {
  static const Color lightGold = Color(0xFFAF9500);
  static const Color oldGold = Color(0xFFC9B037);
  static const Color lightSilver = Color(0xFFD7D7D7);
  static const Color philippineSilver = Color(0xFFB4B4B4);
  static const Color philippineBronze = Color(0xFF6A3805);
  static const Color metallicBronze = Color(0xFFAD8A56);

  static const Map<Medal,Color> onLight = <Medal,Color>{
    Medal.bronze: philippineBronze,
    Medal.silver: philippineSilver,
    Medal.gold: lightGold,
  };
  static const Map<Medal,Color> onDark = <Medal,Color>{
    Medal.bronze: metallicBronze,
    Medal.silver: philippineSilver,
    Medal.gold: oldGold,
  };

  static const Map<Brightness,Map<Medal,Color>> brightnessMap = <Brightness,Map<Medal,Color>>{
    Brightness.dark: onDark,
    Brightness.light: onLight,
  };

}

extension MedalColors on Medal {
  Color colorOnBrightness(Brightness brightness) => _UI.brightnessMap[brightness][this];

  Color colorOnTheme(ThemeData theme) => colorOnBrightness(theme.brightness);
}

class MedalIcon extends StatelessWidget {
  final Medal medal;
  const MedalIcon(this.medal);

  @override
  Widget build(BuildContext context) {
    return Icon(
      McIcons.medal, 
      color: medal.colorOnTheme(Theme.of(context))
    );
  }
}