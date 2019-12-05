import 'package:counter_spell_new/models/ui_model/all.dart';
import 'package:flutter/material.dart';
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

  Map<String,dynamic> toJson() => {
    'longName' : this.longName,
    'shortName' : this.shortName,
    'minValue' : this.minValue,
    'maxValue' : this.maxValue,
    'uniquePlayer': this.uniquePlayer,
  };

}

const Counter POISON = Counter(
  shortName: 'Poison',
  longName: 'Poison Counters',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: CounterIcons.phyrexia,
  uniquePlayer: false,
);
const Counter EXPERIENCE = Counter(
  shortName: 'Experience',
  longName: 'Experience Counters',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: CounterIcons.experience_filled,
  uniquePlayer: false,
);
const Counter STORM = const Counter(
  shortName: 'Storm',
  longName: 'Storm Count',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: McIcons.weather_lightning,
  uniquePlayer: false,
);
const Counter BLESSING = Counter(
  shortName: 'Blessing',
  longName: "City's Blessing",
  minValue: 0,
  maxValue: 1,
  icon: McIcons.ship_wheel,
  uniquePlayer: false,
);
const Counter MONARCH = Counter(
  shortName: 'Monarch',
  longName: 'Take the Crown',
  minValue: 0,
  maxValue: 1,
  icon: McIcons.crown,
  uniquePlayer: true,
);
const Counter MANA = Counter(
  shortName: 'Mana',
  longName: 'Total Mana',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: McIcons.alpha_x_circle,
  uniquePlayer: false,
);
const Counter CUSTOM = Counter(
  shortName: 'Custom',
  longName: 'Custom Counter',
  minValue: MIN_LIFE,
  maxValue: MAX_LIFE,
  icon: Icons.palette,
  uniquePlayer: false,
);
const Counter ENERGY = Counter(
  shortName: 'Energy',
  longName: 'Energy Counters',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: McIcons.flash,
  uniquePlayer: false,
);
const Map<String,IconData> _icons = <String,IconData>{
  'Poison Counters': CounterIcons.phyrexia,
  'Experience Counters': CounterIcons.experience_filled,
  'Storm Count': McIcons.weather_lightning,
  "City's Blessing": McIcons.ship_wheel,
  'Take the Crown': McIcons.crown,
  'Total Mana': McIcons.alpha_x_circle,
  // 'Custom Counter': Icons.palette,
  'Energy Counters': McIcons.flash,
};


const List<Counter> DEFAULT_CUSTOM_COUNTERS = [
  POISON,
  EXPERIENCE,
  STORM,
  MANA,
  BLESSING,
  MONARCH,
  ENERGY,
];

