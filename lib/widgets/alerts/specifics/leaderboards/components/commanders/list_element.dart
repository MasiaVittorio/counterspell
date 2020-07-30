import 'model_advanced.dart';

import 'model_simple.dart';
import 'package:counter_spell_new/core.dart';
import 'single_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';

class CommanderStatWidget extends StatelessWidget {

  final CommanderStats stat;
  final List<PastGame> pastGames;

  static const double height = 198;
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

    final theme = Theme.of(context);

    return SizedBox(
      height: CommanderStatWidget.height,
      child: Section(
        <Widget>[
          CardTile(
            stat.card, 
            withoutImage: true,
            trailing: Text("(${stat.games} games)"),
            callback: (_) => onTap(), 
            autoClose: false,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: theme.canvasColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: theme.scaffoldBackgroundColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onTap, 
                child: Row(children: <Widget>[
                  Expanded(child: ListTile(
                    subtitle: Text("${stat.wins} wins"),
                    title: Text("${(stat.winRate * 100).toStringAsFixed(1)}%"),
                    leading: const Icon(McIcons.trophy),
                  ),),
                  CSWidgets.extraButtonsDivider,
                  Expanded(child: ListTile(
                    subtitle: const Text("(average)", style: TextStyle(fontStyle: FontStyle.italic),),
                    title: Text("${(stat.damage).toStringAsFixed(1)} dmg"),
                    leading: const Icon(CSIcons.attackIconTwo),
                  ),),
                ],),
              ),
            ),
          ),
          BottomExtra(
            const Text("Per player details"), 
            onTap: onTap,
            icon: Icons.keyboard_arrow_right,
          ),
        ], 
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            stat.card.imageUrl(),
          ),
          colorFilter: ColorFilter.mode(
            theme.canvasColor
              .withOpacity(0.7), 
            BlendMode.srcOver,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


