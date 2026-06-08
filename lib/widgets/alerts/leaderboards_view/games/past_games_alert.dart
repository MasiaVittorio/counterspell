import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/games/past_game_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class PastGamesAlert extends StatelessWidget
    with PanelAlert, FullScreenPanelAlert {
  const PastGamesAlert({super.key, required this.timestamps});

  final Set<String> timestamps;

  @override
  Widget build(BuildContext context) {
    final gameRecords = context.counterSpell.leaderboardsLogic.gameRecords;
    final frame = context.panelFrame;

    return gameRecords.build((context, value) {
      final list = [
        for (int i = 0; i < value.length; i++)
          if (timestamps.contains(value[i].startTime.toIso8601String()))
            (game: value[i], gameIndex: i),
      ]..sort((a, b) => -a.game.startTime.compareTo(b.game.startTime));

      return PanelList.builder(
        title: Text('${list.length} past games'),
        bottom: CallToAction.danger.filled(
          action: () async {
            final result = await frame.showAlert(
              ConfirmPanelAlert.delete(
                title: Text('Delete ${list.length} past games?'),
              ),
            );
            if (result == true) {
              frame.previousAlert('removed');
              gameRecords.value.removeWhere(
                (record) =>
                    timestamps.contains(record.startTime.toIso8601String()),
              );
              gameRecords.refresh();
            }
          },
          label: const Text('Delete selected games'),
          icon: const Icon(Icons.delete_forever_outlined),
        ),
        itemCount: list.length,
        itemBuilder: (context, index) => PastGameTile(
          isFirst: index == 0,
          isLast: index == list.length - 1,
          game: list[index].game,
          gameIndex: list[index].gameIndex,
        ),
      );
    });
  }
}
