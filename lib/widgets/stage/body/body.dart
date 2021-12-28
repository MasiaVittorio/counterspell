import 'package:counter_spell_new/core.dart';
import 'package:flutter/scheduler.dart';

import 'components.dart';


class CSBody extends StatelessWidget {
  
  const CSBody({
    Key? key,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final group = bloc.game.gameGroup;
    final themer = bloc.themer;
    final theme = Theme.of(context);
    final StageData<CSPage,SettingsPage> stage = Stage.of(context) as StageData<CSPage, SettingsPage>;
    final stageTheme = stage.themeController;

    return stageTheme.derived.mainPageToPrimaryColor.build((_, pageColors)
      => themer.flatDesign.build((_, flat) 
      => themer.defenceColor.build((_, defenceColor)
      => LayoutBuilder(builder: (_, constraints) => ConstrainedBox(
        constraints: constraints,
        child: SingleChildScrollView(
          child: group.names.build((context, names){

            final bool landScape = constraints.maxWidth >= constraints.maxHeight;

            final int count = names.length;
            final int rowCount = landScape 
              ? (count / 2).ceil()
              : count;

            final double tileSize = CSSizes.computeTileSize(
              constraints, 
              rowCount,
              flat!,
            );

            final Widget bodyHistory = BodyHistory(
              defenceColor: defenceColor,
              pageColors: pageColors,
              count: count,
              tileSize: tileSize,
              group: group,
              names: names,
            );

            final double totalSize = CSSizes
              .computeTotalSize(tileSize, rowCount, flat);

            return SizedBox(
              width: constraints.maxWidth,
              height: totalSize,
              child: StageBuild.offMainPagesData<CSPage>(
                (_, enabledPages, __, currentPage){

                  final historyEnabled = enabledPages![CSPage.history];
                  if(landScape){
                    if(historyEnabled!){
                      SchedulerBinding.instance!.addPostFrameCallback((_) {
                        //cant notify listeners during build phase lol
                        stage.mainPagesController.disablePage(CSPage.history);
                      });
                    }
                  } else {
                    if(!historyEnabled!){
                      SchedulerBinding.instance!.addPostFrameCallback((_) {
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
                      if(!landScape)
                        Positioned.fill(
                          right: CSSizes.minTileSize,
                          child: bodyHistory,
                        ),

                      if(flat)
                        Positioned.fill(
                          child: IgnorePointer(
                            ignoring: true,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 375),
                              curve: Curves.ease,
                              color: currentPage == CSPage.history
                                ? theme.canvasColor.withOpacity(0.0)
                                : theme.canvasColor
                            ),
                          ),
                        ),

                      AnimatedPositioned(
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 375),
                        top: 0.0,
                        bottom: 0.0,
                        width: constraints.maxWidth,
                        left: currentPage == CSPage.history 
                          ? constraints.maxWidth - CSSizes.minTileSize
                            - (flat ? CSSizes.flatPadding : 0.0)
                          : 0.0,

                        child: Material(
                          elevation: flat ? 0 : 8,
                          type: flat 
                            ? MaterialType.transparency 
                            : MaterialType.canvas,
                          child: BodyGroup(
                            names,
                            bottom: CSSizes.bottomBodyPadding 
                              - ((flat && CSSizes.lastFlatPadding) ? CSSizes.flatPadding : 0),
                            currentPage: currentPage,
                            maxWidth: constraints.maxWidth,
                            count: count,
                            pageColors: pageColors,
                            tileSize: tileSize,
                            defenceColor: defenceColor,
                            group: group,
                            landScape: landScape,
                          ),
                        ),
                      ),

                    ],
                  );
                },
              ),
            );
          },),
        ),
      ),),),),
    );
  }
}
