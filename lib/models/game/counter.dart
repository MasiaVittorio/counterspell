import 'package:counter_spell/data/icon/all.dart';
import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

enum Counter {
  poison(0, null, 'Poison counters', 'Poison', false),
  rad(0, null, 'Rad counters', 'Rad', false),
  monarch(0, 1, 'The Monarch', 'Monarch', true),
  initiative(0, 1, 'The Initiative', 'Initiative', true),
  energy(0, null, 'Energy counters', 'Energy', false),
  stormCount(0, null, 'Storm count', 'Storm', false),
  experience(0, null, 'Experience counters', 'Experience', false),
  citysBlessing(0, 1, "The City's Blessing", 'Blessing', false),
  extraTurns(0, null, 'Extra turns', 'Turns', false);

  const Counter(
    this.minValue,
    this.maxValue,
    this.longName,
    this.shortName,
    this.onePlayerAtATime,
  );

  bool get isBoolean => minValue == 0 && maxValue == 1;

  final int? maxValue;
  final int? minValue;
  final String longName;
  final String shortName;
  final bool onePlayerAtATime;

  IconData get filledIcon {
    switch (this) {
      case Counter.poison:
        return CounterSpellIcons.poison_filled;
      case Counter.monarch:
        return Keyrune.cn2;
      case Counter.initiative:
        return Keyrune.clb;
      case Counter.energy:
        return ManaIcons.energy;
      case Counter.stormCount:
        return Keyrune.tdm;
      case Counter.experience:
        return CounterSpellIcons.experience_filled;
      case Counter.citysBlessing:
        return Keyrune.rix;
      case Counter.extraTurns:
        return Keyrune.tsp;
      case Counter.rad:
        return MdiIcons.radioactive;
    }
  }

  IconData get bigIcon {
    switch (this) {
      case Counter.poison:
        return CounterSpellIcons.poison_filled;
      case Counter.monarch:
        return Keyrune.cn2;
      case Counter.initiative:
        return Keyrune.clb;
      case Counter.energy:
        return ManaIcons.energy;
      case Counter.stormCount:
        return Keyrune.tdm;
      case Counter.experience:
        return Keyrune.c15;
      case Counter.citysBlessing:
        return Keyrune.rix;
      case Counter.extraTurns:
        return Keyrune.tsp;
      case Counter.rad:
        return MdiIcons.radioactive;
    }
  }

  IconData get outlinedIcon {
    switch (this) {
      case Counter.poison:
        return CounterSpellIcons.poison_outlined;
      case Counter.monarch:
        return Keyrune.cn2;
      case Counter.initiative:
        return Keyrune.clb;
      case Counter.energy:
        return ManaIcons.energy;
      case Counter.stormCount:
        return Keyrune.tdm_border;
      case Counter.experience:
        return CounterSpellIcons.experience_outlined;
      case Counter.citysBlessing:
        return Keyrune.rix;
      case Counter.extraTurns:
        return Keyrune.tsp;
      case Counter.rad:
        return MdiIcons.radioactive;
    }
  }
}
