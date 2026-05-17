import 'package:counter_spell/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ColorPickerTile extends StatelessWidget {
  const ColorPickerTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = context.provide<ThemeLogic>();
    final theme = context.theme;
    final frame = context.panelFrame;

    return themeLogic.customScheme.build((context, customScheme) {
      final seedColor = customScheme.seedColor;

      void onChanged(Color value) {
        themeLogic.customScheme.update(customScheme.copyWith(seedColor: value));
      }

      void pick() async {
        frame.showAlert(
          ColorPickerPanel(
            onChanged: onChanged,
            initialColor: customScheme.seedColor,
            reactImmediately: true,
          ),
        );
      }

      return ListTile(
        onTap: pick,
        trailing: CircleAvatar(backgroundColor: seedColor),
        title: Text('Seed color'.todo),
        subtitle: Text(
          "(Due to the algorithm, this exact color might not end up as one of theme's colors)"
              .todo,
          style: theme.textTheme.bodySmall!.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    });
  }
}
