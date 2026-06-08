import 'package:auto_size_text/auto_size_text.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/models/game/player_state.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_icon_value.dart';
import 'package:flutter/material.dart';

class PlayerCellCounterPage extends StatelessWidget {
  const PlayerCellCounterPage({
    super.key,
    required this.playerIndex,
    required this.counter,
    required this.state,
  });

  final int playerIndex;
  final Counter counter;
  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final value = state.counters[counter] ?? 0;

    final bool isBoolean = counter.minValue == 0 && counter.maxValue == 1;

    return InkResponse(
      onLongPress: () => counterSpell.gameLogic.editGame(
        (game) => game.addCounters(
          playerIndex: playerIndex,
          counter: counter,
          amount: -1,
        ),
      ),
      onTap: () => counterSpell.gameLogic.editGame(
        (game) => game.addCounters(
          playerIndex: playerIndex,
          counter: counter,
          amount: isBoolean
              ? value == 0
                    ? 1
                    : -1
              : 1,
        ),
      ),
      child: PlayerCellIconValue(
        icon: counter.bigIcon,
        highlightIcon: isBoolean && value > 0,
        value: value == 0
            ? const SizedBox.expand()
            : switch (isBoolean) {
                true => const SizedBox.expand(),
                false => AutoSizeText(value.toString(), maxLines: 1),
              },
      ),
    );
  }
}
