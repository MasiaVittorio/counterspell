import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_bottom.dart';
import 'package:counter_spell/widgets/components/builders/arena_cell_more_button_builder.dart';
import 'package:counter_spell/widgets/components/common/more_to_close_icon.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';

class PlayerCellMoreButton extends StatelessWidget {
  const PlayerCellMoreButton({
    super.key,
    required this.open,
    required this.close,
  });

  final VoidCallback open;
  final VoidCallback close;

  @override
  Widget build(BuildContext context) {
    final controller = context.arenaPlayerController;
    final delay = context.delay;
    final counterSpell = context.counterSpell;

    return ArenaCellMoreButtonBuilder(
      builder: (context, mode, child) {
        return SquareIconButton(
          dimension: PlayerCellBottom.iconButtonsSize,
          onPressed: () {
            switch (mode) {
              case MoreMode.resting:
                open();
                return;
              case MoreMode.closeAdvanced:
                close();
                return;
              case MoreMode.cancel:
                controller.increment.update(0);
                delay.cancel();
                counterSpell.interactionLogic.attackingPlayerIndex.update(null);
                controller.cachedAttackerIndex.update(null);
                return;
            }
          },
          icon: MoreToCloseIcon(open: mode != MoreMode.resting),
          // icon: Icon(mode != MoreMode.resting ? Icons.close : Icons.more_horiz),
        );
      },
    );
  }
}

class ArenaPlayerCellMoreButtonModeBuilder extends StatelessWidget {
  const ArenaPlayerCellMoreButtonModeBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
