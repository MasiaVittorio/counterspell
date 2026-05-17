import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:flutter/material.dart';

class AlwaysOnTile extends StatelessWidget {
  const AlwaysOnTile({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final settingsLogic = counterSpell.settingsLogic;

    return settingsLogic.alwaysOnDisplayWanted.build((context, wanted) {
      return ColoredTile(
        title: const Text('Always on display'),

        leading: Icon(switch (wanted) {
          true => Icons.settings_brightness_rounded,
          false => Icons.settings_brightness_outlined,
        }),
        subtitle: const Text(
          'Keep the device from sleeping while CounterSpell is open',
        ),
        lowLeading: !wanted,
        containTrailing: false,
        onTap: () {
          settingsLogic.alwaysOnDisplayWanted.update(!wanted);
        },
        trailing: Switch(
          value: wanted,
          onChanged: settingsLogic.alwaysOnDisplayWanted.update,
        ),
      );
    });
  }
}
