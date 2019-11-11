import 'package:counter_spell_new/core.dart';


final _primary = const Color(0xFF263133);
final _darkPrimaries = <DarkStyle,Color>{
  for(final style in DarkStyle.values)
    style: _primary,
};

class CSStage {

  void dispose(){
    controller.dispose();
  }

  final StageData<CSPage,SettingsPage> controller;
  final CSBloc parent;
  CSStage(this.parent): controller = StageData<CSPage,SettingsPage>(
    dimensions: StageDimensions(
      barSize: Stage.kBarSize,
      collapsedPanelSize: Stage.kBarSize,
      panelRadiusClosed: Stage.kBarSize/2,
      panelRadiusOpened: Stage.kPanelRadius,
      panelHorizontalPaddingClosed: Stage.kPanelHorizontalPaddingClosed,
      panelHorizontalPaddingOpened: Stage.kPanelHorizontalPaddingOpened,
    ),

    // closed pages
    initialClosedPage: CSPage.life,
    initialClosedPagesData: <CSPage,StagePage>{
      for(final page in CSPage.values)
        page: StagePage(
          // primaryColor: defaultPageColorsLight[page],
          name: CSPages.shortTitleOf(page),
          longName: CSPages.longTitleOf(page),
          unselectedIcon: CSTypesUI.pageIconsOutlined[page],
          icon: CSTypesUI.pageIconsFilled[page],
        ),
    },
    decodePageClosed: (json) => CSPages.fromName(json as String),
    encodePageClosed: (page) => CSPages.nameOf(page),
    initialClosedPagesList: CSPage.values,
    onClosedPageChanged: (_) => parent.scroller.cancel(true),

    // opened pages
    initialOpenedPage: SettingsPage.game,
    decodePageOpened: (json) => SettingsPages.fromName(json as String),
    encodePageOpened: (page) => SettingsPages.nameOf(page),
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

const settingsThemes = <SettingsPage,StagePage>{
  SettingsPage.game: const StagePage(
    name: "Game",
    longName: "Your game, your rules",
    icon: Icons.menu,
  ),
  SettingsPage.settings: const StagePage(
    name: "Settings",
    longName: "Specify behaviors",
    icon: McIcons.settings,
    unselectedIcon: McIcons.settings_outline,
  ),
  SettingsPage.info: const StagePage(
    name: "Info",
    longName: "Details and contacts",
    icon: Icons.info,
    unselectedIcon: Icons.info_outline,
  ),
  SettingsPage.theme: const StagePage(
    name: "Theme",
    longName: "Customize appearance",
    icon: Icons.palette,
    unselectedIcon: McIcons.palette_outline,
  ),

};