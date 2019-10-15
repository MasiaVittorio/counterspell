import 'package:counter_spell_new/models/game/model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:flutter/material.dart';

import 'package:counter_spell_new/blocs/sub_blocs/blocs.dart';
import 'package:sidereus/bloc/bloc_var.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage_board/stage_board.dart';

import 'player_tile.dart';

class BodyGroup extends StatelessWidget {
  final List<String> names;
  final int count;
  final double tileSize;
  final double coreTileSize;
  final CSGameGroup group;
  final CSTheme theme;
  final bool landScape;
  final double maxWidth;
  final double bottom;
  
  const BodyGroup(this.names,{
    @required this.bottom,
    @required this.maxWidth,
    @required this.theme,
    @required this.count,
    @required this.group,
    @required this.tileSize,
    @required this.coreTileSize,
    @required this.landScape,
  });
  
  @override
  Widget build(BuildContext context) {

    final bloc = group.parent.parent;
    final actionBloc = bloc.game.gameAction;
    final settings = bloc.settings;
    final stageBoard = StageBoard.of(context);
    final pageThemes = stageBoard.pagesController.pageThemes;
    final page = stageBoard.pagesController.page;

    return BlocVar.build8(
      bloc.scroller.isScrolling,
      bloc.scroller.intValue,
      actionBloc.selected,
      actionBloc.attackingPlayer,
      actionBloc.defendingPlayer,
      actionBloc.counterSet.variable,
      actionBloc.isCasting,
      bloc.game.gameState.gameState,
      builder: (
        BuildContext context, 
        bool isScrolling, 
        int increment,
        Map<String,bool> selected, 
        String attackingPlayer, 
        String defendingPlayer,
        Counter counter,
        bool isCasting,
        GameState gameState,
      ) {

        final normalizedPlayerActions = CSGameAction.normalizedAction(
          pageValue: page,
          selectedValue: selected,
          gameState: gameState,
          scrollerValue: increment,

          //these two values are so rarely updated that all the actual
          //reactive variables make this rebuild so often that min and max
          //will basically always be correct. no need to add 2 streambuilders
          minValue: settings.minValue.value,
          maxValue: settings.maxValue.value,

        ).actions(gameState.names);

        final children = <Widget>[
          for(final name in names)
            PlayerTile(
              name, 
              pageThemes: pageThemes,
              maxWidth: maxWidth,
              increment: increment,
              theme: theme,
              group: group,
              tileSize: tileSize,
              coreTileSize: coreTileSize,
              page: page,
              selectedNames: selected,
              whoIsAttacking: attackingPlayer,
              whoIsDefending: defendingPlayer,
              isScrollingSomewhere: isScrolling,
              counter: counter,
              // casting: isCasting,
              gameState: gameState,
              normalizedPlayerActions: normalizedPlayerActions,
            ),
        ];

        return Material(
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Column(children: !landScape 
              ? children
              : [
                for(final couple in partition(children,2))
                  Row(children: <Widget>[
                    Expanded(child: couple[0]),
                    if(couple.length == 2)
                      Expanded(child: couple[1],)
                  ],),
              ],
            ),
          ),
        );

      },
    );
  }

}