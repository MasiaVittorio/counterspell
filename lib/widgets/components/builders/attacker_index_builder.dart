import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';

class AttackerIndexBuilder extends StatelessWidget {
  const AttackerIndexBuilder({super.key, required this.builder, this.child});

  final Widget Function(BuildContext context, int? attackerIndex, Widget? child)
  builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return context.counterSpell.interactionLogic.attackingPlayerIndex
        .buildWithStaticChild(builder: builder, child: child);
  }
}
