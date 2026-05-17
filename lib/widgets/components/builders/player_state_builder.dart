import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/player_state.dart';
import 'package:counter_spell/widgets/components/builders/map_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

class PlayerStateBuilder extends StatelessWidget {
  const PlayerStateBuilder({
    super.key,
    required this.index,
    required this.builder,
    this.child,
  });

  final int index;
  final Widget? child;
  final ChildValueBuilder<PlayerState> builder;

  @override
  Widget build(BuildContext context) {
    return MapBuilder(
      reactive: context.counterSpell.gameLogic.gameReactive,
      map: (a) => a.currentState.playerStates[index],
      keys: [index],
      builder: builder,
      child: child,
    );
  }
}
