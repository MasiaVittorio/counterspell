import 'package:counter_spell/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

class ColorSourceSlider extends StatelessWidget {
  const ColorSourceSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = context.provide<ThemeLogic>();
    return themeLogic.useDynamic.build((context, value) {
      return SegmentedSlider<bool>(
        segments: [
          const SliderSegment(
            value: true,
            label: Text('Device'),
            unselectedIcon: Icon(Icons.smartphone_outlined),
          ),
          SliderSegment(
            value: false,
            label: const Text('Manual'),
            unselectedIcon: Icon(MdiIcons.eyedropper),
          ),
        ],
        value: value,
        allowDeselectOnTap: false,
        onSelect: (value) {
          themeLogic.useDynamic.update(value ?? false);
        },
      );
    });
  }
}
