import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';

class AntiSelectToggle extends StatelessWidget {
  const AntiSelectToggle({super.key, required this.playerIndex});

  final int playerIndex;

  @override
  Widget build(BuildContext context) {
    final interactionLogic = context.counterSpell.interactionLogic;
    final delay = context.delay;
    return interactionLogic.playersMultiSelection.build((
      context,
      multiSelection,
    ) {
      final value = multiSelection[playerIndex];
      return value == null
          ? FilledButton.icon(
              onPressed: () {
                interactionLogic.selectPlayer(playerIndex: playerIndex);
                delay.extend();
              },
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Inverted'),
            )
          : FilledButton.tonalIcon(
              onPressed: () {
                interactionLogic.antiSeselectPlayer(playerIndex: playerIndex);
                delay.extend();
              },
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Invert'),
            );
    });
  }
}
