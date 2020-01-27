import 'model_advanced.dart';

import 'model_simple.dart';
import 'package:counter_spell_new/core.dart';
import 'single_screen.dart';

class CommanderStatWidget extends StatelessWidget {

  final CommanderStats stat;
  final List<PastGame> pastGames;

  static const double height = 238;
  //found by trial and error

  CommanderStatWidget(this.stat, {@required this.pastGames,});

  @override
  Widget build(BuildContext context) {
    final VoidCallback onTap = () => Stage.of(context).showAlert(
      CommanderStatsScreen(CommanderStatsAdvanced.fromPastGames(
        stat, 
        pastGames,
      )),
      size: CommanderStatsScreen.height
    );

    return SizedBox(
      height: CommanderStatWidget.height,
      child: Section([
        CardTile(
          stat.card, 
          trailing: Text("(${stat.games} games)"),
          callback: (_) => onTap(), 
          autoClose: false,
        ),
        SubSection([
          ListTile(
            title: Text("Wins: ${stat.wins}"),
            trailing: Text("${(stat.winRate * 100).toStringAsFixed(1)}%"),
            leading: const Icon(McIcons.trophy),
          ),
          ListTile(
            title: const Text("Average damage"),
            trailing: Text("${(stat.damage).toStringAsFixed(1)}"),
            leading: const Icon(CSIcons.attackIconTwo),
          ),
        ], onTap: onTap,),
        BottomExtra(
          const Text("Per player details"), 
          onTap: onTap,
        ),
      ]),
    );
  }
}


