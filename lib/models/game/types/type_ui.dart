import 'package:counter_spell_new/models/game/types/damage_type.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/counter_icons.dart';
import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:flutter/material.dart';

class CSTypesUI {
  static const IconData attackIconOne = McIcons.sword;
  static const IconData attackIconTwo = McIcons.sword_cross;

  static const IconData defenceIconOutline = McIcons.shield_outline;
  static const IconData defenceIconFilled = McIcons.shield;

  static const Map<DamageType, IconData> typeIconsFilled = {
    DamageType.counters: counterIconFilled,
    DamageType.life: lifeIconFilled,
    DamageType.commanderDamage: commanderIconFilled,
    DamageType.commanderCast: castIconFilled,
  }; 
  static const Map<DamageType, IconData> typeIconsOutlined = {
    DamageType.counters: counterIconOutlined,
    DamageType.life: lifeIconOutlined,
    DamageType.commanderDamage: commanderIconOutlined,
    DamageType.commanderCast: castIconOutlined,
  }; 

  static const IconData lifeIconOutlined = Icons.favorite_border;
  static const IconData lifeIconFilled = Icons.favorite;

  static const IconData counterIconOutlined = McIcons.cube_outline;
  static const IconData counterIconFilled = McIcons.cube;

  static const IconData castIconOutlined = CounterIcons.command_cast_outlined;
  static const IconData castIconFilled = CounterIcons.command_cast_filled;

  static const IconData commanderIconOutlined = CounterIcons.commander_damage_outlined;
  static const IconData commanderIconFilled = CounterIcons.commander_damage_filled;

  static const Map<CSPage, IconData> pageIconsOutlined = {
    CSPage.history: historyIconOutlined,

    CSPage.counters: counterIconOutlined,
    CSPage.life: lifeIconOutlined,
    CSPage.commander: commanderIconOutlined,
  }; 
  static const Map<CSPage, IconData> pageIconsFilled = {
    CSPage.history: historyIconFilled,

    CSPage.counters: counterIconFilled,
    CSPage.life: lifeIconFilled,
    CSPage.commander: commanderIconFilled,
  }; 

  static const IconData historyIconFilled = McIcons.timer_sand;
  static const IconData historyIconOutlined = McIcons.timer_sand_empty;


}