import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/list_selector.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class IsUsingPartnerABuilder extends StatelessWidget {
  const IsUsingPartnerABuilder({
    super.key,
    required this.index,
    required this.builder,
    this.child,
  });

  final int index;
  final ChildValueBuilder<bool> builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (index == -1) return builder(context, false, child);
    return ListSelector(
      index: index,
      reactive: context.counterSpell.interactionLogic.usingPartnerA,
      builder: builder,
      child: child,
    );
  }
}
