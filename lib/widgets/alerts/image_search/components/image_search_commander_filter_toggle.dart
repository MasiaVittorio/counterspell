import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

class ImageSearchCommanderFilterToggle extends StatelessWidget {
  const ImageSearchCommanderFilterToggle({
    super.key,
    required this.filterForCommanders,
    required this.onChanged,
  });

  final bool filterForCommanders;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedSlider<bool>(
      value: filterForCommanders,
      onSelect: (value) => onChanged(value!),
      allowDeselectOnTap: false,
      segments: [
        const SliderSegment(
          value: true,
          label: Text('Commanders'),
          selectedIcon: Icon(CounterSpellIcons.damage_filled),
          unselectedIcon: Icon(CounterSpellIcons.damage_outlined),
        ),
        SliderSegment(
          value: false,
          label: const Text('Any card'),
          selectedIcon: Icon(MdiIcons.cards),
          unselectedIcon: Icon(MdiIcons.cardsOutline),
        ),
      ],
    );
  }
}
