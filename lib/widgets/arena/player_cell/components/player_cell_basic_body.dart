import 'package:counter_spell/widgets/arena/components/button_side.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_bottom.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_center.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_quick_info.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_side_taps.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellBasicBody extends StatelessWidget {
  const PlayerCellBasicBody({
    super.key,
    required this.playerIndex,
    required this.avoidMenuButton,
    required this.open,
  });

  final int playerIndex;
  final bool avoidMenuButton;
  final VoidCallback open;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final bool inverted = avoidMenuButton
        ? context.buttonSide == ButtonSideData.right
        : false;

    return PlayerCellSideTaps(
      child: Stack(
        children: [
          // Commander damage chips, pinned to the top-left.
          Positioned(
            top: 0,
            bottom: PlayerCellBottom.iconButtonsSize,
            left: 0,
            child: PlayerCellQuickInfo(
              playerIndex: playerIndex,
              axisAlignment: 1,
              group: QuickInfoGroup.commanderDamage,
            ),
          ),
          // Counters, statuses and casts, pinned to the top-right.
          Positioned(
            top: 0,
            bottom: PlayerCellBottom.iconButtonsSize,
            right: 0,
            child: PlayerCellQuickInfo(
              playerIndex: playerIndex,
              axisAlignment: -1,
              group: QuickInfoGroup.other,
            ),
          ),
          Positioned.fill(
            bottom: layout.padding.small,
            child: Center(child: PlayerCellCenter(playerIndex: playerIndex)),
          ),
          Positioned.fill(
            child: Al.bottomCenter(
              child: PlayerCellBottom(
                playerIndex: playerIndex,
                inverted: inverted,
                open: open,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
