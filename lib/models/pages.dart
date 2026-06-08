import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:counter_spell/widgets/expanded_panel/game_page/game_page.dart';
import 'package:counter_spell/widgets/expanded_panel/info_page/info_page.dart';
import 'package:counter_spell/widgets/expanded_panel/settings_page/settings_page.dart';
import 'package:counter_spell/widgets/expanded_panel/theme_page/theme_page.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

enum BodyPage {
  history,
  counters,
  life,
  damage,
  cast;

  InteractionMode? toInteractionMode() => switch (this) {
    BodyPage.life => InteractionMode.life,
    BodyPage.counters => InteractionMode.counters,
    BodyPage.damage => InteractionMode.damage,
    BodyPage.cast => InteractionMode.cast,
    BodyPage.history => null,
  };

  String get longLabel => switch (this) {
    BodyPage.history => 'Game history',
    BodyPage.counters => 'Counters',
    BodyPage.life => 'Life counter',
    BodyPage.damage => 'Commander damage',
    BodyPage.cast => 'Commander casts',
  };

  IconData get filledIcon => switch (this) {
    BodyPage.history => MdiIcons.timerSand,
    BodyPage.counters => MdiIcons.cube,
    BodyPage.life => Icons.favorite,
    BodyPage.damage => CounterSpellIcons.damage_filled,
    BodyPage.cast => CounterSpellIcons.cast_filled,
  };
  IconData get outlinedIcon => switch (this) {
    BodyPage.history => MdiIcons.timerSand,
    BodyPage.counters => MdiIcons.cubeOutline,
    BodyPage.life => Icons.favorite_border,
    BodyPage.damage => CounterSpellIcons.damage_outlined,
    BodyPage.cast => CounterSpellIcons.cast_outlined,
  };

  static final List<HorizontalNavigationItem<BodyPage>> navigationItems = [
    HorizontalNavigationItem(
      value: BodyPage.history,
      label: const Text('History'),
      selectedIcon: Icon(BodyPage.history.filledIcon),
      unselectedIcon: Icon(BodyPage.history.outlinedIcon),
    ),
    HorizontalNavigationItem(
      value: BodyPage.counters,
      label: const Text('Counters'),
      selectedIcon: Icon(BodyPage.counters.filledIcon),
      unselectedIcon: Icon(BodyPage.counters.outlinedIcon),
    ),
    HorizontalNavigationItem(
      value: BodyPage.life,
      label: const Text('Life'),
      selectedIcon: Icon(BodyPage.life.filledIcon),
      unselectedIcon: Icon(BodyPage.life.outlinedIcon),
    ),
    HorizontalNavigationItem(
      value: BodyPage.damage,
      label: const Text('Damage'),
      selectedIcon: Icon(BodyPage.damage.filledIcon),
      unselectedIcon: Icon(BodyPage.damage.outlinedIcon),
    ),
    HorizontalNavigationItem(
      value: BodyPage.cast,
      label: const Text('Cast'),
      selectedIcon: Icon(BodyPage.cast.filledIcon),
      unselectedIcon: Icon(BodyPage.cast.outlinedIcon),
    ),
  ];
}

enum PanelPage {
  game,
  settings,
  theme,
  info;

  String get longLabel => switch (this) {
    PanelPage.game => 'Game options',
    PanelPage.settings => 'App settings',
    PanelPage.theme => 'Theme settings',
    PanelPage.info => 'App information',
  };

  static const List<ViewPage<PanelPage>> viewPages = <ViewPage<PanelPage>>[
    ViewPage(child: GamePage(), value: PanelPage.game),
    ViewPage(child: SettingsPage(), value: PanelPage.settings),
    ViewPage(child: ThemePage(), value: PanelPage.theme),
    ViewPage(child: InfoPage(), value: PanelPage.info),
  ];

  static const List<HorizontalNavigationItem<PanelPage>> navigationItems = [
    HorizontalNavigationItem(
      value: PanelPage.game,
      label: Text('Game'),
      selectedIcon: Icon(Icons.menu),
      unselectedIcon: Icon(Icons.menu),
    ),
    HorizontalNavigationItem(
      value: PanelPage.settings,
      label: Text('Settings'),
      selectedIcon: Icon(Icons.settings),
      unselectedIcon: Icon(Icons.settings_outlined),
    ),
    HorizontalNavigationItem(
      value: PanelPage.theme,
      label: Text('Theme'),
      selectedIcon: Icon(Icons.palette),
      unselectedIcon: Icon(Icons.palette_outlined),
    ),
    HorizontalNavigationItem(
      value: PanelPage.info,
      label: Text('Info'),
      selectedIcon: Icon(Icons.info),
      unselectedIcon: Icon(Icons.info_outline),
    ),
  ];
}
