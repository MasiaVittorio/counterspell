import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/interaction/arena_layout_mode.dart';
import 'package:counter_spell/widgets/arena/components/arena_layout_.dart';
import 'package:counter_spell/widgets/arena/layouts_picker/arena_cell_example.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ArenaLayoutExample extends StatelessWidget {
  const ArenaLayoutExample({
    super.key,
    required this.mode,
    required this.horizontalFlip,
    required this.verticalFlip,
  });

  final ArenaLayoutMode mode;
  final bool horizontalFlip;
  final bool verticalFlip;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final counterSpell = context.counterSpell;
    final playgroupLogic = counterSpell.playgroupLogic;

    void onDropPlayerIndexOnCellIndex(int playerIndex, int cellIndex) {
      final List<int> currentSeatOrder = [
        ...playgroupLogic.arenaSeatOrder.value,
      ];
      if (!currentSeatOrder.contains(playerIndex)) return;
      if (cellIndex < 0 || cellIndex >= currentSeatOrder.length) return;
      final int oldIndexForThisPlayer = currentSeatOrder.indexOf(playerIndex);
      final int oldPlayerForTheNewIndex = currentSeatOrder[cellIndex];

      if (oldIndexForThisPlayer == cellIndex) return;

      final List<int> newSeatOrder = [
        for (int i = 0; i < currentSeatOrder.length; i++)
          if (i == oldIndexForThisPlayer)
            oldPlayerForTheNewIndex
          else if (i == cellIndex)
            playerIndex
          else
            currentSeatOrder[i],
      ];

      playgroupLogic.arenaSeatOrder.update(newSeatOrder);
    }

    return (
      counterSpell.gameLogic.gameReactive,
      counterSpell.playgroupLogic.arenaSeatOrder,
    ).build((context, game, seatOrder) {
      return Pad(
        top: layout.padding.tiny,
        horizontal: layout.margin.medium / 2,
        child: ArenaLayout(
          players: [
            for (int i = 0; i < mode.playerCount; i++)
              ArenaCellExample(
                flat: false,
                cellIndex: i,
                playerIndex: seatOrder.elementAtOrNull(i),
                game: game,
                onDropPlayerIndexOnCellIndex: onDropPlayerIndexOnCellIndex,
              ),
          ],
          foregroundBuilder: null,
          horizontalFlip: horizontalFlip,
          verticalFlip: verticalFlip,
          spacing: layout.spacing.smaller,
          mode: mode,
        ),
      );
    });
  }
}
