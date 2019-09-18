import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/widgets/scaffold/components/body/components/history/history_tile.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

import 'package:counter_spell_new/blocs/sub_blocs/game/sub_game_blocs.dart/game_group.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';

class BodyHistory extends StatelessWidget {
  final List<String> names;
  final int count;
  final CSGameGroup group;
  final double tileSize;
  final double coreTileSize;
  final CSTheme theme;

  const BodyHistory({
    @required this.names,
    @required this.count,
    @required this.group,
    @required this.tileSize,
    @required this.coreTileSize,
    @required this.theme,
  });
  
  @override
  Widget build(BuildContext context) {

    final bloc = group.parent.parent;
    final game = group.parent;
    final history = game.gameHistory;
    final scaffold = bloc.scaffold;
    final settings = bloc.settings;

    return settings.enabledCounters.build((context, enabled){

      final Map<String, Counter> counters = game.gameAction.currentCounterMap;

      return SidAnimatedList(
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
              counters: counters,
              names: names,
            ),
          ),
        initialItemCount: 1,
        scrollDirection: Axis.horizontal,
        physics: SidereusScrollPhysics(
          topBounce: true,
          bottomBounce: false,
          topBounceCallback: () => scaffold.page.set(CSPage.life),
          alwaysScrollable: true,
        ),
        shrinkWrap: false,
      );
    });
  }
}
