import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/game.dart';
import 'package:counter_spell/widgets/components/builders/map_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayersCountBuilder extends StatelessWidget {
  const PlayersCountBuilder({super.key, this.child, required this.builder});

  final Widget? child;
  final ChildValueBuilder<int> builder;

  @override
  Widget build(BuildContext context) {
    return MapBuilder<Game, int>(
      reactive: context.counterSpell.gameLogic.gameReactive,
      map: (game) => game.gameStates.last.playerStates.length,
      keys: [],
      builder: builder,
      child: child,
    );
  }
}
