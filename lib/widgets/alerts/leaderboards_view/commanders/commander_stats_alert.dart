import 'package:cached_network_image/cached_network_image.dart';
import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/leaderboards/commander_record.dart';
import 'package:counter_spell/models/leaderboards/commander_stats.dart';
import 'package:counter_spell/models/leaderboards/games_stats.dart';
import 'package:counter_spell/models/leaderboards/record.dart';
import 'package:counter_spell/widgets/alerts/image_search/components/card_tile.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/components/winrate_tile.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/games/past_games_alert.dart';
import 'package:counter_spell/widgets/components/builders/card_builder.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:counter_spell/widgets/components/common/restore_scroll_physics.dart';
import 'package:counter_spell/widgets/components/project/artist_row.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CommanderStatsAlert extends StatelessWidget {
  const CommanderStatsAlert({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final records = context.counterSpell.leaderboardsLogic.gameRecords;
    return records.build((context, value) {
      final stats = GamesStats(games: value).commanderStats[id];
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
      return _CommanderStatsAlert(stats: stats);
    });
  }
}

class _CommanderStatsAlert extends StatefulWidget {
  const _CommanderStatsAlert({required this.stats});

  final CommanderStats stats;

  @override
  State<_CommanderStatsAlert> createState() => _CommanderStatsAlertState();
}

class _CommanderStatsAlertState extends State<_CommanderStatsAlert> {
  int? playerCount;
  String? pilot;

  bool ignoreDraws = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final List<CommanderRecord> records = widget.stats.records.filter(
      filterByPlayerCount: playerCount,
      filterByPilot: pilot,
      ignoreDraws: ignoreDraws,
    );
    final winRate = records.winRate();
    final frame = context.panelFrame;

    void openGames() async {
      final everything = pilot == null && playerCount == null && !ignoreDraws;
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
          pilot = null;
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

    final totalCasts = records.map((e) => e.casts).sum();
    final totalDamage = records.map((e) => e.damage).sum();

    return PanelList.expand(
      title: CardBuilder(
        id: widget.stats.id,
        builder: (context, card, child) =>
            Text('${card?.name ?? '??'} (${records.length} games)'),
      ),
      bottom: CallToAction(
        action: openGames,
        label: Text('See ${records.length} games'),
        icon: const Icon(Icons.history_outlined),
      ),
      children: [
        CardBuilder.advanced(
          id: widget.stats.id,
          advancedBuilder: (context, card, loading, error, child) =>
              switch (card?.imageUrl()) {
                String url => Pad(
                  horizontal: layout.margin.medium,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          layout.radius.large,
                        ),
                        child: InkResponse(
                          onTap: () =>
                              context.panelFrame.showAlert(CardAlert(card!)),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Space.vertical(layout.spacing.smaller),
                      Pad(
                        horizontal: layout.margin.smaller,
                        child: ArtistRow(card: card!),
                      ),
                      Space.vertical(layout.spacing.small),
                    ],
                  ),
                ),
                null =>
                  loading
                      ? const SizedBox(
                          height: 150,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink(),
              },
        ),
        SectionTitle(
          title: const Text('Filter by player count'),
          leading: const Icon(Icons.people_outline),
          trailing: IconButton.filledTonal(
            onPressed: playerCount == null
                ? null
                : () => setState(() => playerCount = null),
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
            onSelect: (int? value) => setState(() => playerCount = value),
            scrollable: true,
          ),
        ),
        SectionTitle(
          title: Text(
            'Filter by pilot (${pilot == null ? '0' : '1'} /${widget.stats.pilots.length})',
          ),
          leading: const Icon(CounterSpellIcons.cast_outlined),
          trailing: IconButton.filledTonal(
            onPressed: pilot == null
                ? null
                : () => setState(() => pilot = null),
            icon: const Icon(Icons.clear_all_outlined),
          ),
        ),
        RestoreScrollPhysics(
          child: ConnectedButtonGroup<String>.singleNullable(
            connections: [
              for (final value in widget.stats.pilots)
                ButtonConnection(value: value, label: Text(value)),
            ],
            selectedValue: pilot,
            onSelect: (value) => setState(() => pilot = value),
            scrollable: true,
          ),
        ),
        Space.vertical(layout.spacing.medium),
        GroupedCard(
          isFirst: true,
          isLast: true,
          child: SwitchListTile(
            value: ignoreDraws,
            onChanged: (value) => setState(() => ignoreDraws = value),
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
        GroupedCard(
          isLast: false,
          isFirst: true,
          child: ColoredTile(
            title: const Text('Average casts'),
            leading: const Icon(CounterSpellIcons.cast_filled),
            subtitle: Text(
              records.isEmpty
                  ? 'N/A'
                  : (totalCasts / records.length).toStringAsFixed(1),
            ),
            trailing: Text('$totalCasts total'),
            containTrailing: false,
          ),
        ),
        GroupedCard(
          isLast: true,
          isFirst: false,
          child: ColoredTile(
            title: const Text('Average damage dealt'),
            leading: const Icon(CounterSpellIcons.attack),
            subtitle: Text(
              records.isEmpty
                  ? 'N/A'
                  : (totalDamage / records.length).toStringAsFixed(1),
            ),
            trailing: Text('$totalDamage total'),
            containTrailing: false,
          ),
        ),
      ],
    );
  }
}
