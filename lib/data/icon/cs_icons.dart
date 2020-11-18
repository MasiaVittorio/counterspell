import 'package:counter_spell_new/core.dart';

class CSIcons {

  static const IconData artist = ManaIcons.artist_nib;
  static const IconData attackOne = McIcons.sword;
  static const IconData attackTwo = McIcons.sword_cross;

  static const IconData defenceOutline = McIcons.shield_outline;
  static const IconData defenceFilled = McIcons.shield;

  static const IconData lifeOutlined = Icons.favorite_border;
  static const IconData lifeFilled = Icons.favorite;

  static const IconData counterOutlined = McIcons.cube_outline;
  static const IconData counterFilled = McIcons.cube;

  static const IconData castOutlined = CSIconsRaw.cast_outlined;
  static const IconData castFilled = CSIconsRaw.cast_filled;

  static const IconData damageOutlined = CSIconsRaw.damage_outlined;
  static const IconData damageFilled = CSIconsRaw.damage_filled;

  static const IconData historyFilled = McIcons.timer_sand;
  static const IconData historyOutlined = McIcons.timer_sand_empty;

  // static const IconData arena = CSIconsRaw.counter_spell;

  static const IconData poison = CSIconsRaw.phyrexia;
  static const IconData experienceFilled = CSIconsRaw.experience_filled;

  static const IconData counterSpell = CSIconsRaw.counterspell;
  
  static const IconData leaderboards = McIcons.license;


  // static const double ideal_counterspell_size = 20;
  // static const double ideal_counterspell_bottom_padding_ratio = 0.09549150281;
  // static const double ideal_counterspell_bottom_padding = ideal_counterspell_size * ideal_counterspell_bottom_padding_ratio;
  // static const EdgeInsets ideal_counterspell_padding = EdgeInsets.only(bottom: ideal_counterspell_bottom_padding);

  static const Map<CSPage, IconData> pageIconsOutlined = {
    CSPage.history: historyOutlined,
    CSPage.counters: counterOutlined,
    CSPage.life: lifeOutlined,
    CSPage.commanderDamage: damageOutlined,
    CSPage.commanderCast: castOutlined,
  }; 
  static const Map<CSPage, IconData> pageIconsFilled = {
    CSPage.history: historyFilled,
    CSPage.counters: counterFilled,
    CSPage.life: lifeFilled,
    CSPage.commanderDamage: damageFilled,
    CSPage.commanderCast: castFilled,
  }; 

  static const Map<DamageType, IconData> typeIconsFilled = {
    DamageType.counters: counterFilled,
    DamageType.life: lifeFilled,
    DamageType.commanderDamage: damageFilled,
    DamageType.commanderCast: castFilled,
  }; 
  static const Map<DamageType, IconData> typeIconsOutlined = {
    DamageType.counters: counterOutlined,
    DamageType.life: lifeOutlined,
    DamageType.commanderDamage: damageOutlined,
    DamageType.commanderCast: castOutlined,
  }; 

}