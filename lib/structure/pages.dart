import 'package:counter_spell_new/themes/counter_icons.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum CSPage{
  history,
  counters,
  life,
  commander,
}
const Map<CSPage, String> CSPAGE_TO_STRING = {
  CSPage.history: "CSPage.history",
  CSPage.counters: "CSPage.counters",
  CSPage.life: "CSPage.life",
  CSPage.commander: "CSPage.commander",
};
const Map<String,CSPage> STRING_TO_CSPAGE = {
  "CSPage.history": CSPage.history,
  "CSPage.counters": CSPage.counters,
  "CSPage.life": CSPage.life,
  "CSPage.commander": CSPage.commander,
};

const Map<CSPage, String> CSPAGE_TITLES_LONG = {
  CSPage.history: "History Screen",
  CSPage.counters: "Other Counters",
  CSPage.life: "Life Counter",
  CSPage.commander: "Commander Screen",
};
const Map<CSPage, String> CSPAGE_TITLES_SHORT = {
  CSPage.history: "History",
  CSPage.counters: "Others",
  CSPage.life: "Life",
  CSPage.commander: "Commander",
};

const IconData ATTACK_ICON = MdiIcons.sword;
const IconData ATTACK_ICON_ALT = MdiIcons.swordCross;
const IconData DEFENCE_ICON_FILLED = MdiIcons.shield;
const IconData DEFENCE_ICON_OUTLINE = MdiIcons.shieldOutline;

const IconData OTHER_FILLED_ICON_DATA = MdiIcons.cube;
const IconData OTHER_OUTLINE_ICON_DATA = MdiIcons.cubeOutline;

final Map<CSPage,IconData> botIconDataMapFilled = {
  CSPage.commander:  CounterIcons.commander_damage_filled,
  CSPage.life:   Icons.favorite,
  // CSPages.cas:   CounterIcons.command_cast_filled,
  CSPage.history:  MdiIcons.timerSandFull,
  CSPage.counters:   OTHER_FILLED_ICON_DATA
};
final Map<CSPage,IconData> botIconDataMapOutlined = {
  CSPage.commander:  CounterIcons.commander_damage_outlined,
  CSPage.life:   Icons.favorite_border,
  // CSPages.cas:   CounterIcons.command_cast_outlined,
  CSPage.history:  MdiIcons.timerSandEmpty,
  CSPage.counters:   OTHER_OUTLINE_ICON_DATA,
};
final Map<CSPage,Icon> botActiveIconMap = {
  CSPage.counters:   Icon(botIconDataMapFilled[CSPage.counters]),
  CSPage.commander:  Icon(botIconDataMapFilled[CSPage.commander]),
  CSPage.life:   Icon(botIconDataMapFilled[CSPage.life]),
  // CSPages.cas:   Icon(botIconDataMapFilled[CSPages.cas]),
  CSPage.history:  Icon(botIconDataMapFilled[CSPage.history]),
};
final Map<CSPage,Icon> botInactiveIconMap = {
  CSPage.counters:   Icon(botIconDataMapOutlined[CSPage.counters]),
  CSPage.commander:  Icon(botIconDataMapOutlined[CSPage.commander]),
  CSPage.life:   Icon(botIconDataMapOutlined[CSPage.life]),
  // CSPages.cas:   Icon(botIconDataMapOutlined[CSPages.cas]),
  CSPage.history:  Icon(botIconDataMapOutlined[CSPage.history]),
};

final Map<CSPage,String> botShortNameMap = {
  CSPage.counters: 'Other',
  CSPage.commander: 'Commander',
  CSPage.life: 'Life',
  CSPage.history: 'History',
  // CSPages.cas: 'Cast',
};
final Map<CSPage,String> botLongNameMap = {
  CSPage.counters: 'Other Counters',
  CSPage.commander: 'Commander Damage',
  CSPage.life: 'Life Counter',
  CSPage.history: 'History Screen',
  // CSPages.cas: 'Commander Casts',
};
