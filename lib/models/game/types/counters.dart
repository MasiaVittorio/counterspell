import 'package:counter_spell_new/themes/counter_icons.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const int MAX_LIFE = 9999;
const int MIN_LIFE = -999;

class Counter{
  final String shortName;
  final String longName;
  final int minValue;
  final int maxValue;
  final IconData icon;
  
  const Counter({
    @required this.shortName,
    @required this.longName,
    @required this.icon,    
    @required this.minValue,
    @required this.maxValue,
  });

  factory Counter.custom({
    String shortName,
    String longName,
    @required int minValue,
    @required int maxValue,
  }) => Counter(
    shortName: shortName,
    longName: longName,
    minValue: max(MIN_LIFE, minValue),
    maxValue: min(MAX_LIFE, maxValue),
    icon: Icons.palette,
  );

  static Counter fromJson(Map<String,dynamic> json){
    return Counter(
      icon: Icons.palette,
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
  };

}

const Counter POISON = Counter(
  shortName: 'Poison',
  longName: 'Poison Counters',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: CounterIcons.phyrexia,
);
const Counter EXPERIENCE = Counter(
  shortName: 'Experience',
  longName: 'Experience Counters',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: CounterIcons.experience_filled,
);
const Counter STORM = const Counter(
  shortName: 'Storm',
  longName: 'Storm Count',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: MdiIcons.weatherLightning,
);
const Counter BLESSING = Counter(
  shortName: 'Blessing',
  longName: "City's Blessing",
  minValue: 0,
  maxValue: 1,
  icon: MdiIcons.shipWheel,
);
const Counter MONARCH = Counter(
  shortName: 'Monarch',
  longName: 'Take the Crown',
  minValue: 0,
  maxValue: 1,
  icon: MdiIcons.crown,
);
const Counter MANA = Counter(
  shortName: 'Mana',
  longName: 'Total Mana',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: MdiIcons.alphaXCircle,
);
const Counter CUSTOM = Counter(
  shortName: 'Custom',
  longName: 'Custom Counter',
  minValue: MIN_LIFE,
  maxValue: MAX_LIFE,
  icon: MdiIcons.palette,
);
const Counter ENERGY = Counter(
  shortName: 'Energy',
  longName: 'Energy Counters',
  minValue: 0,
  maxValue: MAX_LIFE,
  icon: MdiIcons.flash,
);

const List<Counter> DEFAULT_CUSTOM_COUNTERS = [
  POISON,
  EXPERIENCE,
  STORM,
  MANA,
  BLESSING,
  MONARCH,
  ENERGY,
];

