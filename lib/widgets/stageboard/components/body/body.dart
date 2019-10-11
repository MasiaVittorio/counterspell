import 'package:counter_spell_new/widgets/constants.dart';
import 'package:flutter/material.dart';

import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:flutter/scheduler.dart';
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
    final stageBoard = StageBoard.of<CSPage,SettingsPage>(context);
    final currentPage = stageBoard.pagesController.page;
    final pageThemes = stageBoard.pagesController.pageThemes;

    return LayoutBuilder(builder: (context, constraints)
      => group.names.build((context, names){

        final bool landScape = constraints.maxWidth >= constraints.maxHeight;
        final historyEnabled = stageBoard.pagesController.enabledPages[CSPage.history];
        if(landScape){
          if(historyEnabled){
            SchedulerBinding.instance.addPostFrameCallback((_) {
              //cant notify listeners during build phase lol
              stageBoard.pagesController.disablePage(CSPage.history);
            });
          }
        } else {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            //just (dont) build lol
            stageBoard.pagesController.enablePage(CSPage.history);
            bloc.game.gameHistory.listController.refresh(
              bloc.game.gameState.gameState.value.historyLenght,
            );
          });
        }

        final int count = names.length;
        final int rowCount = landScape 
          ? (count / 2).ceil()
          : count;

        //padding to account for the half collapsed panel that is visible over the body
        final bottom = stageBoard.collapsedPanelSize/2;

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
              child: themer.themeSet.build((_, theme) 
                => Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    if(!landScape)
                      Positioned.fill(
                        right: CSConstants.minTileSize,
                        child: BodyHistory(
                          bottom: bottom,
                          theme: theme,
                          pageThemes: pageThemes,
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
      }),
    );
  }
}
