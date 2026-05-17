import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/selector.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class IsAttackingBuilder extends StatelessWidget {
  const IsAttackingBuilder({
    super.key,
    required this.index,
    required this.builder,
    this.child,
  });

  final ChildValueBuilder<bool> builder;
  final Widget? child;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (index == -1) return builder(context, false, child);
    return Selector<int>(
      target: index,
      keys: [],
      reactive: context.counterSpell.interactionLogic.attackingPlayerIndex,
      builder: builder,
      child: child,
    );
  }
}
