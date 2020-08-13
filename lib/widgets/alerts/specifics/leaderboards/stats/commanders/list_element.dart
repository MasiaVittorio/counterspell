import 'model_advanced.dart';

import 'model_simple.dart';
import 'package:counter_spell_new/core.dart';
import 'single_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';

class CommanderStatWidget extends StatelessWidget {

  final CommanderStats stat;
  final List<PastGame> pastGames;
  final VoidCallback onSingleScreenCallback;

  static const double height = 186;
  //found by trial and error

  CommanderStatWidget(this.stat, {
    @required this.pastGames,
    @required this.onSingleScreenCallback,
  });

  @override
  Widget build(BuildContext context) {
    final VoidCallback onTap = () {
      onSingleScreenCallback?.call();
      Stage.of(context).showAlert(
        CommanderStatsScreen(CommanderStatsAdvanced.fromPastGames(
          stat, 
          pastGames,
        )),
        size: CommanderStatsScreen.height
      );
    };

    final theme = Theme.of(context);
    final pageColors = Stage.of(context).themeController.derived
        .mainPageToPrimaryColor.value;

    final logic = CSBloc.of(context);
    final imageSettings = logic.settings.imagesSettings;
    final imageUrl = stat.card.imageUrl();

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
            longPressOpenCard: false,
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
                  Expanded(child: InfoDisplayer(
                    title: const Text("Win rate"),
                    value: Text("${InfoDisplayer.getString(stat.winRate * 100)}%"),
                    detail: Text("(Overall: ${stat.wins})"),
                    background: const Icon(McIcons.trophy),
                    color: CSColors.gold,
                  ),),
                  CSWidgets.extraButtonsDivider,
                  Expanded(child: InfoDisplayer(
                    title: const Text("Damage"),
                    value: Text("${InfoDisplayer.getString(stat.damage)}"),
                    detail: const Text("(average)"),
                    background: const Icon(CSIcons.attackIconTwo),
                    color: pageColors[CSPage.commanderDamage],
                  ),),
                  CSWidgets.extraButtonsDivider,
                  Expanded(child: InfoDisplayer(
                    title: const Text("Casts"),
                    value: Text("${InfoDisplayer.getString(stat.casts)}"),
                    detail: const Text("(average)"),
                    background: const Icon(CSIcons.castIconFilled),
                    color: pageColors[CSPage.commanderCast],
                  ),),
                ],),
              ),
            ),
          ),

        ],
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          colorFilter: ColorFilter.mode(
            theme.canvasColor
              .withOpacity(0.7), 
            BlendMode.srcOver,
          ),
          alignment: Alignment(
            0.0, 
            imageSettings.imageAlignments
              .value[imageUrl] ?? 0.0,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


