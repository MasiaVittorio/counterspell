import 'package:counter_spell_new/core.dart';
import 'all.dart';
import 'model_advanced.dart';
import 'model_simple.dart';


class PlayerStatTile extends StatelessWidget {

  final PlayerStats stat;
  final List<PastGame> pastGames;

  PlayerStatTile(this.stat, {@required this.pastGames});

  static const double height = 166.0;
  // static const double subsectionHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    final VoidCallback onTap = () => Stage.of(context).showAlert(
      PlayerStatScreen(PlayerStatsAdvanced.fromPastGames(stat, pastGames)),
      size: PlayerStatScreen.height,
    );

    return Section([
      ListTile(
        leading: const Icon(Icons.person_outline),
        title: Text("${stat.name}"),
        trailing: Text("${stat.games} games"),
        onTap: onTap,
      ),
      SubSection([
        ListTile(
          leading: const Icon(McIcons.trophy),
          title: Text("Wins: ${stat.wins}"),
          trailing: Text("${(stat.winRate * 100).toStringAsFixed(1)}%"),
        ),
      ], onTap: onTap,),
      BottomExtra(
        const Text("Per commander details"), 
        onTap: onTap,
        icon: Icons.keyboard_arrow_right,
      ),
    ]);
  }
}

