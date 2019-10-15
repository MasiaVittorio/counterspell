import 'package:counter_spell_new/themes/counter_icons.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum CSPage{
  history,
  counters,
  life,
  commanderDamage,
  commanderCast,
}
const Map<CSPage, String> CSPAGE_TO_STRING = {
  CSPage.history: "CSPage.history",
  CSPage.counters: "CSPage.counters",
  CSPage.life: "CSPage.life",
  CSPage.commanderDamage: "CSPage.commanderDamage",
  CSPage.commanderCast: "CSPage.commanderCast",
};
const Map<String,CSPage> STRING_TO_CSPAGE = {
  "CSPage.history": CSPage.history,
  "CSPage.counters": CSPage.counters,
  "CSPage.life": CSPage.life,
  "CSPage.commanderDamage": CSPage.commanderDamage,
  "CSPage.commanderCast": CSPage.commanderCast,
};

const Map<CSPage, String> CSPAGE_TITLES_LONG = {
  CSPage.history: "History Screen",
  CSPage.counters: "Other Counters",
  CSPage.life: "Life Counter",
  CSPage.commanderDamage: "Commander Damage",
  CSPage.commanderCast: "Commander Cast",
};

const Map<CSPage, String> CSPAGE_TITLES_SHORT = {
  CSPage.history: "History",
  CSPage.counters: "Others",
  CSPage.life: "Life",
  CSPage.commanderDamage: "Damage",
  CSPage.commanderCast: "Cast",
};

const IconData ATTACK_ICON = MdiIcons.sword;
const IconData ATTACK_ICON_ALT = MdiIcons.swordCross;
const IconData DEFENCE_ICON_FILLED = MdiIcons.shield;
const IconData DEFENCE_ICON_OUTLINE = MdiIcons.shieldOutline;

const IconData OTHER_FILLED_ICON_DATA = MdiIcons.cube;
const IconData OTHER_OUTLINE_ICON_DATA = MdiIcons.cubeOutline;

const Map<CSPage,IconData> botIconDataMapFilled = {
  CSPage.commanderDamage:  CounterIcons.commander_damage_filled,
  CSPage.commanderCast: CounterIcons.command_cast_filled,
  CSPage.life:   Icons.favorite,
  CSPage.history:  MdiIcons.timerSandFull,
  CSPage.counters:   OTHER_FILLED_ICON_DATA
};
const Map<CSPage,IconData> botIconDataMapOutlined = {
  CSPage.commanderDamage:  CounterIcons.commander_damage_outlined,
  CSPage.commanderCast: CounterIcons.command_cast_outlined,
  CSPage.life:   Icons.favorite_border,
  CSPage.history:  MdiIcons.timerSandEmpty,
  CSPage.counters:   OTHER_OUTLINE_ICON_DATA,
};
// const Map<CSPage,Icon> botActiveIconMap = {
//   CSPage.counters:   Icon(botIconDataMapFilled[CSPage.counters]),
//   CSPage.commanderDamage:  Icon(botIconDataMapFilled[CSPage.commanderDamage]),
//   CSPage.commanderCast: Icon(botIconDataMapFilled[CSPage.commanderCast]),
//   CSPage.life:   Icon(botIconDataMapFilled[CSPage.life]),
//   CSPage.history:  Icon(botIconDataMapFilled[CSPage.history]),
// };
// final Map<CSPage,Icon> botInactiveIconMap = {
//   CSPage.counters:   Icon(botIconDataMapOutlined[CSPage.counters]),
//   CSPage.commander:  Icon(botIconDataMapOutlined[CSPage.commander]),
//   CSPage.life:   Icon(botIconDataMapOutlined[CSPage.life]),
//   // CSPages.cas:   Icon(botIconDataMapOutlined[CSPages.cas]),
//   CSPage.history:  Icon(botIconDataMapOutlined[CSPage.history]),
// };

// final Map<CSPage,String> botShortNameMap = {
//   CSPage.counters: 'Other',
//   CSPage.commanderDamage: 'Damage',
//   CSPage.life: 'Life',
//   CSPage.history: 'History',
//   // CSPages.cas: 'Cast',
// };
// final Map<CSPage,String> botLongNameMap = {
//   CSPage.counters: 'Other Counters',
//   CSPage.commander: 'Commander Damage',
//   CSPage.life: 'Life Counter',
//   CSPage.history: 'History Screen',
//   // CSPages.cas: 'Commander Casts',
// };

enum SettingsPage{
  game,
  settings,
  info,
  theme,
}
const Map<SettingsPage,String> SETTINGS_PAGE_TO_STRING = <SettingsPage,String>{
  SettingsPage.game: "SettingsPage.game",
  SettingsPage.settings: "SettingsPage.settings",
  SettingsPage.info: "SettingsPage.info",
  SettingsPage.theme: "SettingsPage.theme",
};
const Map<String,SettingsPage> STRING_TO_SETTINGS_PAGE = <String,SettingsPage>{
  "SettingsPage.game": SettingsPage.game,
  "SettingsPage.settings": SettingsPage.settings,
  "SettingsPage.info": SettingsPage.info,
  "SettingsPage.theme": SettingsPage.theme,
};