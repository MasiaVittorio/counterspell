import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/double_map_builder.dart';
import 'package:flutter/material.dart';

class IsAttackerUsingPartnerABuilder extends StatelessWidget {
  const IsAttackerUsingPartnerABuilder({
    super.key,
    this.child,
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    bool isAttackerUsingPartnerA,
    Widget? child,
  )
  builder;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;

    return DoubleMapBuilder(
      reactiveA: counterSpell.interactionLogic.attackingPlayerIndex,
      reactiveB: counterSpell.interactionLogic.usingPartnerA,
      map: (attackerIndex, usingPartnerA) =>
          attackerIndex != null ? usingPartnerA[attackerIndex] : false,
      builder: builder,
      keys: [],
      child: child,
    );
  }
}
