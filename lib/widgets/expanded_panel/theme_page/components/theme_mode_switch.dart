import 'package:counter_spell/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:segmented_slider/components/ready_to_use/theme_mode_slider.dart';

class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.themeLogic;

    return logic.themeMode.build(
      (context, value) =>
          ThemeModeSlider(value: value, onChanged: logic.themeMode.update),
    );
  }
}
