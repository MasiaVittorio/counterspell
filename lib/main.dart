// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_spell/logic/arena_logic.dart';
import 'package:counter_spell/logic/cards_logic.dart';
import 'package:counter_spell/logic/game_logic.dart';
import 'package:counter_spell/logic/interaction_logic.dart';
import 'package:counter_spell/logic/leaderboard_logic.dart';
import 'package:counter_spell/logic/mana_pool_logic.dart';
import 'package:counter_spell/logic/pages_logic.dart';
import 'package:counter_spell/logic/playgroup_logic.dart';
import 'package:counter_spell/logic/settings_logic.dart';
import 'package:counter_spell/logic/theme_logic.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/arena/arena_view.dart';
import 'package:counter_spell/widgets/body/body.dart';
import 'package:counter_spell/widgets/collapsed_panel/collapsed_panel.dart';
import 'package:counter_spell/widgets/components/builders/can_use_arena_view_builder.dart';
import 'package:counter_spell/widgets/components/project/app_bar_subtitle.dart';
import 'package:counter_spell/widgets/components/project/app_bar_title.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:counter_spell/widgets/components/project/my_bottom_bar.dart';
import 'package:counter_spell/widgets/expanded_panel/expanded_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

void main() {
  // 1. Ensure plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Set preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CounterSpell counterSpell = CounterSpell();

  @override
  void dispose() {
    counterSpell.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CleanProvider(
      data: counterSpell,
      child: ThemeLogicProvider(
        createThemeLogic: () => ThemeLogic(),
        builder: (context, lightTheme, darkTheme, themeMode, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            themeMode: themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static PanelFrameStyleCustomizations get defaultStyle =>
      const PanelFrameStyleCustomizations(
        collapsedPanelHeight: 60,
        collapsedPanelHorizontalMargin: 16, // medium margin default
        expandedPanelMargin: EdgeInsets.zero,
        expandedPanelBorderRadius: 0,
        openPanelTopBarOverlap: 0,
        collapsedPanelBorderRadius: 32,
        alertsMargin: EdgeInsets.zero,
      );

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

extension OnStyleChanged on BuildContext {
  void changePanelStyle(PanelFrameStyleCustomizations value) =>
      provide<ValueChanged<PanelFrameStyleCustomizations>>()(value);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final themeLogic = context.themeLogic;
    final theme = context.theme;
    final layout = theme.layout;

    final primaryBarrierColor = theme.colorScheme.primaryContainer.withValues(
      alpha: 0.5,
    );

    return (themeLogic.floatingPanel, themeLogic.floatingAlerts).build((
      context,
      floatingPanel,
      floatingAlerts,
    ) {
      final customizations = MyHomePage.defaultStyle.copyWith(
        alertsMargin: floatingAlerts
            ? EdgeInsets.all(layout.margin.larger)
            : EdgeInsets.zero,
        alertsBorderRadius: floatingAlerts
            ? layout.radius.large
            : layout.radius.larger,
        alertsCanCoverViewPadding: !floatingAlerts,
        alertsBorderSide: floatingAlerts
            ? BorderSide(color: theme.colorScheme.outline)
            : BorderSide.none,
        alertsBarrierColor: floatingAlerts
            ? primaryBarrierColor
            : Colors.black54,
        expandedPanelMargin: floatingPanel
            ? EdgeInsets.all(layout.margin.larger)
            : EdgeInsets.zero,
        expandedPanelBorderRadius: floatingPanel ? layout.radius.large : 0,
        expandedPanelCanCoverViewPadding: !floatingPanel,
        expandedPanelBorderSide: floatingPanel
            ? BorderSide(color: theme.colorScheme.outline)
            : BorderSide.none,
        panelBarrierColor: floatingPanel ? primaryBarrierColor : Colors.black54,
      );

      return CleanProvider(
        data: ScrollConfiguration.of(context).getScrollPhysics(context),
        child: CleanProvider(
          data: customizations,
          child: CleanProvider(
            data: ScrollConfiguration.of(context).getScrollPhysics(context),
            child: counterSpell.interactionLogic.confirmationDelay.build(
              (context, confirmationDelay) => DelayProvider(
                delay: confirmationDelay,
                animationDuration: Motion.enterScreenEmphasized.duration,
                onApply: counterSpell.interactionLogic.applyGeneral,
                child: UsesArenaViewBuilder(
                  builder: (context, canUseArenaView, child) {
                    if (canUseArenaView) {
                      return PanelFrame(
                        redirectPopInvocations: false,
                        onPanelToggled: (value) {
                          if (!value) {
                            counterSpell.pagesLogic.panelPage.update(
                              PanelPage.game,
                            );
                          }
                        },
                        style: customizations,
                        collapsedPanel: const CollapsedPanel(),
                        expandedPanel: const ExpandedPanel(),
                        body: const ArenaView(withMenu: false),
                        topBarBuilder: null,
                        bottomBar: const PreferredSize(
                          preferredSize: Size.fromHeight(0),
                          child: SizedBox.shrink(),
                        ),
                      );
                    }

                    return PanelFrame(
                      redirectPopInvocations: false,
                      onPanelToggled: (value) {
                        if (!value) {
                          counterSpell.pagesLogic.panelPage.update(
                            PanelPage.game,
                          );
                        }
                      },
                      style: customizations,
                      collapsedPanel: const CollapsedPanel(),
                      expandedPanel: const ExpandedPanel(),
                      body: const MyBody(),
                      bottomBar: const MyBottomBar(),
                      topBarChild: const AppBarTitle(),
                      topBarBuilder: (context, child, animation) => FrameAppBar(
                        title: child!,
                        animation: animation,
                        panelSubtitle: const AppBarSubtitle(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

extension CounterSpellExtension on BuildContext {
  CounterSpell get counterSpell => provide<CounterSpell>();
}

class CounterSpell {
  final ScrollController historyScrollController = ScrollController();
  final PagesLogic pagesLogic = PagesLogic();
  final ArenaLogic arenaLogic = ArenaLogic();
  final CardsLogic cardsLogic = CardsLogic();
  final ManaPoolLogic manaPoolLogic = ManaPoolLogic();
  final SettingsLogic settingsLogic = SettingsLogic();
  late final GameLogic gameLogic; // needs cardsLogic
  late final InteractionLogic interactionLogic; // needs game and pages logic
  late final PlaygroupLogic playgroupLogic; // needs game logic
  late final LeaderboardsLogic leaderboardsLogic;

  final PersistentReactive<List<String>> bugLogs = PersistentReactive(
    [],
    key: 'counterspell_bug_logs',
  );

  CounterSpell() {
    leaderboardsLogic = LeaderboardsLogic(onLogBugs);
    gameLogic = GameLogic(cardsLogic);
    playgroupLogic = PlaygroupLogic(gameLogic);
    interactionLogic = InteractionLogic(
      gameLogic: gameLogic,
      pagesLogic: pagesLogic,
      settingsLogic: settingsLogic,
    );
    pagesLogic.bodyPage.addListener(_listener);
  }

  void onLogBugs(String bug) {
    bugLogs.value.add(DateTime.now().format('YYYY MMMM dd, HH:mm:ss - $bug'));
    bugLogs.refresh();
  }

  void _listener() {
    if (pagesLogic.bodyPage.value != BodyPage.history) {
      if (historyScrollController.hasClients) {
        historyScrollController.animateTo(
          0,
          duration: Motion.beginAndEndOnScreenEmphasized.duration,
          curve: Easings.emphasizedAccelerate,
        );
      }
    }
  }

  void dispose() {
    interactionLogic.dispose();
    playgroupLogic.dispose();
    gameLogic.dispose();
    settingsLogic.dispose();
    cardsLogic.dispose();
    arenaLogic.dispose();
    pagesLogic.dispose();
    manaPoolLogic.dispose();
    leaderboardsLogic.dispose();
    historyScrollController.dispose();
    bugLogs.dispose();
  }
}
