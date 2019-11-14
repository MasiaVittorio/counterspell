import 'package:counter_spell_new/core.dart';

enum DamageType {
  counters,
  life,
  commanderDamage,
  commanderCast,
}

const allTypesEnabled = {
  DamageType.counters: true,
  DamageType.life: true,
  DamageType.commanderDamage: true,
  DamageType.commanderCast: true,
};

class DamageTypes{
  static Map<DamageType, bool> fromPages(Map<CSPage,bool> pages) => {
    DamageType.commanderCast: pages[CSPage.commanderCast],
    DamageType.life: true,
    DamageType.commanderDamage: pages[CSPage.commanderDamage],
    DamageType.counters: pages[CSPage.counters],
  };
}