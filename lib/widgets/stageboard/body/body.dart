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
    print("body building 1");
    final bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;
    final themer = bloc.themer;
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);

    //padding to account for the half collapsed panel that is visible over the body
    final bottom = stage.dimensionsController.dimensions.value.collapsedPanelSize/2;

    return stage.themeController.derived.mainPageToPrimaryColor.build((_, pageColors){
      print("body building 2 (pageColors)");
      return themer.defenceColor.build((_, defenceColor){
        print("body building 6 (defence color)");
        return LayoutBuilder(builder: (_, constraints){
          print("body building 3 (constraints)");

          final bool landScape = constraints.maxWidth >= constraints.maxHeight;

          final _sureConstraints = constraints.copyWith(
            maxHeight: constraints.maxHeight - bottom,
            minHeight: constraints.maxHeight - bottom,
          );

          return group.names.build((_, names){
            print("body building 4 (names)");

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
                    print("body building 5 (main pages data)");

                    final historyEnabled = enabledPages[CSPage.history];
                    if(landScape){
                      if(historyEnabled){
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          //cant notify listeners during build phase lol
                          print("disabling history");
                          stage.mainPagesController.disablePage(CSPage.history);
                        });
                      }
                    } else {
                      if(!historyEnabled){
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          //just (dont) build lol
                          print("enabling history");
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

                        AnimatedPositioned(
                          curve: Curves.ease,
                          duration: CSAnimations.fast,
                          top: 0.0,
                          bottom: 0.0,
                          width: constraints.maxWidth,
                          left: currentPage == CSPage.history 
                            ? constraints.maxWidth - CSSizes.minTileSize
                            : 0.0,

                          child: Material(
                            elevation: 8,
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
                    );
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
