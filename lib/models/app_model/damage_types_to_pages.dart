import 'package:counter_spell_new/models/game_model/types/damage_type.dart';
import 'pages.dart';

const Map<DamageType, CSPage> damageToPage = {
  DamageType.counters : CSPage.counters,
  DamageType.life : CSPage.life,
  DamageType.commanderCast : CSPage.commanderCast,
  DamageType.commanderDamage: CSPage.commanderDamage,
};
