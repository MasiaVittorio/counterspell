import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/players_column_layout.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/player_tile.dart';
import 'package:flutter/material.dart';

class PlayersListView extends StatelessWidget {
  const PlayersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final playgroupLogic = counterSpell.playgroupLogic;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return playgroupLogic.listSeatOrder.build((context, seatOrder) {
      return counterSpell.gameLogic.buildWithGame((context, game) {
        return PlayersColumnLayout(
          children: [
            for (final int index in seatOrder)
              if (game.gameStates.last.playerStates.length > index)
                PlayerTile(
                  index: index,
                  gameSettings: game.settings,
                  gameState: game.gameStates.last,
                  screenWidth: screenWidth,
                  isLast: index == seatOrder.last,
                  isFirst: index == seatOrder.first,
                ),
          ],
        );
      });
    });
  }
}
