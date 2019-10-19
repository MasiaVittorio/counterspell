import 'package:counter_spell_new/models/game/types/type_ui.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:counter_spell_new/themes/preset_themes.dart';
import 'package:flutter/material.dart';
import 'package:stage_board/stage_board.dart';

import '../bloc.dart';

final _primary = const Color(0xFF263133);
final _darkPrimaries = <DarkStyle,Color>{
  for(final style in DarkStyle.values)
    style: _primary,
};

class CSStageBoard {

  void dispose(){
    controller.dispose();
  }

  final StageBoardData<CSPage,SettingsPage> controller;
  final CSBloc parent;
  CSStageBoard(this.parent): controller = StageBoardData<CSPage,SettingsPage>(
    // sizes
    barSize: StageBoard.kBarSize,
    collapsedPanelSize: StageBoard.kBarSize,
    panelRadiusClosed: StageBoard.kBarSize/2,
    panelRadiusOpened: StageBoard.kPanelRadius,
    panelHorizontalPaddingClosed: StageBoard.kPanelHorizontalPaddingClosed,
    panelHorizontalPaddingOpened: StageBoard.kPanelHorizontalPaddingOpened,

    // closed pages
    initialClosedPage: CSPage.life,
    initialClosedPagesData: <CSPage,StageBoardPage>{
      for(final page in CSPage.values)
        page: StageBoardPage(
          // primaryColor: defaultPageColorsLight[page],
          name: CSPAGE_TITLES_SHORT[page],
          longName: CSPAGE_TITLES_LONG[page],
          unselectedIcon: CSTypesUI.pageIconsOutlined[page],
          icon: CSTypesUI.pageIconsFilled[page],
        ),
    },
    decodePageClosed: (json) => STRING_TO_CSPAGE[json as String],
    encodePageClosed: (page) => CSPAGE_TO_STRING[page],
    initialClosedPagesList: CSPage.values,
    onClosedPageChanged: (_) => parent.scroller.cancel(true),

    // opened pages
    initialOpenedPage: SettingsPage.game,
    decodePageOpened: (json) => STRING_TO_SETTINGS_PAGE[json as String],
    encodePageOpened: (page) => SETTINGS_PAGE_TO_STRING[page],
    initialOpenedPagesData: settingsThemes,
    initialOpenedPagesList: [
      SettingsPage.game,
      SettingsPage.settings,
      SettingsPage.theme,
      SettingsPage.info,
    ],
    lastOpenedPage: SettingsPage.game,

    //themes
    light: true,
    darkStyle: DarkStyle.nightBlack,
    lightPrimary: _primary,
    darkPrimaries: _darkPrimaries,
    lightPrimaryPerPage: defaultPageColorsLight,
    darkPrimariesPerPage: {
      for(final style in DarkStyle.values)
        style: defaultPageColorsDark,
    },

    //back behavior
    lastClosedPage: CSPage.life,
  );
}

const settingsThemes = <SettingsPage,StageBoardPage>{
  SettingsPage.game: const StageBoardPage(
    name: "Game",
    longName: "Your game, your rules",
    icon: Icons.menu,
  ),
  SettingsPage.settings: const StageBoardPage(
    name: "Settings",
    longName: "Specify behaviors",
    icon: McIcons.settings,
    unselectedIcon: McIcons.settings_outline,
  ),
  SettingsPage.info: const StageBoardPage(
    name: "Info",
    longName: "Details and contacts",
    icon: Icons.info,
    unselectedIcon: Icons.info_outline,
  ),
  SettingsPage.theme: const StageBoardPage(
    name: "Theme",
    longName: "Customize appearance",
    icon: Icons.palette,
    unselectedIcon: McIcons.palette_outline,
  ),

};