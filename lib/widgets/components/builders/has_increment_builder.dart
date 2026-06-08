import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/map_builder.dart';
import 'package:flutter/material.dart';

class HasIncrementBuilder extends StatelessWidget {
  const HasIncrementBuilder({super.key, this.child, required this.builder});

  final Widget? child;
  final Widget Function(BuildContext context, bool hasIncrement, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    return MapBuilder(
      reactive: context.counterSpell.interactionLogic.generalIncrement,
      map: (a) => a != 0,
      keys: [],
      builder: builder,
      child: child,
    );
  }
}
