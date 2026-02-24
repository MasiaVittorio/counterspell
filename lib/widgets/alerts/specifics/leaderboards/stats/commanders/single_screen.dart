import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/game/image_search/components/card_tile.dart';

import 'model_advanced.dart';

class CommanderStatsScreen extends StatefulWidget {
  final CommanderStatsAdvanced stat;

  const CommanderStatsScreen(this.stat, {super.key});

  static const double height = 462;

  @override
  State createState() => _CommanderStatsScreenState();
}

class _CommanderStatsScreenState extends State<CommanderStatsScreen> {
  bool? filtering;

  String? pilot;
  int? groupSize;
  late List<String?> pilots;
  late List<int?> groupSizes;

  @override
  void initState() {
    super.initState();
    pilots = [null, ...widget.stat.pilots];
    groupSizes = [null, ...widget.stat.groupSizes];
  }

  @override
  Widget build(BuildContext context) {
    final int totalGames = widget.stat.totalGamesFilter(
      pilot: pilot,
      groupSize: groupSize,
    );

    final double winRate = widget.stat.winRateFilter(
      pilot: pilot,
      groupSize: groupSize,
    );

    final double averageDamage = widget.stat.averageDamageFilter(
      pilot: pilot,
      groupSize: groupSize,
    );

    final double averageCasts = widget.stat.averageCastsFilter(
      pilot: pilot,
      groupSize: groupSize,
    );

    final int totalDamage = (averageDamage * totalGames).round();

    final int totalCasts = (averageCasts * totalGames).round();

    final int totalWins = (winRate * totalGames).round();

    return HeaderedAlertCustom(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const AlertDrag(),
          CardTile(widget.stat.card, tapOpenCard: true, autoClose: false),
        ],
      ),
      titleSize: 72.0 + AlertDrag.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StageBuild.offMainColors(
            (_, _, colors) => Section(<Widget>[
              const SectionTitle("Stats"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InfoDisplayer(
                        title: const Text("Games"),
                        value: Text("$totalGames"),
                        background: const Icon(McIcons.cards),
                        detail: const Text("(Total)"),
                      ),
                    ),
                    CSWidgets.extraButtonsDivider,
                    Expanded(
                      child: InfoDisplayer(
                        title: const Text("Win rate"),
                        value: Text(
                          "${InfoDisplayer.getString(winRate * 100)}%",
                        ),
                        detail: Text("Overall wins: $totalWins"),
                        background: const Icon(McIcons.trophy),
                        color: CSColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 6.0,
                  right: 6.0,
                  bottom: 6.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InfoDisplayer(
                        title: const Text("Avg damage"),
                        background: const Icon(CSIcons.attackTwo),
                        value: Text(InfoDisplayer.getString(averageDamage)),
                        detail: Text("Overall: $totalDamage"),
                        color: colors![CSPage.commanderDamage],
                        fill: true,
                      ),
                    ),
                    Expanded(
                      child: InfoDisplayer(
                        title: const Text("Avg casts"),
                        background: const Icon(CSIcons.castFilled),
                        value: Text(InfoDisplayer.getString(averageCasts)),
                        detail: Text("Overall: $totalCasts"),
                        color: colors[CSPage.commanderCast],
                        fill: true,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Section(<Widget>[
            const SectionTitle("Filters"),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 6.0),
                  child: Text("Pilots:"),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ToggleButtons(
                        isSelected: [for (final p in pilots) pilot == p],
                        onPressed: (i) => setState(() {
                          pilot = pilots[i];
                        }),
                        children: [
                          for (final p in pilots)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(p ?? "-"),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CSWidgets.height5,
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 6.0),
                  child: Text("Group size:"),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ToggleButtons(
                        isSelected: [
                          for (final s in groupSizes) groupSize == s,
                        ],
                        onPressed: (i) => setState(() {
                          groupSize = groupSizes[i];
                        }),
                        children: [
                          for (final s in groupSizes)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${s ?? "-"}"),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CSWidgets.height5,
          ], last: true),
        ],
      ),
    );
  }
}
