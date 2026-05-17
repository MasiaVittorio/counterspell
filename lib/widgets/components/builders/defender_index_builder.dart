import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';

class DefenderIndexBuilder extends StatelessWidget {
  const DefenderIndexBuilder({super.key, required this.builder, this.child});

  final Widget Function(BuildContext context, int? defenderIndex, Widget? child)
  builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return context.counterSpell.interactionLogic.defendingPlayerIndex
        .buildWithStaticChild(builder: builder, child: child);
  }
}
