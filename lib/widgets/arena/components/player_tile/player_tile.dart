import 'package:counter_spell/core.dart';

import 'components/all.dart';

class ArenaPlayerTile extends StatelessWidget {
  const ArenaPlayerTile(
    this.index, {
    super.key,
    required this.indexToName,
    required this.buttonAlignment,
    // @required this.constraints,
    required this.logic,
    required this.isScrollingSomewhere,
    required this.page,
  });

  //Business Logic
  final CSBloc logic;

  //Interaction information
  final bool isScrollingSomewhere;

  final CSPage page;

  //Layout information
  // final BoxConstraints constraints;
  final Alignment buttonAlignment;

  //Reordering stuff
  final Map<int, String?> indexToName;
  final int index;

  CSSettings get settings => logic.settings;
  CSSettingsArena get arenaSettings => settings.arenaSettings;
  CSGame get gameLogic => logic.game;
  CSGameState get stateLogic => gameLogic.gameState;
  CSGameAction get actionLogic => gameLogic.gameAction;
  CSGameGroup get groupLogic => gameLogic.gameGroup;

  String? firstUnpositionedName(
      Map<int, String?> indexToName, GameState gameState) {
    for (final name in gameState.names) {
      if (!indexToName.values.contains(name)) {
        return name;
      }
    }
    return null;
  }

  void positionName(String? name, int position) {
    groupLogic.arenaNameOrder.value[position] = name;
    groupLogic.arenaNameOrder.refresh();
  }

  void playerCallback(
    int index,
    GameState gameState,
    Map<int, String?> indexToName,
  ) =>
      positionName(
        firstUnpositionedName(indexToName, gameState),
        index,
      );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final StageData<CSPage, SettingsPage>? stage = Stage.of(context);

    final String? name = indexToName[index];

    // TODO: mostra at all quando uno è morto

    return LayoutBuilder(
      builder: (_, constraints) => ConstrainedBox(
        constraints: constraints,
        child: BlocVar.build7<Map<CSPage, Color?>?, int, GameState, String,
            String, Color, Map<String, bool?>>(
          stage!.themeController.derived.mainPageToPrimaryColor,
          logic.scroller.intValue,
          stateLogic.gameState,
          actionLogic.attackingPlayer,
          actionLogic.defendingPlayer,
          logic.themer.defenseColor,
          actionLogic.selected,
          builder: (
            BuildContext context,
            Map<CSPage, Color?>? pageColors,
            int? increment,
            GameState gameState,
            String? whoIsAttacking,
            String? whoIsDefending,
            Color? defenseColor,
            Map<String, bool?>? selectedNames,
          ) {
            if (name == null) return buildPositioner(themeData, gameState);

            final bool? rawSelected = selectedNames![name];
            final bool highlighted = selectedNames[name] != false ||
                whoIsAttacking == name ||
                whoIsDefending == name;

            final Widget content = AptContent(
              highlighted: highlighted,
              rawSelected: rawSelected,
              name: name,
              bloc: logic,
              isScrollingSomewhere: isScrollingSomewhere,
              pageColors: pageColors,
              increment: increment,
              buttonAlignment: buttonAlignment,
              constraints: constraints,
              gameState: gameState,
              page: page,
              whoIsAttacking: whoIsAttacking,
              whoIsDefending: whoIsDefending,
              defenseColor: defenseColor,
              counter: Counter.poison,
              //LOW PRIORITY: not reacting to counters
            );

            final Widget gesturesApplied = AptGestures(
              content: content,
              buttonAlignment: buttonAlignment,
              rawSelected: rawSelected,
              name: name,
              bloc: logic,
              constraints: constraints,
              isScrollingSomewhere: isScrollingSomewhere,
              page: page,
              havingPartnerB: gameState.players[name]!.havePartnerB,
              usingPartnerB: gameState.players[name]!.usePartnerB,
              whoIsAttacking: whoIsAttacking,
              whoIsDefending: whoIsDefending,
            );

            final Widget imageApplied = AptCardImage(
              bloc: logic,
              name: name,
              gesturesApplied: gesturesApplied,
              highlighted: highlighted,
              gameState: gameState,
              isAttacking: whoIsAttacking == name,
              isDefending: whoIsDefending == name,
              defenseColor: defenseColor,
              pageColors: pageColors,
              maxWidth: constraints.maxWidth,
            );

            final Widget backgroundApplied = AptBackGround(
              highlighted: highlighted,
              imageApplied: imageApplied,
              isAttacking: whoIsAttacking == name,
              isDefending: whoIsDefending == name,
              defenseColor: defenseColor,
              pageColors: pageColors,
            );

            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: backgroundApplied,
            );
          },
        ),
      ),
    );
  }

  Widget buildPositioner(ThemeData themeData, GameState gameState) => Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => playerCallback(index, gameState, indexToName),
          child: Container(
            color: Colors.transparent,
            child: SizedBox.expand(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "Tap to put ${firstUnpositionedName(indexToName, gameState)} here",
                    style: themeData.textTheme.labelLarge,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
