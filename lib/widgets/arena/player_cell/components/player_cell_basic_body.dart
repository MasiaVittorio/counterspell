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
          Positioned(
            top: 0,
            bottom: PlayerCellBottom.iconButtonsSize,
            left: inverted ? 0 : null,
            right: !inverted ? 0 : null,
            child: PlayerCellQuickInfo(
              playerIndex: playerIndex,
              axisAlignment: inverted ? 1 : -1,
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
