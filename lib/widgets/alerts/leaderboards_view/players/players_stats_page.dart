import 'package:counter_spell/models/leaderboards/games_stats.dart';
import 'package:counter_spell/models/leaderboards/player_stats.dart';
import 'package:counter_spell/models/leaderboards/win_rate.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/players/player_stats_alert.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class PlayersStatsPage extends StatefulWidget {
  const PlayersStatsPage({super.key, required this.stats});

  final GamesStats stats;

  @override
  State<PlayersStatsPage> createState() => _PlayersStatsPageState();
}

enum PlayerStatsSort {
  gamesPlayed,
  name,
  winRate;

  int compare(PlayerStats a, PlayerStats b) {
    switch (this) {
      case PlayerStatsSort.gamesPlayed:
        return a.records.length.compareTo(b.records.length);
      case PlayerStatsSort.winRate:
        return a.overallWinRate.winFraction.compareTo(
          b.overallWinRate.winFraction,
        );
      case PlayerStatsSort.name:
        return -a.name.compareTo(b.name);
    }
  }
}

class _PlayersStatsPageState extends State<PlayersStatsPage> {
  PlayerStatsSort sort = PlayerStatsSort.gamesPlayed;
  bool ascending = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final frame = context.panelFrame;
    final layout = theme.layout;

    final list = [...widget.stats.playerStats.values]
      ..sort((a, b) => sort.compare(a, b) * (ascending ? 1 : -1));

    final itemCount = list.length;

    return PanelList.builder(
      invisibleHeader: true,
      title: const Text(''),
      bottom: Row(
        children: [
          Expanded(
            child: ConnectedButtonGroup.single(
              connections: [
                const ButtonConnection(
                  value: PlayerStatsSort.gamesPlayed,
                  label: Text('Games'),
                ),
                const ButtonConnection(
                  value: PlayerStatsSort.winRate,
                  label: Text('Win rate'),
                ),
                const ButtonConnection(
                  value: PlayerStatsSort.name,
                  label: Text('Name'),
                ),
              ],
              selectedValue: sort,
              onSelect: (value) => setState(() => sort = value),
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => setState(() => ascending = !ascending),
            icon: AnimatedRotation(
              turns: ascending ? 0.5 : 0,
              duration: Durations.long1,
              curve: Motion.beginAndEndOnScreenEmphasized.curve,
              child: const Icon(Icons.swap_vert),
            ),
          ),
          Space.horizontal(layout.margin.medium),
        ],
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final value = list[index];
        return GroupedCard(
          isFirst: index == 0,
          isLast: index == itemCount - 1,
          child: ListTile(
            onTap: () =>
                frame.showAlert(PlayerStatsAlert(playerName: value.name)),
            title: Text(value.name),
            trailing: Text('${value.records.length} games'),
            subtitle: Text(
              'winrate: ${value.overallWinRate.formattedWinPercentage}',
            ),
          ),
        );
      },
    );
  }
}
