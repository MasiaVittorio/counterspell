import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:counter_spell/widgets/arena/player_cell/builders/cell_mode_builder.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_value_builder.dart';
import 'package:counter_spell/widgets/components/common/animated_count_builder.dart';
import 'package:counter_spell/widgets/components/common/centered_stack.dart';
import 'package:counter_spell/widgets/components/common/new_animated_listed.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellCenter extends StatelessWidget {
  const PlayerCellCenter({super.key, required this.playerIndex});

  final int playerIndex;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final controller = context.arenaPlayerController;

    final style = theme.textTheme.displayLarge!.copyWith(
      fontSize: theme.textTheme.displayLarge!.fontSize! * 1.2,
    );
    final incrementStyle = theme.textTheme.headlineMedium;
    final lifeValue = PlayerCellValueBuilder(
      mode: CellMode.life,
      playerIndex: playerIndex,
      builder: (context, value, child) => AnimatedCountBuilder(
        count: value,
        builder: (context, val, child) => Text(val.toString(), style: style),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ArenaCellModeBuilder(
          playerIndex: playerIndex,
          child: lifeValue,
          builder: (context, mode, lifeValue) {
            return CenteredStack(
              show1: mode == CellMode.life,
              child1: lifeValue!,
              child2: PlayerCellValueBuilder(
                mode: CellMode.attacking,
                playerIndex: playerIndex,
                builder: (context, value, child) =>
                    Text(value.toString(), style: style),
              ),
            );
          },
        ),
        controller.increment.build(
          (context, value) => NewAnimatedListed(
            listed: value != 0,
            direction: Axis.horizontal,
            child: Pad(
              left: theme.layout.padding.medium,
              child: Row(
                children: [
                  Text(value >= 0 ? '+' : '-', style: incrementStyle),
                  Space.horizontal(theme.layout.spacing.smaller),
                  Text(value.abs().toString(), style: incrementStyle),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
