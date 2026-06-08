import 'package:counter_spell/logic/theme_logic.dart';
import 'package:flutter/material.dart';

class FloatingPanelTile extends StatelessWidget {
  const FloatingPanelTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = context.themeLogic;
    return themeLogic.floatingPanel.build(
      (context, value) => SwitchListTile(
        title: const Text('Floating expanded panel'),
        value: value,
        onChanged: themeLogic.floatingPanel.update,
      ),
    );
  }
}
