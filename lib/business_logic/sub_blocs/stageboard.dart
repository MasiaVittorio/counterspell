import 'package:counter_spell_new/core.dart';



class CSStage {

  static const Color primary = const Color(0xFF263133);
  static const Color accent = const Color(0xFF00BFA5);
  static const Map<DarkStyle,Color> darkPrimaries = <DarkStyle,Color>{
    DarkStyle.nightBlue: const Color(0xFF222E3C), 
    DarkStyle.dark: const Color(0xFF1E1E1E),
    DarkStyle.nightBlack: const Color(0xFF191919),
    DarkStyle.amoled: const Color(0xFF151515),
  };
  static const Map<DarkStyle,Color> darkAccents = const <DarkStyle,Color>{
    DarkStyle.nightBlue: const Color(0xFF64FFDA), 
    DarkStyle.dark: const Color(0xFFECEFF1),
    DarkStyle.nightBlack: const Color(0xFFCFD8DC),
    DarkStyle.amoled: const Color(0xFFCFD8DC),
  };

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
    lightPrimary: primary,
    darkPrimaries: darkPrimaries,
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