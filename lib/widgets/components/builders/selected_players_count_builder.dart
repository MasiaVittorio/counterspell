import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/map_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class SelectedPlayersCountBuilder extends StatelessWidget {
  const SelectedPlayersCountBuilder({
    super.key,
    this.child,
    required this.builder,
  });

  final Widget? child;
  final ChildValueBuilder<int> builder;

  @override
  Widget build(BuildContext context) {
    return MapBuilder<List<bool?>, int>(
      reactive: context.counterSpell.interactionLogic.playersMultiSelection,
      map: (v) => v.where((e) => e != false).length,
      keys: [],
      builder: builder,
      child: child,
    );
  }
}
