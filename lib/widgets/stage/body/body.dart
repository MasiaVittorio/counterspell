import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/resources/tutorial_card/tutorial_card.dart';
import 'package:flutter/scheduler.dart';

import 'components.dart';

class CSBody extends StatelessWidget {
  const CSBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;
    final themer = bloc.themer;
    final theme = Theme.of(context);
    final StageData<CSPage, SettingsPage> stage =
        Stage.of(context) as StageData<CSPage, SettingsPage>;
    final stageTheme = stage.themeController;

    return LayoutBuilder(
      builder: (_, constraints) => ConstrainedBox(
        constraints: constraints,
        child: SingleChildScrollView(
          child: BlocVar.build5<Map<CSPage, Color>?, bool, Color, bool,
              List<String>>(
            stageTheme.derived.mainPageToPrimaryColor,
            themer.flatDesign,
            themer.defenceColor,
            bloc.tutorial.showingTutorial,
            group.orderedNames,
            builder:
                (_, pageColors, flat, defenceColor, showingTutorial, ordered) {
              final Set<String> current = {...ordered};
              final updated = bloc.game.gameState.gameState.value.names;
              late final List<String> names;
              if (!updated.containsAll(current) ||
                  !current.containsAll(updated)) {
                names = [...updated];
              } else {
                names = ordered;
              }

              late final int? highlightableIndex;
              late final int? secondHighlightableIndex;
              if (showingTutorial) {
                if (names.length > 4) {
                  highlightableIndex = 3;
                  secondHighlightableIndex = 2;
                } else if (names.length == 4) {
                  highlightableIndex = 2;
                  secondHighlightableIndex = 1;
                } else if (names.length == 3) {
                  highlightableIndex = 1;
                  secondHighlightableIndex = null;
                } else if (names.length == 2) {
                  highlightableIndex = 1;
                  secondHighlightableIndex = null;
                } else {
                  highlightableIndex = null;
                  secondHighlightableIndex = null;
                }
              } else {
                highlightableIndex = null;
                secondHighlightableIndex = null;
              }

              final bool landScape =
                  constraints.maxWidth >= constraints.maxHeight;

              final int count = names.length;
              final int rowCount = landScape ? (count / 2).ceil() : count;

              final double tileSize = CSSizes.computeTileSize(
                constraints,
                rowCount,
                flat,
              );

              final Widget bodyHistory = BodyHistory(
                defenceColor: defenceColor,
                pageColors: pageColors!,
                count: count,
                tileSize: tileSize,
                group: group,
                names: names,
              );

              final double totalSize =
                  CSSizes.computeTotalSize(tileSize, rowCount, flat);

              return SizedBox(
                width: constraints.maxWidth,
                height: totalSize,
                child: StageBuild.offMainPagesData<CSPage>(
                  (_, enabledPages, __, currentPage) {
                    final historyEnabled = enabledPages[CSPage.history];
                    if (landScape) {
                      if (historyEnabled!) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          //cant notify listeners during build phase lol
                          stage.mainPagesController.disablePage(CSPage.history);
                        });
                      }
                    } else {
                      if (!historyEnabled!) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          //just (dont) build lol
                          stage.mainPagesController.enablePage(CSPage.history);
                          bloc.game.gameHistory.listController.refresh(
                            bloc.game.gameState.gameState.value.historyLenght,
                          );
                        });
                      }
                    }

                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if (!landScape)
                          Positioned.fill(
                            right: CSSizes.minTileSize,
                            child: bodyHistory,
                          ),
                        if (flat)
                          Positioned.fill(
                            child: IgnorePointer(
                              ignoring: true,
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 375),
                                  curve: Curves.ease,
                                  color: currentPage == CSPage.history
                                      ? theme.canvasColor.withValues(alpha: 0.0)
                                      : theme.canvasColor),
                            ),
                          ),
                        AnimatedPositioned(
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 375),
                          top: 0.0,
                          bottom: 0.0,
                          width: constraints.maxWidth,
                          left: currentPage == CSPage.history
                              ? constraints.maxWidth -
                                  CSSizes.minTileSize -
                                  (flat ? CSSizes.flatPadding : 0.0)
                              : 0.0,
                          child: Material(
                            elevation: flat ? 0 : 8,
                            type: flat
                                ? MaterialType.transparency
                                : MaterialType.canvas,
                            child: BodyGroup(
                              names,
                              // bottom: 0,
                              bottom: CSSizes.extraBottomPlayerTile(flat),
                              currentPage: currentPage,
                              maxWidth: constraints.maxWidth,
                              count: count,
                              pageColors: pageColors,
                              tileSize: tileSize,
                              defenceColor: defenceColor,
                              group: group,
                              landScape: landScape,
                              highlightableIndex: highlightableIndex,
                              secondHighlightableIndex:
                                  secondHighlightableIndex,
                              flat: flat,
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          top: 0,
                          right: showingTutorial ? 0 : -constraints.maxWidth,
                          width: constraints.maxWidth,
                          duration: const Duration(milliseconds: 500),
                          curve: showingTutorial
                              ? Curves.easeOutBack
                              : Curves.easeOutBack.flipped,
                          child: SizedBox(
                            height: tileSize,
                            width: constraints.maxWidth,
                            child: TutorialCards(
                              hints: bloc.tutorial.hints,
                              logic: bloc,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
