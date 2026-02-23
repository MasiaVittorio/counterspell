import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/core.dart';

import 'model_advanced.dart';

class PlayerStatScreen extends StatefulWidget {
  final PlayerStatsAdvanced stat;

  const PlayerStatScreen(this.stat, {super.key});

  static const height = 377.0;

  @override
  State createState() => _PlayerStatScreenState();
}

class _PlayerStatScreenState extends State<PlayerStatScreen> {
  String? opponent;
  late List<String?> opponents;

  int? groupSize;
  late List<int?> groupSizes;

  MtgCard? commander;
  late List<MtgCard?> commanders;

  @override
  void initState() {
    super.initState();
    commanders = <MtgCard?>[
      null,
      ...widget.stat.commanders,
    ];
    groupSizes = <int?>[
      null,
      ...widget.stat.groupSizes,
    ];
    opponents = <String?>[
      null,
      ...widget.stat.opponents,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final theme = Theme.of(context);
    final imageSettings = logic.settings.imagesSettings;

    final int totalGames = widget.stat.totalGamesFilter(
      opponent: opponent,
      commanderOracleId: commander?.oracleId,
      groupSize: groupSize,
    );

    final int totalWins = widget.stat.totalWinsFilter(
      opponent: opponent,
      commanderOracleId: commander?.oracleId,
      groupSize: groupSize,
    );

    final double winRate = widget.stat.winRateFilter(
      opponent: opponent,
      commanderOracleId: commander?.oracleId,
      groupSize: groupSize,
    );

    return HeaderedAlert(
      "${widget.stat.name}'s stats",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StageBuild.offMainColors(
            (_, __, colors) => Section(<Widget>[
              const SectionTitle("Stats"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(children: [
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
                      value: Text("${InfoDisplayer.getString(winRate * 100)}%"),
                      detail: Text("Overall wins: $totalWins"),
                      background: const Icon(McIcons.trophy),
                      color: CSColors.gold,
                    ),
                  ),
                ]),
              ),
            ]),
          ),
          Section(<Widget>[
            const SectionTitle("Filters"),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 6.0),
                  child: Text("Against:"),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      isSelected: [for (final o in opponents) opponent == o],
                      onPressed: (i) => setState(() {
                        opponent = opponents[i];
                      }),
                      children: [
                        for (final o in opponents)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(o ?? "-"),
                          )
                      ],
                    ),
                  ),
                )),
              ],
            ),
            CSWidgets.height5,
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 6.0),
                  child: Text("Piloting:"),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      isSelected: [
                        for (final c in commanders)
                          commander?.oracleId == c?.oracleId
                      ],
                      onPressed: (i) => setState(() {
                        commander = commanders[i];
                      }),
                      children: [
                        for (final c in commanders)
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: c != null
                                      ? BoxDecoration(
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                c.imageUrl()!),
                                            colorFilter: ColorFilter.mode(
                                              Color.alphaBlend(
                                                  theme.colorScheme.secondary
                                                      .withValues(
                                                          alpha: c.oracleId ==
                                                                  commander
                                                                      ?.oracleId
                                                              ? 0.2
                                                              : 0.0),
                                                  theme.canvasColor.withValues(
                                                      alpha: c.oracleId ==
                                                              commander
                                                                  ?.oracleId
                                                          ? 0.8
                                                          : 0.7)),
                                              BlendMode.srcOver,
                                            ),
                                            alignment: Alignment(
                                              0.0,
                                              imageSettings.imageAlignments
                                                      .value[c.imageUrl()] ??
                                                  0.0,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : null,
                                  child: Text(c == null
                                      ? "-"
                                      : safeSubString(
                                          untilSpaceOrComma(c.name),
                                          8,
                                        )),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                )),
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
                          for (final s in groupSizes) groupSize == s
                        ],
                        onPressed: (i) => setState(() {
                          groupSize = groupSizes[i];
                        }),
                        children: [
                          for (final s in groupSizes)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${s ?? "-"}"),
                            )
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

  static String safeSubString(String start, int len) {
    if (start.length > len) {
      return '${start.substring(0, len - 1)}.';
    } else {
      return start;
    }
  }

  static String untilSpaceOrComma(String from) {
    return from.split(" ").first.split(",").first;
  }
}
