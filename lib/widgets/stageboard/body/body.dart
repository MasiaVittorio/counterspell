import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile.dart';
import 'package:flutter/scheduler.dart';

import 'components.dart';


class CSBody extends StatelessWidget {
  
  const CSBody({
    Key key,
  }): super(key: key);

  static const double coreTileSize = CSSizes.minTileSize;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;
    final themer = bloc.themer;
    final theme = Theme.of(context);
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);

    //padding to account for the half collapsed panel that is visible over the body
    final bottom = stage.dimensionsController.dimensions.value.collapsedPanelSize/2;

    return stage.themeController.derived.mainPageToPrimaryColor.build((_, pageColors){
      return themer.defenceColor.build((_, defenceColor){
        return LayoutBuilder(builder: (_, constraints){

          final bool landScape = constraints.maxWidth >= constraints.maxHeight;

          final _sureConstraints = constraints.copyWith(
            maxHeight: constraints.maxHeight - bottom,
            minHeight: constraints.maxHeight - bottom,
          );

          return group.names.build((_, names){

            final int count = names.length;
            final int rowCount = landScape 
              ? (count / 2).ceil()
              : count;

            final double tileSize = CSSizes.computeTileSize(
              _sureConstraints, 
              coreTileSize, 
              rowCount,
            );

            final double totalSize = tileSize * rowCount + bottom;

            final Widget bodyHistory = BodyHistory(
              bottom: bottom,
              defenceColor: defenceColor,
              pageColors: pageColors,
              count: count,
              tileSize: tileSize,
              group: group,
              names: names,
              coreTileSize: coreTileSize,
            );

            return ConstrainedBox(
              constraints: constraints,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: totalSize,
                  child: StageBuild.offMainPagesData<CSPage>((_, enabledPages, __, currentPage){

                    final historyEnabled = enabledPages[CSPage.history];
                    if(landScape){
                      if(historyEnabled){
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          //cant notify listeners during build phase lol
                          stage.mainPagesController.disablePage(CSPage.history);
                        });
                      }
                    } else {
                      if(!historyEnabled){
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          //just (dont) build lol
                          stage.mainPagesController.enablePage(CSPage.history);
                          bloc.game.gameHistory.listController.refresh(
                            bloc.game.gameState.gameState.value.historyLenght,
                          );
                        });
                      }
                    }

                    return themer.flatDesign.build((context, flat) => Stack(
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
                                duration: CSAnimations.slow,
                                curve: Curves.ease,
                                color: currentPage == CSPage.history
                                  ? theme.canvasColor.withOpacity(0.0)
                                  : theme.canvasColor
                              ),
                            ),
                          ),

                        AnimatedPositioned(
                          curve: Curves.ease,
                          duration: CSAnimations.slow,
                          top: 0.0,
                          bottom: 0.0,
                          width: constraints.maxWidth,
                          left: currentPage == CSPage.history 
                            ? constraints.maxWidth - CSSizes.minTileSize
                              - (flat ? PlayerTile.flatPadding : 0.0)
                            : 0.0,

                          child: Material(
                            elevation: flat ? 0 : 8,
                            type: flat 
                              ? MaterialType.transparency 
                              : MaterialType.canvas,
                            animationDuration: CSAnimations.slow,
                            child: BodyGroup(
                              names,
                              currentPage: currentPage,
                              bottom: bottom,
                              maxWidth: constraints.maxWidth,
                              count: count,
                              pageColors: pageColors,
                              tileSize: tileSize,
                              coreTileSize: coreTileSize,
                              defenceColor: defenceColor,
                              group: group,
                              landScape: landScape,
                            ),
                          ),
                        ),

                      ],
                    ),);
                  },),
                ),
              ),
            );
          },);
        },);
      },);
    },);
  }
}
