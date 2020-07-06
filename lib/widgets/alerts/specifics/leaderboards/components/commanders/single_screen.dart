import 'model_advanced.dart';
import 'package:counter_spell_new/core.dart';

class CommanderStatsScreen extends StatelessWidget {

  final CommanderStatsAdvanced stat;

  const CommanderStatsScreen(this.stat);

  static const double height = 416.0;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlertCustom(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const AlertDrag(),
          CardTile(
            stat.card, 
            callback: (_){}, 
            autoClose: false,
            trailing: Text("(${stat.games} games)"),
          ),
        ],
      ),
      titleSize: 72.0 + AlertDrag.height, 
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Section(<Widget>[
          ListTile(
            title: const Text("Win rate"),
            trailing: Text("${(stat.winRate * 100).toStringAsFixed(1)}%"),
            leading: const Icon(McIcons.trophy),
          ),
          SubList("Per player", children: <Widget>[
            for(final entry in stat.perPlayerWinRates.entries)
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("${entry.key}: ${(entry.value * 100).toStringAsFixed(0)}%"),
                Text("(${stat.perPlayerGames[entry.key]} games)"),
              ],),
          ]),
          CSWidgets.height10,
        ]),

        Section(<Widget>[
          ListTile(
            title: const Text("Average damage"),
            trailing: Text("${(stat.damage).toStringAsFixed(1)}"),
            leading: const Icon(CSIcons.attackIconTwo),
          ),
          SubList("Per player", children: <Widget>[
            for(final entry in stat.perPlayerDamages.entries)
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("${entry.key}: ${(entry.value).toStringAsFixed(0)}"),
                Text("(${stat.perPlayerGames[entry.key]} games)"),
              ],)
          ]),
          CSWidgets.height10,
        ]),

      ],),
    );
  }
}