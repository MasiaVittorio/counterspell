import 'model_advanced.dart';
import 'package:counter_spell_new/core.dart';

class CommanderStatsScreen extends StatefulWidget {

  final CommanderStatsAdvanced stat;

  const CommanderStatsScreen(this.stat);

  static const double height = 458;

  @override
  _CommanderStatsScreenState createState() => _CommanderStatsScreenState();
}

class _CommanderStatsScreenState extends State<CommanderStatsScreen> {

  bool filtering;

  String pilot;
  int groupSize;
  List<String> pilots;
  List<int> groupSizes;

  @override
  void initState(){
    super.initState();
    pilots = [
      null,
      ...widget.stat.pilots,
    ];
    groupSizes = [
      null,
      ...widget.stat.groupSizes,
    ];
  }

  @override
  Widget build(BuildContext context) {

    final int totalGames = widget.stat.totalGamesFilter(
      pilot: pilot,
      groupSize: groupSize,
    );

    final double winRate = widget.stat.winRateFilter(
      pilot: pilot,
      groupSize: groupSize,
    );

    final double averageDamage = widget.stat.averageDamageFilter(
      pilot: pilot,
      groupSize: groupSize,
    );
    
    final double averageCasts = widget.stat.averageCastsFilter(
      pilot: pilot,
      groupSize: groupSize,
    );

    final int totalDamage = (averageDamage * totalGames).round();

    final int totalCasts = (averageCasts * totalGames).round();

    final int totalWins = (winRate * totalGames).round();

    return HeaderedAlertCustom(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const AlertDrag(),
          CardTile(
            widget.stat.card, 
            callback: (_){}, 
            autoClose: false,
            trailing: Text("($totalGames games)"),
          ),
        ],
      ),
      titleSize: 72.0 + AlertDrag.height, 
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[

        StageBuild.offMainColors((_, __, colors) => Section(<Widget>[
          const SectionTitle("Stats"),
          Row(children: [
            Expanded(child: InfoDisplayer(
              title: const Text("Total games"),
              value: Text("$totalGames"),
              background: const Icon(McIcons.cards),
            ),),
            CSWidgets.extraButtonsDivider,
            Expanded(child: InfoDisplayer(
              title: const Text("Win rate"),
              value: Text("${getString(winRate * 100)}%"),
              detail: Text("Total wins: $totalWins"),
              background: const Icon(McIcons.trophy),
            ),),
          ]),
          
          CSWidgets.divider,
          Row(children: [
            Expanded(child: InfoDisplayer(
              title: const Text("Avg damage"), 
              background: const Icon(CSIcons.attackIconTwo), 
              value: Text("${getString(averageDamage)}"),
              detail: Text("Total: $totalDamage"),
              color: colors[CSPage.commanderDamage],
            ),),
            CSWidgets.extraButtonsDivider,
            Expanded(child: InfoDisplayer(
              title: const Text("Avg casts"), 
              background: const Icon(CSIcons.castIconFilled), 
              value: Text("${getString(averageCasts)}"),
              detail: Text("Total: $totalCasts"),
              color: colors[CSPage.commanderCast],
            ),),
          ],),
        ]),),

        Section(<Widget>[
          const SectionTitle("Filters"),
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 6.0),
              child: const Text("Pilots:"),
            ),
            Expanded(child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  children: [for(final p in pilots) Text(p ?? "-")],
                  isSelected: [for(final p in pilots) pilot == p],
                  onPressed: (i) => setState((){
                    pilot = pilots[i];
                  }),
                ),
              ),
            )),
          ],),
          CSWidgets.height5,
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 6.0),
              child: const Text("Group size:"),
            ),
            Expanded(child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  children: [for(final s in groupSizes) Text("${s ?? "-"}")],
                  isSelected: [for(final s in groupSizes) groupSize == s],
                  onPressed: (i) => setState((){
                    groupSize = groupSizes[i];
                  }),
                  ),
              ),
            ),),
          ],),
          CSWidgets.height5,
        ], last: true),

      ],),
    );

  }

  static String getString(double val){
    final ret = val.toStringAsFixed(1);
    List split = ret.split("");
    if(split.last == "0"){
      split.removeLast();
      split.removeLast();
      return split.join();
    }

    return ret;
  }
}


class InfoDisplayer extends StatelessWidget {

  final Widget title;
  final Widget background;
  final Widget value;
  final Widget detail;
  final Color color;

  const InfoDisplayer({
    @required this.title,
    @required this.background,
    @required this.value,
    this.detail,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = color?.brightness == Theme.of(context).brightness 
      ? null 
      : color;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(height: 80, child: Stack(
        alignment: Alignment.center, 
        children: [

          Positioned.fill(child: Center(child: IconTheme.merge(
            data: IconThemeData(
              color: color,
              opacity: 0.12,
              size: 60,
            ),
            child: background,
          ),),),

          Positioned.fill(child: Center(child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 30,
              color: textColor,
            ),
            child: value,
          ),),),

          Positioned(
            top: 0.0,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: 15,
                color: textColor,
              ),
              child: title,
            ),
          ),

          if(detail != null)
          Positioned(
            bottom: 0.0,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: 13,
              ),
              child: detail,
            ),
          ),

        ],
      ),),
    );
  }
}