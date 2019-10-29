import 'package:counter_spell_new/game_model/types/damage_type.dart';
import 'package:counter_spell_new/structure/pages.dart';

const Map<DamageType, CSPage> damageToPage = {
  DamageType.counters : CSPage.counters,
  DamageType.life : CSPage.life,
  DamageType.commanderCast : CSPage.commanderCast,
  DamageType.commanderDamage: CSPage.commanderDamage,
};
