import 'package:counter_spell_new/widgets/alerts/leaderboards/components/commanders/model_advanced.dart';

import 'model_simple.dart';
import 'package:counter_spell_new/core.dart';
import 'single_screen.dart';

class StatWidget extends StatelessWidget {

  final CommanderStats stat;
  final List<PastGame> pastGames;

  StatWidget(this.stat, {@required this.pastGames,});

  @override
  Widget build(BuildContext context) {

    return Section([
      CardTile(
        stat.card, 
        trailing: Text("(${stat.games} games)"),
        callback: (_){}, 
        autoClose: false,
      ),
      SubSection([
        ListTile(
          title: const Text("Win rate"),
          trailing: Text("${(stat.winRate * 100).toStringAsFixed(1)}%"),
          leading: const Icon(McIcons.trophy),
        ),
        ListTile(
          title: const Text("Damage"),
          trailing: Text("${(stat.damage).toStringAsFixed(1)}"),
          leading: const Icon(CSIcons.attackIconTwo),
        ),
      ]),
      BottomExtra(
        const Text("Per player details"), 
        onTap: () => Stage.of(context).showAlert(
          CommanderStatsScreen(CommanderStatsAdvanced.fromPastGames(
            stat, 
            pastGames,
          )),
          size: CommanderStatsScreen.height
        ),
      ),
    ]);
  }
}


