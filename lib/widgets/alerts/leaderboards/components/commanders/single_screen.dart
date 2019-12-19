import 'model_advanced.dart';
import 'package:counter_spell_new/core.dart';

class CommanderStatsScreen extends StatelessWidget {

  final CommanderStatsAdvanced stat;

  const CommanderStatsScreen(this.stat);

  static const double height = 450.0;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlertCustom(
      CardTile(stat.card, callback: (_){}, autoClose: false,),
      titleSize: 56.0 + 16 + AlertDrag.height, 
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Section(<Widget>[
          ListTile(
            title: const Text("Win rate"),
            subtitle: Text("${(stat.winRate * 100).toStringAsFixed(1)}%"),
            leading: const Icon(McIcons.trophy),
            trailing: Text("(${stat.games} games)"),
          ),
          SubSection(<Widget>[
            const SectionTitle("Per player"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  for(final entry in stat.perPlayerWinRates.entries)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text("${entry.key}: ${(entry.value * 100).toStringAsFixed(0)}%"),
                        Text("(${stat.perPlayerGames[entry.key]} games)"),
                      ],),
                    ),
                ]),
              ),
            ),
          ], stretch: true,),
        ]),
        Section(<Widget>[
          ListTile(
            title: const Text("Average damage"),
            subtitle: Text("${(stat.damage).toStringAsFixed(1)}"),
            leading: const Icon(CSIcons.attackIconTwo),
            trailing: Text("(${stat.games} games)"),
          ),
          SubSection(<Widget>[
            const SectionTitle("Per player"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  for(final entry in stat.perPlayerDamages.entries)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text("${entry.key}: ${(entry.value).toStringAsFixed(0)}"),
                        Text("(${stat.perPlayerGames[entry.key]} games)"),
                      ],),
                    )
                ]),
              ),
            ),
          ], stretch: true,),
        ]),
      ],),
    );
  }
}