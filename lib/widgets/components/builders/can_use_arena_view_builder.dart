import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/game.dart';
import 'package:counter_spell/widgets/components/builders/double_map_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class UsesArenaViewBuilder extends StatelessWidget {
  const UsesArenaViewBuilder({super.key, this.child, required this.builder});

  final Widget? child;
  final ChildValueBuilder<bool> builder;

  static bool canUseArenaView(int playerCount, bool preferListView) {
    return (!preferListView) && playerCount >= 2 && playerCount <= 6;
  }

  @override
  Widget build(BuildContext context) {
    var counterSpell = context.counterSpell;
    return DoubleMapBuilder<Game, bool, bool>(
      reactiveA: counterSpell.gameLogic.gameReactive,
      reactiveB: counterSpell.settingsLogic.preferListView,
      map: (game, preferListView) => canUseArenaView(
        game.gameStates.last.playerStates.length,
        preferListView,
      ),
      keys: [],
      builder: builder,
      child: child,
    );
  }
}
