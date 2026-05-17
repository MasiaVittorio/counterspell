// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/double_map_builder.dart';
import 'package:flutter/material.dart';

class HasHistoryBuilder extends StatelessWidget {
  const HasHistoryBuilder({super.key, this.child, required this.builder});

  final Widget? child;
  final Widget Function(BuildContext context, bool hasHistory, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    final gameLogic = context.counterSpell.gameLogic;
    return DoubleMapBuilder(
      reactiveA: gameLogic.gameReactive,
      reactiveB: gameLogic.deltas,
      map: (a, b) => a.gameStates.length > 1 || b.isNotEmpty,
      keys: [],
      builder: builder,
      child: child,
    );
  }
}
