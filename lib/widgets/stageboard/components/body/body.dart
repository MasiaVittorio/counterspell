import 'package:counter_spell_new/widgets/constants.dart';
import 'package:flutter/material.dart';

import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';

import 'components/components.dart';


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
    final stageBoard = StageBoard.of<CSPage,dynamic>(context);
    final currentPage = stageBoard.pagesController.page;

    return LayoutBuilder(builder: (context, constraints)
      => group.names.build((context, names){

        final bool landScape = constraints.maxWidth >= constraints.maxHeight;
        final historyEnabled = stageBoard.pagesController.enabledPages[CSPage.history];
        if(landScape){
          if(historyEnabled){
            stageBoard.pagesController.disablePage(CSPage.history);
          }
        } else {
          if(!historyEnabled){
            stageBoard.pagesController.enablePage(CSPage.history);
            () async {
              await Future.delayed(const Duration(milliseconds: 50));
              bloc.game.gameHistory.listController.refresh(
                bloc.game.gameState.gameState.value.historyLenght,
              );
            } ();
          }
        }

        final int count = names.length;
        final int rowCount = landScape 
          ? (count / 2).ceil()
          : count;
        final sureConstraints = constraints.copyWith(
          maxHeight: constraints.maxHeight - stageBoard.collapsedPanelSize/2,
          minHeight: constraints.maxHeight - stageBoard.collapsedPanelSize/2,
        );
        final double tileSize = CSConstants.computeTileSize(
          sureConstraints, 
          _coreTileSize, 
          rowCount,
        );

        final double totalSize = tileSize * rowCount;

        return Material(
          child: Padding(
            padding: EdgeInsets.only(bottom: stageBoard.collapsedPanelSize/2),
            child: ConstrainedBox(
              constraints: sureConstraints,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: sureConstraints.maxWidth,
                  height: totalSize,
                  child: themer.themeSet.build((_, theme) 
                    => Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if(!landScape)
                          Positioned.fill(
                            right: CSConstants.minTileSize,
                            child: BodyHistory(
                              theme: theme,
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

                          child: BodyGroup(
                            names,
                            maxWidth: constraints.maxWidth,
                            count: count,
                            tileSize: tileSize,
                            coreTileSize: _coreTileSize,
                            theme: theme,
                            group: group,
                            landScape: landScape,
                          ),
                        ),

                      ],
                    )
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
