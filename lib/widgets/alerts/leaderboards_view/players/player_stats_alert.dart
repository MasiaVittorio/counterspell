import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/leaderboards/games_stats.dart';
import 'package:counter_spell/models/leaderboards/player_record.dart';
import 'package:counter_spell/models/leaderboards/player_stats.dart';
import 'package:counter_spell/models/leaderboards/record.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/components/winrate_tile.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/games/past_games_alert.dart';
import 'package:counter_spell/widgets/components/builders/card_builder.dart';
import 'package:counter_spell/widgets/components/common/restore_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class PlayerStatsAlert extends StatelessWidget {
  const PlayerStatsAlert({super.key, required this.playerName});

  final String playerName;

  @override
  Widget build(BuildContext context) {
    final records = context.counterSpell.leaderboardsLogic.gameRecords;
    return records.build((context, value) {
      final stats = GamesStats(games: value).playerStats[playerName];
      if (stats == null) {
        return const AlternativesPanelAlert(
          title: Text('No data'),
          alternatives: [
            PanelAlternative(
              value: null,
              label: Text('Ok'),
              icon: Icon(Icons.keyboard_arrow_left),
            ),
          ],
        );
      }
      return _PlayerStatsAlert(stats: stats);
    });
  }
}

class _PlayerStatsAlert extends StatefulWidget {
  const _PlayerStatsAlert({required this.stats});

  final PlayerStats stats;

  @override
  State<_PlayerStatsAlert> createState() => _PlayerStatsAlertState();
}

class _PlayerStatsAlertState extends State<_PlayerStatsAlert> {
  int? playerCount;
  Set<String> commanders = {};
  Set<String> opponents = {};

  bool ignoreDraws = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final List<PlayerRecord> records = widget.stats.records.filter(
      filterByCommanders: commanders,
      filterByOpponents: opponents,
      filterByPlayerCount: playerCount,
      ignoreDraws: ignoreDraws,
    );
    final winRate = records.winRate();
    final frame = context.panelFrame;

    void openGames() async {
      final bool everything =
          opponents.isEmpty &&
          commanders.isEmpty &&
          playerCount == null &&
          !ignoreDraws;

      final result = await frame.showAlert(
        PastGamesAlert(timestamps: records.map((r) => r.timeStamp).toSet()),
      );
      if (result == 'removed') {
        if (everything) {
          frame.previousAlert();
          return;
        }
        if (!mounted) return;
        setState(() {
          commanders.clear();
          opponents.clear();
          playerCount = null;
          ignoreDraws = false;
        });
      }
    }

    void openDraws() => frame.showAlert(
      PastGamesAlert(
        timestamps: {
          for (final record in records)
            if (record.result == null) record.timeStamp,
        },
      ),
    );

    return PanelList.expand(
      title: Text('${widget.stats.name} (${records.length} games)'),
      bottom: CallToAction(
        action: openGames,
        label: Text('See ${records.length} games'),
        icon: const Icon(Icons.history_outlined),
      ),
      children: [
        SectionTitle(
          title: const Text('Filter by player count'),
          leading: const Icon(Icons.people_outline),
          trailing: IconButton.filledTonal(
            onPressed: playerCount == null ? null : clearPlayerCount,
            icon: const Icon(Icons.clear_all_outlined),
          ),
        ),
        RestoreScrollPhysics(
          child: ConnectedButtonGroup<int>.singleNullable(
            connections: [
              for (final value in widget.stats.playerCounts)
                ButtonConnection(
                  value: value,
                  label: Pad(
                    horizontal: layout.padding.huge,
                    child: Text(value.toString()),
                  ),
                ),
            ],
            selectedValue: playerCount,
            onSelect: onPlayerCountChanged,
            scrollable: true,
          ),
        ),
        SectionTitle(
          title: Text(
            'Filter by commander (${commanders.length} /${widget.stats.commanders.length})',
          ),
          leading: const Icon(CounterSpellIcons.cast_outlined),
          trailing: IconButton.filledTonal(
            onPressed: commanders.isEmpty ? null : clearCommanders,
            icon: const Icon(Icons.clear_all_outlined),
          ),
        ),
        RestoreScrollPhysics(
          child: ConnectedButtonGroup<String>(
            connections: [
              for (final value in widget.stats.commanders)
                ButtonConnection(
                  value: value,
                  label: CardBuilder(
                    id: value,
                    builder: (context, card, child) =>
                        Text(card?.name ?? '...'),
                  ),
                ),
            ],
            multiSelectionEnabled: true,
            emptySelectionAllowed: true,
            selectedValues: commanders,
            onSelectionChanged: onCommandersChanged,
            scrollable: true,
          ),
        ),
        SectionTitle(
          leading: const Icon(Icons.person_outline),
          title: Text(
            'Filter by opponent (${opponents.length} / ${widget.stats.opponents.length})',
          ),
          trailing: IconButton.filledTonal(
            onPressed: opponents.isEmpty ? null : clearOpponents,
            icon: const Icon(Icons.clear_all_outlined),
          ),
        ),
        RestoreScrollPhysics(
          child: ConnectedButtonGroup<String>(
            connections: [
              for (final value in widget.stats.opponents)
                ButtonConnection(value: value, label: Text(value)),
            ],
            multiSelectionEnabled: true,
            emptySelectionAllowed: true,
            selectedValues: opponents,
            onSelectionChanged: onOpponentsChanged,
            scrollable: true,
          ),
        ),
        Space.vertical(layout.spacing.medium),
        GroupedCard(
          isFirst: true,
          isLast: true,
          child: SwitchListTile(
            value: ignoreDraws,
            onChanged: onIgnoreDrawsChanged,
            title: const Text('Ignore draws'),
          ),
        ),
        Space.vertical(layout.spacing.medium),
        GroupedCard(isFirst: true, child: WinsTile(winRate: winRate)),
        GroupedCard(
          isLast: ignoreDraws,
          marginAnimationDuration: Durations.long2,
          child: LossesTile(winRate: winRate),
        ),
        AnimatedListed(
          listed: !ignoreDraws,
          child: GroupedCard(
            isLast: true,
            child: DrawsTile(
              winRate: winRate,
              onTap: winRate.draws == 0 ? null : openDraws,
            ),
          ),
        ),
      ],
    );
  }

  void onIgnoreDrawsChanged(bool value) => setState(() => ignoreDraws = value);

  void clearOpponents() => setState(() => opponents = {});

  void onOpponentsChanged(Set<String> value) =>
      setState(() => opponents = value);

  void onCommandersChanged(Set<String> value) =>
      setState(() => commanders = value);

  void clearCommanders() => setState(() => commanders = {});

  void onPlayerCountChanged(int? value) => setState(() => playerCount = value);

  void clearPlayerCount() => setState(() => playerCount = null);
}
