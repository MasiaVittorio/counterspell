// ignore_for_file: constant_identifier_names

import 'package:counter_spell/core.dart';

const int MAX_LIFE = 9999;
const int MIN_LIFE = -999;

enum Counter {
  poison(
    shortName: 'Poison',
    longName: poisonLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    uniquePlayer: false,
  ),
  extraTurn(
    shortName: 'Turns',
    longName: extraTurnLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    uniquePlayer: false,
  ),
  experience(
    shortName: 'Experience',
    longName: experienceLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    uniquePlayer: false,
  ),
  storm(
    shortName: 'Storm',
    longName: stormLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    uniquePlayer: false,
  ),
  blessing(
    shortName: 'Blessing',
    longName: blessingLongName,
    minValue: 0,
    maxValue: 1,
    uniquePlayer: false,
  ),
  monarch(
    shortName: 'Monarch',
    longName: monarchLongName,
    minValue: 0,
    maxValue: 1,
    uniquePlayer: true,
  ),
  mana(
    shortName: 'Mana',
    longName: manaLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    uniquePlayer: false,
  ),
  energy(
    shortName: 'Energy',
    longName: energyLongName,
    minValue: 0,
    maxValue: MAX_LIFE,
    uniquePlayer: false,
  );

  static const String poisonLongName = "Poison Counters";
  static const String extraTurnLongName = "Extra Turns";
  static const String experienceLongName = "Experience Counters";
  static const String stormLongName = "Storm Count";
  static const String blessingLongName = "City's Blessing";
  static const String monarchLongName = "Take the Crown";
  static const String manaLongName = "Total Mana";
  static const String energyLongName = "Energy Counters";

  final String shortName;
  final String longName;
  final int minValue;
  final int maxValue;
  final bool uniquePlayer;

  const Counter({
    required this.shortName,
    required this.longName,
    required this.minValue,
    required this.maxValue,
    required this.uniquePlayer,
  });
  IconData get icon {
    return switch (this) {
      Counter.poison => CSIcons.poison,
      Counter.extraTurn => Icons.timer_outlined,
      Counter.experience => CSIcons.experienceFilled,
      Counter.storm => ManaIcons.instant,
      Counter.blessing => Keyrune.rix,
      Counter.monarch => Keyrune.cn2,
      Counter.mana => ManaIcons.c,
      Counter.energy => ManaIcons.e,
    };
  }

  // tech debt, this is how they were saved on the users devices long ago so we stick to it
  static Counter fromJson(Map<String, dynamic> json) {
    return Counter.values.firstWhere(
      (element) => element.longName == json['longName'],
    );
  }

  Map<String, dynamic> toJson() => {'longName': longName};

  static const List<Counter> defaultList = [
    poison,
    experience,
    storm,
    mana,
    blessing,
    monarch,
    energy,
    extraTurn,
  ];
}
