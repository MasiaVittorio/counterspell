import 'package:counter_spell_new/core.dart';

import 'extra_button.dart';
import 'package:flutter/material.dart';


class ExtraButtonToggle extends StatelessWidget {

  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;
  final IconData iconOff;
  final String text;
  final Color colorOn;
  final Color colorOff;
  final double iconSize;

  ExtraButtonToggle({
    @required this.value,
    @required this.onChanged,
    @required this.icon,
    this.iconOff,
    this.text,
    this.colorOn,
    this.colorOff,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorOff = this.colorOff ?? theme.colorScheme.onSurface.withOpacity(0.1);
    final colorOn = this.colorOn ?? theme.accentColor.withOpacity(0.8);

    final iconColorOn = colorOn.contrast;
    final iconColorOff = theme.colorScheme.onSurface.withOpacity(0.55);

    return IconTheme.merge(
      data: IconThemeData(opacity: 1.0),
      child: AnimatedDouble(
        value: value ? 1.0 : 0.0, 
        duration: const Duration(milliseconds: 300),
        builder: (_, val){
          return ExtraButton(
            customIcon: Icon(
              value ? icon : iconOff ?? icon,
              size: iconSize,
              color: Color.lerp(iconColorOff, iconColorOn, val),
            ),
            icon: null,
            text: text,
            customCircleColor: Color.lerp(colorOff, colorOn, val),
            onTap: () => onChanged(!(value ?? false)),
          );
        },
      ),
    );
  }
}