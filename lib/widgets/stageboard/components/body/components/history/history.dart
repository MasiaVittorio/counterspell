import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/widgets/stageboard/components/body/components/history/history_tile.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

import 'package:counter_spell_new/blocs/sub_blocs/blocs.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:stage_board/stage_board.dart';

class BodyHistory extends StatelessWidget {
  final List<String> names;
  final int count;
  final CSGameGroup group;
  final double tileSize;
  final double coreTileSize;
  final CSTheme theme;
  final double bottom;
  final Map<CSPage,StageBoardPageTheme> pageThemes;

  const BodyHistory({
    @required this.names,
    @required this.bottom,
    @required this.count,
    @required this.group,
    @required this.tileSize,
    @required this.coreTileSize,
    @required this.theme,
    @required this.pageThemes,
  });
  
  @override
  Widget build(BuildContext context) {

    final bloc = group.parent.parent;
    final game = group.parent;
    final history = game.gameHistory;
    final settings = bloc.settings;
    final stageBoard = StageBoard.of(context);

    return settings.enabledCounters.build((context, enabled){

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
                pageThemes: pageThemes,
                counters: counters,
                names: names,
              ),
            ),
          initialItemCount: 1,
          scrollDirection: Axis.horizontal,
          physics: SidereusScrollPhysics(
            topBounce: true,
            bottomBounce: false,
            topBounceCallback: () => stageBoard.pagesController.page = CSPage.life,
            alwaysScrollable: true,
          ),
          shrinkWrap: false,
        ),
      );
    });
  }
}
