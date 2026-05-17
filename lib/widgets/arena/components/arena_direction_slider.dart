import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:flutter/material.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

class ArenaDirectionSlider extends StatelessWidget {
  const ArenaDirectionSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    return counterSpell.settingsLogic.arenaDirection.build((context, value) {
      return SegmentedSlider<Axis>(
        segments: [
          const SliderSegment(
            value: Axis.horizontal,
            label: Text('Right / left'),
            selectedIcon: RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.unfold_more),
            ),
          ),
          const SliderSegment(
            value: Axis.vertical,
            label: Text('Top / bottom'),
            selectedIcon: Icon(Icons.unfold_more),
          ),
        ],
        value: value,
        onSelect: (value) =>
            counterSpell.settingsLogic.arenaDirection.update(value!),
        allowDeselectOnTap: false,
      );
    });
  }
}

class ArenaDirectionToggle extends StatelessWidget {
  const ArenaDirectionToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    return counterSpell.settingsLogic.arenaDirection.build((context, value) {
      return ColoredTile(
        leading: AnimatedRotation(
          duration: Durations.medium1,
          curve: Curves.easeOutBack,
          turns: value == Axis.horizontal ? 1 / 4 : 0,
          child: const Icon(Icons.unfold_more),
        ),
        subtitle: AnimatedText(
          value == Axis.horizontal ? 'Right / left' : 'Top / bottom',
          duration: Durations.medium1,
        ),
        title: const Text('Tap orientation'),
        onTap: () =>
            counterSpell.settingsLogic.arenaDirection.update(switch (value) {
              Axis.horizontal => Axis.vertical,
              Axis.vertical => Axis.horizontal,
            }),
      );
    });
  }
}
