import 'package:counter_spell_new/core.dart';


class CSStage {

  void dispose(){
    controller.dispose();
  }

  late StageData<CSPage,SettingsPage> controller;
  final CSBloc parent;

  /// Needs the parent to have scroller initialized
  CSStage(this.parent){
    controller = StageData<CSPage,SettingsPage>(
      storeKey: "MvSidereus_CounterSpell_Stage_2",
      panelData: StagePanelData(
        onPanelOpen: () => parent.scroller.cancel(),
      ),
      popBehavior: const StagePopBehavior(
        backToDefaultMainPage: true,
        backToPreviousMainPage: false,
        backToClosePanel: true,
        backToDefaultPanelPage: true,
        backToPreviousPanelPage: false,
      ),

      initialDimensions: StageDimensions(
        collapsedPanelSize: CSSizes.collapsedPanelSize,
        panelRadiusClosed: StageDimensions.defaultBarSize/2,
        panelRadiusOpened: StageDimensions.defaultPanelRadius,
        parallax: 0.1,
        panelHorizontalPaddingOpened: horizontalPaddingOpened(defaultColorPlace),
      ),
    
      // closed pages
      mainPageToJson: (page) => CSPages.nameOf(page),
      jsonToMainPage: (json) => CSPages.fromName(json as String)!,
      initialMainPagesData: StagePagesData.nullable(
        defaultPage: CSPage.life,
        pagesData: <CSPage,StagePage>{
          for(final page in CSPage.values)
            page: StagePage(
              name: CSPages.shortTitleOf(page)!,
              longName: CSPages.longTitleOf(page),
              unselectedIcon: CSIcons.pageIconsOutlined[page],
              icon: CSIcons.pageIconsFilled[page]!,
            ),
        },
        orderedPages: CSPage.values.toList(),
      ).complete!,
      onMainPageChanged: (_) => parent.scroller.cancel(true),

      jsonToPanelPage: (json) => SettingsPages.fromName(json as String)!,
      panelPageToJson: (page) => SettingsPages.nameOf(page),
      initialPanelPagesData: const StagePagesData.nullable(
        defaultPage: SettingsPage.game,
        pagesData: settingsThemes,
        orderedPages: <SettingsPage>[
          SettingsPage.game,
          SettingsPage.settings,
          SettingsPage.theme,
          SettingsPage.info,
        ],
      ).complete,

      initialThemeData: StageThemeData.nullable(
        forceSystemNavBarStyle: true,
        bottomBarShadow: defaultColorPlace == StageColorPlace.background,
        accentSelectedPage: false,
        topBarElevations: CSThemer.topBarElevations,
        pandaOpenedPanelNavBar: true,
        brightness: const StageBrightnessData.nullable(
          brightness: Brightness.light,
          autoDark: true,
          autoDarkMode: AutoDarkMode.system,
          darkStyle: DarkStyle.nightBlue,
        ),
        colorPlace: defaultColorPlace,
        backgroundColors: StageColorsData<CSPage,SettingsPage>.nullable(
          lightAccent: CSColorScheme.defaultLight.accent,
          darkAccents: {for(final e in CSColorScheme.darkSchemes.entries) e.key: e.value.accent},

          lightMainPrimary: CSColorScheme.defaultLight.primary,
          lightMainPageToPrimary: CSColorScheme.defaultLight.perPage,
          darkMainPrimaries: {for(final e in CSColorScheme.darkSchemes.entries) e.key: e.value.primary},
          darkMainPageToPrimaries: {for(final e in CSColorScheme.darkSchemes.entries) e.key: e.value.perPage},

          lightPanelPrimary: CSColorScheme.defaultLight.primary,
          darkPanelPrimaries: {for(final e in CSColorScheme.darkSchemes.entries) e.key: e.value.primary},
        ),
        textsColors: StageColorsData<CSPage,SettingsPage>.nullable(
          lightAccent: CSColorScheme.defaultGoogleLight.accent,
          darkAccents: {for(final e in CSColorScheme.darkSchemesGoogle.entries) e.key: e.value.accent},

          lightMainPrimary: CSColorScheme.defaultGoogleLight.primary,
          lightMainPageToPrimary: CSColorScheme.defaultGoogleLight.perPage,
          darkMainPrimaries: {for(final e in CSColorScheme.darkSchemesGoogle.entries) e.key: e.value.primary},
          darkMainPageToPrimaries: {for(final e in CSColorScheme.darkSchemesGoogle.entries) e.key: e.value.perPage},

          lightPanelPrimary: CSColorScheme.defaultGoogleLight.primary,
          darkPanelPrimaries: {for(final e in CSColorScheme.darkSchemesGoogle.entries) e.key: e.value.primary},
        ),
      ).complete,
    );
  }

  static const defaultColorPlace = StageColorPlace.texts;
  static const allowPickDesign = false;

  static double horizontalPaddingOpened(StageColorPlace place) 
    => place == StageColorPlace.texts
      ? CSThemer.panelHorizontalPaddingOpenedTexts
      : StageDimensions.defaultPanelHorizontalPaddingOpened;

}

const settingsThemes = <SettingsPage,StagePage>{
  SettingsPage.game: StagePage(
    name: "Game",
    longName: "Your game, your rules",
    icon: Icons.menu,
  ),
  SettingsPage.settings: StagePage(
    name: "Settings",
    longName: "Specify behaviors",
    icon: McIcons.cog,
    unselectedIcon: McIcons.cog_outline,
  ),
  SettingsPage.info: StagePage(
    name: "Info",
    longName: "Details and contacts",
    icon: Icons.info,
    unselectedIcon: Icons.info_outline,
  ),
  SettingsPage.theme: StagePage(
    name: "Theme",
    longName: "Customize appearance",
    icon: Icons.palette,
    unselectedIcon: McIcons.palette_outline,
  ),

};