import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:flutter/material.dart';

enum InteractionMode {
  life('Life', 'Life'),
  damage('Commander damage', 'Damage'),
  cast('Commander casts', 'Casts'),
  counters('Counters', 'Counters');

  const InteractionMode(this.longName, this.shortName);

  final String longName;
  final String shortName;

  IconData get filledIcon {
    return switch (this) {
      InteractionMode.counters => BodyPage.counters.filledIcon,
      InteractionMode.life => BodyPage.life.filledIcon,
      InteractionMode.damage => CounterSpellIcons.damage_filled,
      InteractionMode.cast => CounterSpellIcons.cast_filled,
    };
  }

  IconData get outlinedIcon {
    return switch (this) {
      InteractionMode.counters => BodyPage.counters.outlinedIcon,
      InteractionMode.life => BodyPage.life.outlinedIcon,
      InteractionMode.damage => CounterSpellIcons.damage_outlined,
      InteractionMode.cast => CounterSpellIcons.cast_outlined,
    };
  }
}
