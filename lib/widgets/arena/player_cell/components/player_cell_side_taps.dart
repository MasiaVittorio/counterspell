import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';

class PlayerCellSideTaps extends StatelessWidget {
  const PlayerCellSideTaps({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = context.arenaPlayerController;
    final delay = context.delay;
    final counterSpell = context.counterSpell;
    void onIncrease() {
      controller.increase();
      counterSpell.settingsLogic.vibrate();
      delay.tap();
    }

    void onDecrease() {
      controller.decrease();
      counterSpell.settingsLogic.vibrate();
      delay.tap();
    }

    return context.counterSpell.settingsLogic.arenaDirection.build((
      context,
      direction,
    ) {
      return Stack(
        children: [
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: Flex(
                direction: direction,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: direction == Axis.horizontal
                          ? onDecrease
                          : onIncrease,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: direction == Axis.horizontal
                          ? onIncrease
                          : onDecrease,
                    ),
                  ),
                ],
              ),
            ),
          ),
          child,
        ],
      );
    });
  }
}
