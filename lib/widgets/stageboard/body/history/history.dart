import 'package:counter_spell_new/game_model/types/counters.dart';
import 'package:counter_spell_new/widgets/stageboard/body/history/history_tile.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

import 'package:counter_spell_new/business_logic/sub_blocs/blocs.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/core.dart';
import 'package:stage/stage.dart';

class BodyHistory extends StatelessWidget {
  final List<String> names;
  final int count;
  final CSGameGroup group;
  final double tileSize;
  final double coreTileSize;
  final CSTheme theme;
  final double bottom;
  final Map<CSPage,Color> pageColors;

  const BodyHistory({
    @required this.names,
    @required this.bottom,
    @required this.count,
    @required this.group,
    @required this.tileSize,
    @required this.coreTileSize,
    @required this.theme,
    @required this.pageColors,
  });
  
  @override
  Widget build(BuildContext context) {

    final game = group.parent;
    final history = game.gameHistory;
    final stage = Stage.of(context);

    return group.havingPartnerB.build((context, havePartnerB){

        final Map<String, Counter> counters = game.gameAction.currentCounterMap;

        return Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: SidAnimatedList(
            listController: history.listController,
            reverse: true, //reverse to make it appear aligned to the right
            itemBuilder: (context, index, animation) 
              => SizeTransition(
                axisAlignment: -1.0,
                axis: Axis.horizontal,
                sizeFactor: animation,
                child: HistoryTile(
                  //but you must reverse the list to keep the last state on its "top"
                  history.data[history.data.length -1 - index],
                  tileSize: tileSize,
                  coreTileSize: coreTileSize,
                  avoidInteraction: false,
                  theme: theme,
                  pageColors: pageColors,
                  counters: counters,
                  names: names,
                  havePartnerB: havePartnerB,
                ),
              ),
            initialItemCount: 1,
            scrollDirection: Axis.horizontal,
            physics: SidereusScrollPhysics(
              topBounce: true,
              bottomBounce: false,
              topBounceCallback: () => stage.pagesController.page.set(CSPage.life),
              alwaysScrollable: true,
            ),
            shrinkWrap: false,
          ),
        );
      }
    );
  }
}
