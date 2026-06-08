import 'package:counter_spell/models/game/game_settings.dart';
import 'package:counter_spell/models/game/game_state.dart';
import 'package:counter_spell/widgets/body/history_view/action_column.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class AnimatedActionColumn extends StatelessWidget {
  const AnimatedActionColumn({
    super.key,
    required this.animation,
    required this.action,
    required VoidCallback this.onDelete,
    required this.previous,
    required this.index,
    required this.finalGameState,
    required this.gameSettings,
  }) : interactive = true;
  const AnimatedActionColumn.fake({
    super.key,
    required this.animation,
    required this.action,
    required this.index,
    required this.finalGameState,
    required this.gameSettings,
  }) : previous = null,
       interactive = false,
       onDelete = null;

  final Animation<double> animation;
  final GameStateDelta action;
  final GameState finalGameState;
  final GameSettings gameSettings;
  final VoidCallback? onDelete;
  final ({GameStateDelta action, VoidCallback onMerge})? previous;
  final bool interactive;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: IgnorePointer(
        ignoring: !interactive,
        child: ActionColumn(
          delta: action,
          gameSettings: gameSettings,
          onDelete: !interactive ? null : onDelete,
          onMergeWithPrevious: !interactive ? null : previous?.onMerge,
          finalGameState: finalGameState,
        ),
      ),
      builder: (context, child) => Align(
        alignment: Alignment.centerLeft,
        widthFactor: animation.value,
        child: Opacity(
          opacity: animation.value.rangeMap(from: (0.5, 1)),
          child: child,
        ),
      ),
    );
  }
}
