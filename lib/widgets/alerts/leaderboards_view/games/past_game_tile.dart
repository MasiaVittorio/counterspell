// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/leaderboards/game_record.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/games/past_game_alert.dart';
import 'package:counter_spell/widgets/alerts/winner_picker/winner_picker.dart';
import 'package:counter_spell/widgets/components/common/my_chip.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:scrollable_card/scrollable_card.dart';
import 'package:sid_base/sid_base.dart';

class PastGameTile extends StatelessWidget {
  const PastGameTile({
    super.key,
    required this.game,
    required this.isFirst,
    required this.isLast,
    required this.gameIndex,
  });

  final int gameIndex;
  final GameRecord game;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final frame = context.panelFrame;
    final variable = context.counterSpell.leaderboardsLogic.gameRecords;

    void changeWinner() => frame.showAlert(
      WinnerPicker(
        initialIndex: game.winner,
        names: [for (final p in game.settings.playerSettings) p.name],
        includeDontSaveOption: false,
        onSubmit: (winnerIndex) {
          switch (winnerIndex) {
            case -1: // draw
              variable.value[gameIndex] = game.copyWithoutWinner();
              variable.refresh();
              return;
            case int winnerIndex:
              if (winnerIndex >= 0 &&
                  winnerIndex < game.settings.playerSettings.length) {
                variable.value[gameIndex] = game.copyWith(winner: winnerIndex);
                variable.refresh();
              }
            default:
          }
        },
      ),
    );

    void promptDelete() => frame.showAlert(
      ConfirmPanelAlert.delete(
        title: const Text('Delete this game record?'),
        content: const Text('This action cannot be undone.'),
        onConfirmed: () {
          variable.value.removeAt(gameIndex);
          variable.refresh();
        },
      ),
    );

    void onOpen() => frame.showAlert(PastGameAlert(gameIndex: gameIndex));

    return ScrollableCard(
      margin:
          EdgeInsets.symmetric(horizontal: layout.margin.medium) +
          EdgeInsets.only(
            bottom: GroupedCard.bottomMargin(context: context, isLast: isLast),
          ),
      scrolledMargin: EdgeInsets.only(
        bottom: layout.spacing.small,
        top: isFirst
            ? 0
            : layout.spacing.small -
                  GroupedCard.bottomMargin(context: context, isLast: false),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: GroupedCard.borderRadius(
          layout,
          isFirst: isFirst,
          isLast: isLast,
        ),
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      builder: (context, scrollFromRight, scrollFromLeft) => ListTile(
        onTap: onOpen,
        subtitle: GamePlayersWrap(game: game),
        title: GameDateTitle(game: game),
      ),

      fromRightBuilder: (context, unscroll) => Row(
        children: [
          for (final action in [
            (child: const Icon(Icons.edit_outlined), onTap: changeWinner),
            (
              child: Icon(
                Icons.delete_forever_outlined,
                color: theme.colorScheme.error,
              ),
              onTap: promptDelete,
            ),
          ])
            Expanded(
              child: InkWell(
                onTap: () {
                  unscroll();
                  action.onTap();
                },
                child: Center(child: action.child),
              ),
            ),
        ],
      ),
    );
  }
}

class GamePlayersWrap extends StatelessWidget {
  const GamePlayersWrap({super.key, required this.game});

  final GameRecord game;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final players = [
      for (int i = 0; i < game.settings.playerSettings.length; i++)
        (settings: game.settings.playerSettings[i], realIndex: i),
    ]..sort((a, b) => a.settings.name.compareTo(b.settings.name));

    return Wrap(
      spacing: layout.spacing.medium,
      runSpacing: layout.spacing.medium,
      children: [
        for (final player in players)
          MyChip(
            label: player.settings.name,
            onPressed: null,
            selected: game.winner == player.realIndex,
            icon: player.realIndex == game.winner ? Icons.emoji_events : null,
          ),
      ],
    );
  }
}

class GameDateTitle extends StatelessWidget {
  const GameDateTitle({super.key, required this.game});

  final GameRecord game;

  @override
  Widget build(BuildContext context) {
    final bool sameYear = DateTime.now().year == game.startTime.year;
    return Text(
      game.startTime.format("${sameYear ? '' : 'yyyy '}MMMM dd - HH:mm"),
    );
  }
}
