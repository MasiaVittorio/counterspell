import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_description.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_mode_icon.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellBottom extends StatelessWidget {
  const PlayerCellBottom({
    super.key,
    required this.playerIndex,
    required this.inverted,
    required this.open,
  });

  final int playerIndex;
  final bool inverted;
  final VoidCallback open;

  static const double iconButtonsSize = 52;

  @override
  Widget build(BuildContext context) {
    final playerCellModeIcon = PlayerCellModeIcon(playerIndex: playerIndex);
    return Row(
      children: [
        if (inverted)
          const SizedBox.square(dimension: iconButtonsSize)
        else
          playerCellModeIcon,
        Expanded(
          child: Pad(
            horizontal: context.theme.layout.padding.medium,
            child: PlayerCellDescription(playerIndex: playerIndex),
          ),
        ),
        if (inverted)
          playerCellModeIcon
        else
          const SizedBox.square(dimension: iconButtonsSize),
      ],
    );
  }
}
