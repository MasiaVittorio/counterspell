import 'package:counter_spell_new/models/game/history_model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/widgets/constants.dart';
import 'package:counter_spell_new/widgets/scaffold/components/body/components/history/current_state_tile.dart';
import 'package:counter_spell_new/widgets/scaffold/components/body/components/history/history_player_tile.dart';
import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final double tileSize;
  final double coreTileSize;
  final GameHistoryData data;
  final bool avoidInteraction;
  final CSTheme theme;
  final Map<String, Counter> counters;
  final List<String> names;

  const HistoryTile(this.data, {
    @required this.tileSize,
    @required this.coreTileSize,
    @required this.avoidInteraction,
    @required this.theme,
    @required this.counters,
    @required this.names,
  });

  @override
  Widget build(BuildContext context) {
    if(tileSize == null){
      final howManyPlayers = data is GameHistoryNull
        ? (data as GameHistoryNull).gameState.players.length
        : data.changes.length;
      return LayoutBuilder(builder: (context, constraints)
        => buildKnowingSize(
          CSConstants.computeTileSize(
            constraints, 
            coreTileSize, 
            howManyPlayers,
          ),
        ),);
    }

    return buildKnowingSize(tileSize);
  }

  Widget buildKnowingSize(double knownTileSize){

    if(data is GameHistoryNull){
      return CurrentStateTile(
        (data as GameHistoryNull).gameState,
        (data as GameHistoryNull).index,
        names: names,
        theme: theme, 
        tileSize: tileSize,
        coreTileSize: coreTileSize,
        counters: counters,
      );
    }


    return Container(
      height: knownTileSize * data.changes.length,
      constraints: BoxConstraints(minWidth: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for(final name in names)
            HistoryPlayerTile(
              data.changes[name],
              time: data.time,
              theme: theme,
              counters: counters,
              tileSize: knownTileSize,
              coreTileSize: coreTileSize,
            ),
        ],
      ),
    );
  }
}