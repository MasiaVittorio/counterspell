import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/selector.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class IsDefendingBuilder extends StatelessWidget {
  const IsDefendingBuilder({
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
    return Selector<int>(
      target: index,
      keys: [],
      reactive: context.counterSpell.interactionLogic.defendingPlayerIndex,
      builder: builder,
      child: child,
    );
  }
}
