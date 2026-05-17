import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/counter.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class SelectedCounterBuilder extends StatelessWidget {
  const SelectedCounterBuilder({super.key, this.child, required this.builder});

  final Widget? child;
  final ChildValueBuilder<Counter> builder;

  @override
  Widget build(BuildContext context) {
    return context.counterSpell.interactionLogic.selectedCounter
        .buildWithStaticChild(builder: builder, child: child);
  }
}
