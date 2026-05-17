import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/models/leaderboards/commander_stats.dart';
import 'package:counter_spell/models/leaderboards/games_stats.dart';
import 'package:counter_spell/models/leaderboards/win_rate.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/commanders/commander_stats_alert.dart';
import 'package:counter_spell/widgets/components/builders/card_builder.dart';
import 'package:counter_spell/widgets/components/project/artist_row.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CommandersStatsPage extends StatefulWidget {
  const CommandersStatsPage({super.key, required this.stats});

  final GamesStats stats;

  @override
  State<CommandersStatsPage> createState() => _CommandersStatsPageState();
}

enum CommanderStatsSort {
  gamesPlayed,
  winRate,
  casts,
  damage;

  int compare(CommanderStats a, CommanderStats b) {
    switch (this) {
      case CommanderStatsSort.gamesPlayed:
        return a.records.length.compareTo(b.records.length);
      case CommanderStatsSort.winRate:
        return a.overallWinRate.winFraction.compareTo(
          b.overallWinRate.winFraction,
        );
      case CommanderStatsSort.casts:
        return a.overallAverageCasts.compareTo(b.overallAverageCasts);
      case CommanderStatsSort.damage:
        return a.overallAverageDamage.compareTo(b.overallAverageDamage);
    }
  }
}

class _CommandersStatsPageState extends State<CommandersStatsPage> {
  CommanderStatsSort sort = CommanderStatsSort.gamesPlayed;
  bool ascending = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final frame = context.panelFrame;

    final list = [...widget.stats.commanderStats.values]
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
                  value: CommanderStatsSort.gamesPlayed,
                  label: Text('Games'),
                ),
                const ButtonConnection(
                  value: CommanderStatsSort.winRate,
                  label: Text('Win rate'),
                ),
                const ButtonConnection(
                  value: CommanderStatsSort.casts,
                  label: Text('Casts'),
                ),
                const ButtonConnection(
                  value: CommanderStatsSort.damage,
                  label: Text('Damage'),
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
          child: CardBuilder.advanced(
            id: value.id,
            advancedBuilder: (context, card, isLoading, error, child) => ListTile(
              onTap: () => frame.showAlert(CommanderStatsAlert(id: value.id)),
              title: Text(card?.name ?? (error ?? '...')),
              trailing: Text(switch (sort) {
                CommanderStatsSort.gamesPlayed =>
                  '${value.records.length} games',
                CommanderStatsSort.winRate =>
                  'winrate: ${value.overallWinRate.formattedWinPercentage}',
                CommanderStatsSort.casts =>
                  'avg casts: ${value.overallAverageCasts.toStringAsFixed(2)}',
                CommanderStatsSort.damage =>
                  'avg dmg: ${value.overallAverageDamage.toStringAsFixed(2)}',
              }),
              subtitle: card == null ? null : ArtistRow(card: card),
              leading: switch (card?.imageUrl()) {
                null => null,
                final String url => CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(url),
                ),
              },
            ),
          ),
        );
      },
    );
  }
}
