import 'package:counter_spell_new/core.dart';

enum CSPage{
  history,
  counters,
  life,
  commanderDamage,
  commanderCast,
}

class CSPages{
  
  static String? nameOf(CSPage? page) => _pageToStringMap[page!];

  static CSPage? fromName(String? name) => _stringToPageMap[name!];

  static String? longTitleOf(CSPage page) => _pageToLongTitlesMap[page];

  static String? shortTitleOf(CSPage? page) => _pageToShortTitle[page!];

  static const Map<CSPage, String> _pageToStringMap = {
    CSPage.history: "CSPage.history",
    CSPage.counters: "CSPage.counters",
    CSPage.life: "CSPage.life",
    CSPage.commanderDamage: "CSPage.commanderDamage",
    CSPage.commanderCast: "CSPage.commanderCast",
  };
  static const Map<String,CSPage> _stringToPageMap = {
    "CSPage.history": CSPage.history,
    "CSPage.counters": CSPage.counters,
    "CSPage.life": CSPage.life,
    "CSPage.commanderDamage": CSPage.commanderDamage,
    "CSPage.commanderCast": CSPage.commanderCast,
  };

  static const Map<CSPage, String> _pageToLongTitlesMap = {
    CSPage.history: "History Screen",
    CSPage.counters: "Other Counters",
    CSPage.life: "Life Counter",
    CSPage.commanderDamage: "Commander Damage",
    CSPage.commanderCast: "Commander Cast",
  };

  static const Map<CSPage, String> _pageToShortTitle = {
    CSPage.history: "History",
    CSPage.counters: "Counters",
    CSPage.life: "Life",
    CSPage.commanderDamage: "Damage",
    CSPage.commanderCast: "Cast",
  };

  static const Map<DamageType, CSPage> damageToPage = {
    DamageType.counters : CSPage.counters,
    DamageType.life : CSPage.life,
    DamageType.commanderCast : CSPage.commanderCast,
    DamageType.commanderDamage: CSPage.commanderDamage,
  };
  static CSPage? fromDamage(DamageType type) => damageToPage[type];

}

enum SettingsPage{
  game,
  settings,
  info,
  theme,
}

class SettingsPages {
  static String? nameOf(SettingsPage? page) => _names[page!];
  static SettingsPage? fromName(String? name) => _pages[name!];

  static const Map<SettingsPage,String> _names = <SettingsPage,String>{
    SettingsPage.game: "SettingsPage.game",
    SettingsPage.settings: "SettingsPage.settings",
    SettingsPage.info: "SettingsPage.info",
    SettingsPage.theme: "SettingsPage.theme",
  };
  static const Map<String,SettingsPage> _pages = <String,SettingsPage>{
    "SettingsPage.game": SettingsPage.game,
    "SettingsPage.settings": SettingsPage.settings,
    "SettingsPage.info": SettingsPage.info,
    "SettingsPage.theme": SettingsPage.theme,
  };
}
