import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/list_selector.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class IsSelectedBuilder extends StatelessWidget {
  const IsSelectedBuilder({
    super.key,
    required this.index,
    required this.builder,
    this.child,
  });

  final int index;
  final Widget? child;
  final ChildValueBuilder<bool?> builder;

  @override
  Widget build(BuildContext context) {
    return ListSelector(
      reactive: context.counterSpell.interactionLogic.playersMultiSelection,
      index: index,
      builder: builder,
    );
  }
}
