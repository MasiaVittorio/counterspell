import 'package:counter_spell_new/core.dart';

class CSIcons {
  static const IconData attackIconOne = McIcons.sword;
  static const IconData attackIconTwo = McIcons.sword_cross;

  static const IconData defenceIconOutline = McIcons.shield_outline;
  static const IconData defenceIconFilled = McIcons.shield;

  static const IconData lifeIconOutlined = Icons.favorite_border;
  static const IconData lifeIconFilled = Icons.favorite;

  static const IconData counterIconOutlined = McIcons.cube_outline;
  static const IconData counterIconFilled = McIcons.cube;

  static const IconData castIconOutlined = CSIconsRaw.command_cast_outlined;
  static const IconData castIconFilled = CSIconsRaw.command_cast_filled;

  static const IconData damageIconOutlined = CSIconsRaw.commander_damage_outlined;
  static const IconData damageIconFilled = CSIconsRaw.commander_damage_filled;

  static const IconData historyIconFilled = McIcons.timer_sand;
  static const IconData historyIconOutlined = McIcons.timer_sand_empty;
  static const IconData simpleViewIcon = CSIconsRaw.counter_spell;

  static const IconData poison = CSIconsRaw.phyrexia;
  static const IconData experienceFilled = CSIconsRaw.experience_filled;

  static const IconData counterSpell = CSIconsRaw.counter_spell;
  
  static const IconData leaderboards = McIcons.license;


  static const double ideal_counterspell_size = 20;
  static const double ideal_counterspell_bottom_padding_ratio = 0.09549150281;
  static const double ideal_counterspell_bottom_padding = ideal_counterspell_size * ideal_counterspell_bottom_padding_ratio;
  static const EdgeInsets ideal_counterspell_padding = EdgeInsets.only(bottom: ideal_counterspell_bottom_padding);

  static const Map<CSPage, IconData> pageIconsOutlined = {
    CSPage.history: historyIconOutlined,
    CSPage.counters: counterIconOutlined,
    CSPage.life: lifeIconOutlined,
    CSPage.commanderDamage: damageIconOutlined,
    CSPage.commanderCast: castIconOutlined,
  }; 
  static const Map<CSPage, IconData> pageIconsFilled = {
    CSPage.history: historyIconFilled,
    CSPage.counters: counterIconFilled,
    CSPage.life: lifeIconFilled,
    CSPage.commanderDamage: damageIconFilled,
    CSPage.commanderCast: castIconFilled,
  }; 

  static const Map<DamageType, IconData> typeIconsFilled = {
    DamageType.counters: counterIconFilled,
    DamageType.life: lifeIconFilled,
    DamageType.commanderDamage: damageIconFilled,
    DamageType.commanderCast: castIconFilled,
  }; 
  static const Map<DamageType, IconData> typeIconsOutlined = {
    DamageType.counters: counterIconOutlined,
    DamageType.life: lifeIconOutlined,
    DamageType.commanderDamage: damageIconOutlined,
    DamageType.commanderCast: castIconOutlined,
  }; 

}