import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/widgets/components/common/empty_view.dart';
import 'package:flutter/material.dart';

class ArenaInvalidView extends StatelessWidget {
  const ArenaInvalidView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyView(
      icon: Icon(CounterSpellIcons.counterspell),
      title: Text('Arena view is not supported for this playgroup'),
      description: Text('Try playing with 2 to 6 players!'),
    );
  }
}
