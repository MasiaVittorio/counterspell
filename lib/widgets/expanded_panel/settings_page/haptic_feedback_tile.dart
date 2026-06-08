import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:counter_spell/widgets/components/common/small_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class HapticFeedbackTile extends StatelessWidget {
  const HapticFeedbackTile({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final settingsLogic = counterSpell.settingsLogic;
    final theme = context.theme;

    return (
      settingsLogic.hapticFeedbackAvailable,
      settingsLogic.hapticFeedbackWanted,
    ).build((context, available, wanted) {
      return ColoredTile(
        title: const Text('Haptic feedback'),
        leading: Icon(switch ((available, wanted)) {
          (true, true) => MdiIcons.vibrate,
          (true, false) => MdiIcons.vibrateOff,
          _ => MdiIcons.vibrateOff,
        }),
        containTrailing: false,
        subtitle: Text(switch (available) {
          true => 'Vibrate the device when editing values',
          false => 'This device cannot vibrate :c',
          null => 'Checking permissions...',
        }),
        lowLeading: !(wanted && available == true),
        onTap: available == true
            ? () => settingsLogic.hapticFeedbackWanted.update(!wanted)
            : null,
        trailing: switch (available) {
          true => Switch(
            value: wanted,
            onChanged: settingsLogic.hapticFeedbackWanted.update,
          ),
          false => Icon(
            Icons.warning_amber_outlined,
            color: theme.colorScheme.error,
          ),
          null => const SmallProgressIndicator(strokeWidth: 3),
        },
      );
    });
  }
}
