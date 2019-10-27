import 'package:counter_spell_new/models/game/model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:flutter/material.dart';

import 'package:counter_spell_new/blocs/sub_blocs/blocs.dart';
import 'package:sidereus/bloc/bloc_var.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';

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
    final stage = Stage.of(context);

    return BlocVar.build2(
      stage.themeController.primaryColorsMap, 
      stage.pagesController.page,
      builder: (_, pageColors, page)
        =>BlocVar.build9(
          bloc.scroller.isScrolling,
          bloc.scroller.intValue,
          actionBloc.selected,
          actionBloc.attackingPlayer,
          actionBloc.defendingPlayer,
          actionBloc.counterSet.variable,
          group.havingPartnerB,
          bloc.game.gameState.gameState,
          group.usingPartnerB,
          builder: (
            BuildContext context, 
            bool isScrolling, 
            int increment,
            Map<String,bool> selected, 
            String attackingPlayer, 
            String defendingPlayer,
            Counter counter,
            Map<String,bool> havingPartnerB,
            GameState gameState,
            Map<String,bool> usingPartnerB,
          ) {

            final normalizedPlayerActions = CSGameAction.normalizedAction(
              pageValue: page,
              selectedValue: selected,
              gameState: gameState,
              scrollerValue: increment,
              usingPartnerB: usingPartnerB,
              attacker: attackingPlayer,
              defender: defendingPlayer,
              //these three values are so rarely updated that all the actual
              //reactive variables make this rebuild so often that min and max
              //will basically always be correct. no need to add 2 streambuilders
              applyDamageToLife: bloc.settings.applyDamageToLife.value,
              minValue: settings.minValue.value,
              maxValue: settings.maxValue.value,
              counter: counter,
            ).actions(gameState.names);

            final children = <Widget>[
              for(final name in names)
                PlayerTile(
                  name, 
                  pageColors: pageColors,
                  maxWidth: maxWidth,
                  increment: increment,
                  theme: theme,
                  group: group,
                  tileSize: tileSize,
                  coreTileSize: coreTileSize,
                  page: page,
                  havingPartnerB: havingPartnerB,
                  usingPartnerB: usingPartnerB,
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
        ),
    );
  }

}