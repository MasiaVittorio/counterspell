import 'package:counter_spell_new/core.dart';
import 'package:flutter/scheduler.dart';

import 'components.dart';


class CSBody extends StatelessWidget {
  
  const CSBody({
    Key key,
  }): super(key: key);

  static const double _coreTileSize = CSConstants.minTileSize;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;
    final themer = bloc.themer;
    final stage = Stage.of<CSPage,SettingsPage>(context);


    return LayoutBuilder(builder: (context, constraints)
      => BlocVar.build4(
        group.names,
        stage.themeController.primaryColorsMap,
        stage.pagesController.enabledPages,
        stage.pagesController.page,
        builder: (context, names, pageColors, enabledPages, currentPage){

          final bool landScape = constraints.maxWidth >= constraints.maxHeight;
          final historyEnabled = enabledPages[CSPage.history];
          if(landScape){
            if(historyEnabled){
              SchedulerBinding.instance.addPostFrameCallback((_) {
                //cant notify listeners during build phase lol
                stage.pagesController.disablePage(CSPage.history);
              });
            }
          } else {
            if(!historyEnabled){
              SchedulerBinding.instance.addPostFrameCallback((_) {
                //just (dont) build lol
                stage.pagesController.enablePage(CSPage.history);
                debugPrint("sto per refreshare la lista animata end frame");
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
          final bottom = stage.dimensions.value.collapsedPanelSize/2;

          final _sureConstraints = constraints.copyWith(
            maxHeight: constraints.maxHeight - bottom,
            minHeight: constraints.maxHeight - bottom,
          );
          final double tileSize = CSConstants.computeTileSize(
            _sureConstraints, 
            _coreTileSize, 
            rowCount,
          );

          final double totalSize = tileSize * rowCount + bottom;

          return ConstrainedBox(
            constraints: constraints,
            child: SingleChildScrollView(
              child: SizedBox(
                width: constraints.maxWidth,
                height: totalSize,
                child: themer.theme.build((_, theme) 
                  => Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if(!landScape)
                        Positioned.fill(
                          right: CSConstants.minTileSize,
                          child: BodyHistory(
                            bottom: bottom,
                            theme: theme,
                            pageColors: pageColors,
                            count: count,
                            tileSize: tileSize,
                            group: group,
                            names: names,
                            coreTileSize: _coreTileSize,
                          ),
                        ),

                      AnimatedPositioned(
                        duration: MyDurations.fast,
                        top: 0.0,
                        bottom: 0.0,
                        width: constraints.maxWidth,
                        left: currentPage == CSPage.history 
                          ? constraints.maxWidth - CSConstants.minTileSize
                          : 0.0,

                        child: Material(
                          child: BodyGroup(
                            names,
                            bottom: bottom,
                            maxWidth: constraints.maxWidth,
                            count: count,
                            tileSize: tileSize,
                            coreTileSize: _coreTileSize,
                            theme: theme,
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
    );
  }
}
