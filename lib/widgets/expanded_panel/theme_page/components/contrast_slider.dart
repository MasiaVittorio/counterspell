import 'package:counter_spell/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ContrastSlider extends StatelessWidget {
  const ContrastSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final themeLogic = context.themeLogic;

    return themeLogic.customScheme.build((context, customScheme) {
      final value = customScheme.contrastLevel;
      void onChanged(double v) => themeLogic.customScheme.update(
        customScheme.copyWith(contrastLevel: v),
      );

      return ListTile(
        minVerticalPadding: layout.margin.medium,
        titleAlignment: ListTileTitleAlignment.bottom,
        trailing: IconButton(
          onPressed: () => onChanged(0),
          icon: const Icon(Icons.restart_alt),
        ),
        title: Text(
          'Contrast value: '.todo +
              switch (value) {
                < -0.1 => 'Low',
                >= -0.1 && <= 0.1 => 'Standard',
                > 0.1 && <= 0.25 => 'Standard +',
                > 0.25 && <= 0.45 => 'Medium -',
                > 0.45 && <= 0.55 => 'Medium',
                > 0.55 && <= 0.75 => 'Medium +',
                > 0.75 && <= 0.90 => 'High -',
                _ => 'High',
              },
        ),
        subtitle: Slider(
          padding: const EdgeInsets.only(top: 8),
          value: value,
          min: -1,
          max: 1,
          onChanged: onChanged,
        ),
      );
    });
  }
}
