import 'package:counter_spell/core.dart';

import 'all.dart';
import 'model_advanced.dart';
import 'model_simple.dart';

class PlayerStatTile extends StatelessWidget {
  final PlayerStats stat;
  final List<PastGame?> pastGames;
  final VoidCallback onSingleScreenCallback;

  const PlayerStatTile(
    this.stat, {super.key, 
    required this.pastGames,
    required this.onSingleScreenCallback,
  });

  static const double height = 142.0;
  // static const double subsectionHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    void onTap() {
      onSingleScreenCallback.call();
      Stage.of(context)!.showAlert(
        PlayerStatScreen(PlayerStatsAdvanced.fromPastGames(stat, pastGames)),
        size: PlayerStatScreen.height,
      );
    }

    return Section([
      SectionTitle(stat.name),
      SubSection(
        [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(children: [
              Expanded(
                child: InfoDisplayer(
                  title: const Text("Games"),
                  value: Text("${stat.games}"),
                  background: const Icon(McIcons.cards),
                  detail: const Text("(Total)"),
                ),
              ),
              CSWidgets.extraButtonsDivider,
              Expanded(
                child: InfoDisplayer(
                  title: const Text("Win rate"),
                  value:
                      Text("${InfoDisplayer.getString(stat.winRate * 100)}%"),
                  detail: Text("Overall: ${stat.wins}"),
                  background: const Icon(McIcons.trophy),
                  color: CSColors.gold,
                ),
              ),
            ]),
          ),
        ],
        onTap: onTap,
      ),
    ]);
  }
}
