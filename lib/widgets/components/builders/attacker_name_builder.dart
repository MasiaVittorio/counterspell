// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/double_map_builder.dart';
import 'package:flutter/material.dart';

class AttackerNameBuilder extends StatelessWidget {
  const AttackerNameBuilder({super.key, this.child, required this.builder});

  final Widget? child;
  final Widget Function(BuildContext context, String? name, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;

    return DoubleMapBuilder(
      reactiveA: counterSpell.gameLogic.gameReactive,
      reactiveB: counterSpell.interactionLogic.attackingPlayerIndex,
      map: (a, b) => switch ((a, b)) {
        (final game, int index) =>
          game.settings.playerSettings.elementAtOrNull(index)?.name,
        _ => null,
      },
      keys: [],
      builder: builder,
      child: child,
    );
  }
}
