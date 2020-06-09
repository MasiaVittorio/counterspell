import 'dart:convert';

import 'package:counter_spell_new/core.dart';
import 'dart:math';


const int MAX_LIFE = 9999;
const int MIN_LIFE = -999;

class Counter{
  final String shortName;
  final String longName;
  final int minValue;
  final int maxValue;
  final IconData icon;
  final bool uniquePlayer;
  
  const Counter({
    @required this.shortName,
    @required this.longName,
    @required this.icon,    
    @required this.minValue,
    @required this.maxValue,
    @required this.uniquePlayer,
  });

  factory Counter.custom({
    String shortName,
    String longName,
    @required int minValue,
    @required int maxValue,
    bool uniquePlayer = false,
  }) => Counter(
    uniquePlayer: uniquePlayer,
    shortName: shortName,
    longName: longName,
    minValue: max(MIN_LIFE, minValue),
    maxValue: min(MAX_LIFE, maxValue),
    icon: Icons.palette,
  );

  static Counter fromJson(Map<String,dynamic> json){
    return Counter(
      uniquePlayer: json["uniquePlayer"] ?? false,
      icon: _icons[json["longName"]] ?? Icons.palette,
      longName: json['longName'],
      shortName: json['shortName'],
      minValue: json['minValue'],
      maxValue: json['maxValue'],
    );
  }

  @override
  operator == (Object other){
    if(other is Counter){
      if(other.longName != longName) return false;
      if(other.maxValue != maxValue) return false;
      if(other.shortName != shortName) return false;
      if(other.uniquePlayer != uniquePlayer) return false;
      return true;
    } else return false;
  }

  @override
  int get hashCode => jsonEncode(this.toJson()).hashCode;

  Map<String,dynamic> toJson() => {
    'longName' : this.longName,
    'shortName' : this.shortName,
    'minValue' : this.minValue,
    'maxValue' : this.maxValue,
    'uniquePlayer': this.uniquePlayer,
  };

  static const String poisonLongName = "Poison Counters";
  static const Counter poison = Counter(
    shortName: 'Poison',
    longName: poisonLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    icon: CSIcons.poison,
    uniquePlayer: false,
  );
  static const String experienceLongName = "Experience Counters";
  static const Counter experience = Counter(
    shortName: 'Experience',
    longName: experienceLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    icon: CSIcons.experienceFilled,
    uniquePlayer: false,
  );
  static const String stormLongName = "Storm Count";
  static const Counter storm = const Counter(
    shortName: 'Storm',
    longName: stormLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    icon: ManaIcons.instant,
    // icon: McIcons.weather_lightning,
    uniquePlayer: false,
  );
  static const String blessingLongName = "City's Blessing";
  static const Counter blessing = Counter(
    shortName: 'Blessing',
    longName: blessingLongName,
    minValue: 0,
    maxValue: 1,
    // icon: McIcons.ship_wheel,
    icon: Keyrune.rix,
    uniquePlayer: false,
  );
  static const String monarchLongName = "Take the Crown";
  static const Counter monarch = Counter(
    shortName: 'Monarch',
    longName: monarchLongName,
    minValue: 0,
    maxValue: 1,
    // icon: McIcons.crown,
    icon: Keyrune.cn2,
    uniquePlayer: true,
  );
  static const String manaLongName = "Total Mana";
  static const Counter mana = Counter(
    shortName: 'Mana',
    longName: manaLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    // icon: McIcons.alpha_x_circle,
    icon: ManaIcons.c,
    uniquePlayer: false,
  );
  // static const Counter CUSTOM = Counter(
  //   shortName: 'Custom',
  //   longName: 'Custom Counter',
  //   minValue: MIN_LIFE,
  //   maxValue: MAX_LIFE,
  //   icon: Icons.palette,
  //   uniquePlayer: false,
  // );
  static const String energyLongName = "Energy Counters";
  static const Counter energy = Counter(
    shortName: 'Energy',
    longName: energyLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    // icon: McIcons.flash,
    icon: ManaIcons.e,
    uniquePlayer: false,
  );
  static const Map<String,IconData> _icons = <String,IconData>{
    poisonLongName: CSIcons.poison,
    experienceLongName: CSIcons.experienceFilled,
    // stormLongName: McIcons.weather_lightning,
    // "City's Blessing": McIcons.ship_wheel,
    // 'Take the Crown': McIcons.crown,
    // 'Total Mana': McIcons.alpha_x_circle,
    // 'Energy Counters': McIcons.flash,
    stormLongName: ManaIcons.instant,
    blessingLongName: Keyrune.rix,
    monarchLongName: Keyrune.cn2,
    manaLongName: ManaIcons.c,
    energyLongName: ManaIcons.e,
  };


  static const List<Counter> defaultList = [
    poison,
    experience,
    storm,
    mana,
    blessing,
    monarch,
    energy,
  ];



}

