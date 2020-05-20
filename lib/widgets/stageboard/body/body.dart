import 'package:counter_spell_new/core.dart';
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
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);


    return LayoutBuilder(builder: (context, constraints)
      => StageBuild.offMainPagesData<CSPage>((_, enabledPages, __, currentPage)
        => BlocVar.build2<List<String>, Map<CSPage,Color>>(
          group.names,
          stage.themeController.derived.mainPageToPrimaryColor,
          builder: (context, names, pageColors){
            //TODO: names distinct?

            final bool landScape = constraints.maxWidth >= constraints.maxHeight;
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

            final int count = names.length;
            final int rowCount = landScape 
              ? (count / 2).ceil()
              : count;

            //padding to account for the half collapsed panel that is visible over the body
            final bottom = stage.dimensionsController.dimensions.value.collapsedPanelSize/2;

            final _sureConstraints = constraints.copyWith(
              maxHeight: constraints.maxHeight - bottom,
              minHeight: constraints.maxHeight - bottom,
            );
            final double tileSize = CSSizes.computeTileSize(
              _sureConstraints, 
              coreTileSize, 
              rowCount,
            );

            final double totalSize = tileSize * rowCount + bottom;

            return ConstrainedBox(
              constraints: constraints,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: totalSize,
                  child: themer.defenceColor.build((_, defenceColor) 
                    => Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if(!landScape)
                          Positioned.fill(
                            right: CSSizes.minTileSize,
                            child: BodyHistory(
                              bottom: bottom,
                              defenceColor: defenceColor,
                              pageColors: pageColors,
                              count: count,
                              tileSize: tileSize,
                              group: group,
                              names: names,
                              coreTileSize: coreTileSize,
                            ),
                          ),

                        AnimatedPositioned(
                          duration: CSAnimations.fast,
                          top: 0.0,
                          bottom: 0.0,
                          width: constraints.maxWidth,
                          left: currentPage == CSPage.history 
                            ? constraints.maxWidth - CSSizes.minTileSize
                            : 0.0,

                          child: Material(
                            child: BodyGroup(
                              names,
                              bottom: bottom,
                              maxWidth: constraints.maxWidth,
                              count: count,
                              tileSize: tileSize,
                              coreTileSize: coreTileSize,
                              defenceColor: defenceColor,
                              group: group,
                              landScape: landScape,
                            ),
                          ),
                        ),

                      ],
                    )
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
