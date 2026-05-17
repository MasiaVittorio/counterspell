import 'package:counter_spell/logic/game_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/game_settings.dart';
import 'package:counter_spell/models/game/game_state.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/body/body.dart';
import 'package:counter_spell/widgets/body/history_view/animated_action_column.dart';
import 'package:counter_spell/widgets/components/common/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key, this.rightMargin});

  final double? rightMargin;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    return counterSpell.gameLogic.buildWithGame((context, game) {
      final n = game.gameStates.length;
      return _HistoryView(
        scrollController: counterSpell.historyScrollController,
        gameSettings: game.settings,
        rightMargin: rightMargin,
        data: [
          for (int i = n - 1; i > 0; i--)
            (
              delta: game.gameStates[i] - game.gameStates[i - 1],
              finalState: game.gameStates[i],
            ),
        ],
        onCancelAction: (pastIndex) =>
            counterSpell.gameLogic.cancelPastAction(pastIndex),
        onMergeAction: (pastIndex) =>
            counterSpell.gameLogic.mergePastAction(pastIndex),
      );
    });
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView({
    required this.data,
    required this.onCancelAction,
    required this.onMergeAction,
    required this.gameSettings,
    required this.rightMargin,
    required this.scrollController,
  });

  /// latest to earliest. if there are 7 states (0 the initial, then 1 through 6),
  /// then the first action (index 0 of the actions) is the delta between state 5 and 6.
  /// index 1 action is the delta between states 4 and 5,
  /// index 2 action is the delta between states 3 and 4,
  /// index 3 action is the delta between states 2 and 3,
  /// index 4 action is the delta between states 1 and 2,
  /// and index 5 is the delta between states 0 and 1
  final List<({GameStateDelta delta, GameState finalState})> data;

  /// deleting an actions at index i means going back i+1 times in the history, and reapplying all generated deltas except the last one
  final void Function(int pastIndex) onCancelAction;

  /// merging an action at index i means deleting a gamestate from history so that it is seen as skipped. the gamestate after it is unchanged so the new resulting delta incorporates two different actions in it
  /// merging action at index 0 means deleting the second to last gamestate, so that the resulting latest action incorporates changes from the latest two actions in one delta
  /// merging action at index 1 means deleting the third to last gamestate, so that the resulting second to latest action incorporates changes from the second to latest two actions in one delta
  /// and so on
  final void Function(int pastIndex) onMergeAction;

  final GameSettings gameSettings;
  final ScrollController scrollController;

  final double? rightMargin;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final theme = context.theme;
    final layout = theme.layout;
    final rightMargin = this.rightMargin ?? MyBody.historyMargin(layout);
    if (data.isEmpty) {
      return Pad(
        right: rightMargin,
        child: EmptyView(
          icon: Icon(BodyPage.history.outlinedIcon),
          title: const Text('No history yet'),
          description: const Text(
            'Take some game actions and come back here to check!',
          ),
        ),
      );
    }
    return AnimatedList(
      controller: scrollController,
      padding: EdgeInsets.only(left: layout.margin.medium, right: rightMargin),
      key: GameLogic.historyListKey,
      scrollDirection: Axis.horizontal,
      reverse: true,
      initialItemCount: data.length,
      physics: CallbackScrollPhysics(
        topBounce: true,
        topBounceCallback: () =>
            counterSpell.pagesLogic.bodyPage.update(BodyPage.life),
        alwaysScrollable: true,
      ),
      shrinkWrap: false,
      itemBuilder: (context, i, animation) => AnimatedActionColumn(
        finalGameState: data[i].finalState,
        action: data[i].delta,
        onDelete: () => onCancelAction(i),
        previous: i < data.length - 1
            ? (onMerge: () => onMergeAction(i), action: data[i + 1].delta)
            : null,
        animation: animation,
        index: i,
        gameSettings: gameSettings,
      ),
    );
  }
}
