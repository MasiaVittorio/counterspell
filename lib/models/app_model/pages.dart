enum CSPage{
  history,
  counters,
  life,
  commanderDamage,
  commanderCast,
}

class CSPages{
  static String nameOf(CSPage page) => _pageToStringMap[page];

  static CSPage fromName(String name) => _stringToPageMap[name];

  static String longTitleOf(CSPage page) => _pageToLongTitlesMap[page];

  static String shortTitleOf(CSPage page) => _pageToShortTitle[page];

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


}

enum SettingsPage{
  game,
  settings,
  info,
  theme,
}

class SettingsPages {
  static String nameOf(SettingsPage page) => _SETTINGS_PAGE_TO_STRING[page];
  static SettingsPage fromName(String name) => _STRING_TO_SETTINGS_PAGE[name];

  static const Map<SettingsPage,String> _SETTINGS_PAGE_TO_STRING = <SettingsPage,String>{
    SettingsPage.game: "SettingsPage.game",
    SettingsPage.settings: "SettingsPage.settings",
    SettingsPage.info: "SettingsPage.info",
    SettingsPage.theme: "SettingsPage.theme",
  };
  static const Map<String,SettingsPage> _STRING_TO_SETTINGS_PAGE = <String,SettingsPage>{
    "SettingsPage.game": SettingsPage.game,
    "SettingsPage.settings": SettingsPage.settings,
    "SettingsPage.info": SettingsPage.info,
    "SettingsPage.theme": SettingsPage.theme,
  };
}
