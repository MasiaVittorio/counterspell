import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

class StartingLifeSlider extends StatelessWidget {
  const StartingLifeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final gameLogic = counterSpell.gameLogic;
    final frame = context.panelFrame;
    return gameLogic.startingLifeTotal.build((context, startingLife) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(
            title: Text('Starting life total: $startingLife'),
            trailing: FilledButton.tonalIcon(
              onPressed: () async {
                final result = await frame.showAlert(
                  const InsertPanelAlert(
                    label: 'Starting life total',
                    keyboardType: TextInputType.number,
                  ),
                );
                if (result case String text) {
                  final int? value = int.tryParse(text);
                  if (value case int value) {
                    gameLogic.startingLifeTotal.update(value);
                  }
                }
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            ),
          ),
          SegmentedSlider<int>(
            value: startingLife,
            onSelect: (value) =>
                gameLogic.startingLifeTotal.update(value ?? 40),
            allowDeselectOnTap: false,
            segments: const [
              SliderSegment(value: 20, label: Text('MTG')),
              SliderSegment(value: 30, label: Text('2HG')),
              SliderSegment(value: 40, label: Text('EDH')),
              SliderSegment(value: 60, label: Text('2EDH')),
            ],
          ),
        ],
      );
    });
  }
}
