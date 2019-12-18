import 'package:counter_spell_new/core.dart';
import 'model.dart';


class PlayerStatTile extends StatelessWidget {

  final PlayerStats stat;

  PlayerStatTile(this.stat);

  static const double subsectionHeight = 140.0;

  @override
  Widget build(BuildContext context) {

    return Section([
      ListTile(
        title: Text("${stat.name}"),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(McIcons.trophy, size: 16),
            ),
            Text("Win rate: ${(stat.winRate * 100).toStringAsFixed(1)}%"),
          ],
        ),
        trailing: Text("(${stat.games} games)"),
      ),
      SubSection([
        const SectionTitle("Per commander"),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: subsectionHeight),
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for(final entry in stat.perCommanderWinRates.entries)
                CardTile(
                  stat.commandersUsed[entry.key], 
                  callback: (_){}, 
                  autoClose: false,
                  trailing: SidChip(
                    color: stat.commandersUsed[entry.key].singleBkgColor(),
                    // color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    text: "${(entry.value * 100).toStringAsFixed(0)}%",
                    icon: McIcons.trophy,
                    subText: "${stat.perCommanderGames[entry.key]} games",
                  ),
                ),
            ],
          ),),
        ),
      ]),
    ]);
  }
}

