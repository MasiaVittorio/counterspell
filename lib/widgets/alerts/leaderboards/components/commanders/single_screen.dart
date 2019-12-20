import 'package:counter_spell_new/widgets/alerts/leaderboards/components/components/sub_list.dart';

import 'model_advanced.dart';
import 'package:counter_spell_new/core.dart';

class CommanderStatsScreen extends StatelessWidget {

  final CommanderStatsAdvanced stat;

  const CommanderStatsScreen(this.stat);

  static const double height = 478.0;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlertCustom(
      CardTile(
        stat.card, 
        callback: (_){}, 
        autoClose: false,
        trailing: Text("(${stat.games} games)"),
      ),
      titleSize: 56.0 + 16 + AlertDrag.height, 
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        SizedBox(height: 14.0,),
        Section(<Widget>[
          ListTile(
            title: const Text("Win rate"),
            trailing: Text("${(stat.winRate * 100).toStringAsFixed(1)}%"),
            leading: const Icon(McIcons.trophy),
          ),
          SubList("PerPlayer", children: <Widget>[
            for(final entry in stat.perPlayerWinRates.entries)
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("${entry.key}: ${(entry.value * 100).toStringAsFixed(0)}%"),
                Text("(${stat.perPlayerGames[entry.key]} games)"),
              ],),
          ]),
          const SizedBox(height: 10,),
        ]),

        Section(<Widget>[
          ListTile(
            title: const Text("Average damage"),
            trailing: Text("${(stat.damage).toStringAsFixed(1)}"),
            leading: const Icon(CSIcons.attackIconTwo),
          ),
          SubList("PerPlayer", children: <Widget>[
            for(final entry in stat.perPlayerDamages.entries)
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("${entry.key}: ${(entry.value).toStringAsFixed(0)}"),
                Text("(${stat.perPlayerGames[entry.key]} games)"),
              ],)
          ]),
          const SizedBox(height: 10,),
        ]),

      ],),
    );
  }
}