import 'package:counter_spell/logic/theme_logic.dart';
import 'package:flutter/material.dart';

class FloatingAlertsTile extends StatelessWidget {
  const FloatingAlertsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = context.themeLogic;
    return themeLogic.floatingAlerts.build(
      (context, value) => SwitchListTile(
        title: const Text('Floating alerts'),
        value: value,
        onChanged: themeLogic.floatingAlerts.update,
      ),
    );
  }
}
