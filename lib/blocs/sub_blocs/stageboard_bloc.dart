import 'package:counter_spell_new/models/game/types/type_ui.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:counter_spell_new/themes/preset_themes.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/stageboard/stage_board.dart';

import '../bloc.dart';

class CSStageBoard {

  void dispose(){
    controller.dispose();
  }

  final StageBoardData<CSPage,SettingsPage> controller = StageBoardData<CSPage,SettingsPage>(
      barSize: StageBoard.kBarSize,
      collapsedPanelSize: StageBoard.kBarSize,
      panelRadiusClosed: StageBoard.kBarSize/2,
      panelRadiusOpened: StageBoard.kPanelRadius,

      initialClosedPage: CSPage.life,
      initialClosedPagesData: <CSPage,StageBoardPageTheme>{
        for(final page in CSPage.values)
          page: StageBoardPageTheme(
            primaryColor: defaultPageColorsLight[page],
            name: CSPAGE_TITLES_SHORT[page],
            longName: CSPAGE_TITLES_LONG[page],
            unselectedIcon: CSTypesUI.pageIconsOutlined[page],
            icon: CSTypesUI.pageIconsFilled[page],
          ),
      },
      decodePageClosed: (json) => STRING_TO_CSPAGE[json as String],
      encodePageClosed: (page) => CSPAGE_TO_STRING[page],
      initialClosedPagesList: CSPage.values,

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


      panelHorizontalPaddingClosed: StageBoard.kPanelHorizontalPaddingClosed,
      panelHorizontalPaddingOpened: StageBoard.kPanelHorizontalPaddingOpened,

      lastClosedPage: CSPage.life,
  );
  final CSBloc parent;
  CSStageBoard(this.parent);
}

const settingsThemes = <SettingsPage,StageBoardPageTheme>{
  SettingsPage.game: const StageBoardPageTheme(
    name: "Game",
    longName: "Your game, your rules",
    icon: Icons.menu,
  ),
  SettingsPage.settings: const StageBoardPageTheme(
    name: "Settings",
    longName: "Specify behaviors",
    icon: McIcons.settings,
    unselectedIcon: McIcons.settings_outline,
  ),
  SettingsPage.info: const StageBoardPageTheme(
    name: "Info",
    longName: "Details and contacts",
    icon: Icons.info,
    unselectedIcon: Icons.info_outline,
  ),
  SettingsPage.theme: const StageBoardPageTheme(
    name: "Theme",
    longName: "Customize appearance",
    icon: Icons.palette,
    unselectedIcon: McIcons.palette_outline,
  ),

};