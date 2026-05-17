// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_spell/models/leaderboards/game_record.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/games/past_game_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class PastGamesPage extends StatelessWidget {
  const PastGamesPage({super.key, required this.games});

  final List<GameRecord> games;

  @override
  Widget build(BuildContext context) {
    final list = [
      for (int i = 0; i < games.length; i++) (game: games[i], index: i),
    ]..sort((a, b) => -a.game.startTime.compareTo(b.game.startTime));

    return PanelList.builder(
      invisibleHeader: true,
      title: const Text(''),
      itemCount: list.length,
      itemBuilder: (context, index) => PastGameTile(
        game: list[index].game,
        gameIndex: list[index].index,
        isFirst: index == 0,
        isLast: index == list.length - 1,
      ),
    );
  }
}
