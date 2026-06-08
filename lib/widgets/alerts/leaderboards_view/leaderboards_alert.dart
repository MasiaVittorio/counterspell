import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/leaderboards/game_record.dart';
import 'package:counter_spell/models/leaderboards/games_stats.dart';
import 'package:counter_spell/widgets/alerts/game_edit_alert/leaderboards_info_alert.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/commanders/commanders_stats_page.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/games/past_games_page.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/players/players_stats_page.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class LeaderboardsAlert extends StatelessWidget
    with PanelAlert, FullScreenPanelAlert {
  const LeaderboardsAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return context.counterSpell.leaderboardsLogic.gameRecords.build(
      (context, games) => _LeaderboardsAlert(
        stats: GamesStats(games: games),
        games: games,
      ),
    );
  }
}

class _LeaderboardsAlert extends StatefulWidget {
  const _LeaderboardsAlert({required this.stats, required this.games});

  final GamesStats stats;
  final List<GameRecord> games;

  @override
  State<_LeaderboardsAlert> createState() => _LeaderboardsAlertState();
}

class _LeaderboardsAlertState extends State<_LeaderboardsAlert> {
  LeaderboardsPage page = LeaderboardsPage.games;

  @override
  Widget build(BuildContext context) {
    return PanelList.custom(
      title: AnimatedText(page.longTitle(widget.stats)),
      trailing: IconButton.filledTonal(
        onPressed: () {
          context.panelFrame.showAlert(const LeaderboardsInfoAlert());
        },
        icon: const Icon(Icons.info_outline),
      ),
      customBuilder: (context, invisibleHeader, _) {
        return Column(
          children: [
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: AnimatedPagedView(
                  value: page,
                  pages: [
                    for (final page in LeaderboardsPage.values)
                      ViewPage(
                        child: page.child(
                          widget.games,
                          widget.stats,
                          invisibleHeader,
                        ),
                        value: page,
                      ),
                  ],
                ),
              ),
            ),
            HorizontalNavigationBar<LeaderboardsPage>(
              value: page,
              onChanged: (value) => setState(() => page = value),
              items: [
                for (final page in LeaderboardsPage.values) page.navigationItem,
              ],
            ),
          ],
        );
      },
    );
  }
}

enum LeaderboardsPage {
  players(
    'Players',
    '[N] players',
    '1 player',
    'Zero players',
    Icons.people_outline,
    Icons.people,
  ),
  games(
    'Games',
    '[N] past games',
    '1 past game',
    'Zero past games',
    Icons.history_outlined,
    Icons.history,
  ),
  commanders(
    'Commanders',
    '[N] commanders',
    '1 commander',
    'Zero commanders',
    CounterSpellIcons.cast_outlined,
    CounterSpellIcons.cast_filled,
  );

  final String shortTitle;
  final String longTitlePlural;
  final String longTitleSingular;
  final String longTitleZero;
  final IconData outlinedIcon;
  final IconData filledIcon;

  HorizontalNavigationItem<LeaderboardsPage> get navigationItem =>
      HorizontalNavigationItem<LeaderboardsPage>(
        value: this,
        label: Text(shortTitle),
        selectedIcon: Icon(filledIcon),
        unselectedIcon: Icon(outlinedIcon),
      );

  Widget child(
    List<GameRecord> games,
    GamesStats stats,
    Widget invisibleHeader,
  ) => switch (this) {
    LeaderboardsPage.players => PlayersStatsPage(stats: stats),
    LeaderboardsPage.games => PastGamesPage(games: games),
    LeaderboardsPage.commanders => CommandersStatsPage(stats: stats),
  };

  String longTitle(GamesStats stats) {
    final count = switch (this) {
      LeaderboardsPage.players => stats.playerStats.length,
      LeaderboardsPage.commanders => stats.commanderStats.length,
      LeaderboardsPage.games => stats.games.length,
    };

    if (count == 0) return longTitleZero;
    if (count == 1) return longTitleSingular;
    return longTitlePlural.replaceAll('[N]', '$count');
  }

  const LeaderboardsPage(
    this.shortTitle,
    this.longTitlePlural,
    this.longTitleSingular,
    this.longTitleZero,
    this.outlinedIcon,
    this.filledIcon,
  );
}
