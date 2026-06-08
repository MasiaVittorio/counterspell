import 'package:counter_spell/widgets/alerts/commander_damage_hint/commander_damage_hint_alert.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class SelectAttackerHint extends StatelessWidget {
  const SelectAttackerHint({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final frame = context.panelFrame;

    return InkResponse(
      onTap: () => frame.showAlert(const CommanderDamageHintAlert()),
      child: Pad(
        horizontal: theme.layout.margin.medium,
        child: Center(
          child: Text(
            'Select attacker',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
