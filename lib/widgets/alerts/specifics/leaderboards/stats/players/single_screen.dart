import 'model_advanced.dart';
import 'package:counter_spell_new/core.dart';


class PlayerStatScreen extends StatefulWidget {

  final PlayerStatsAdvanced stat;

  const PlayerStatScreen(this.stat);

  static const height = 377.0; 

  @override
  _PlayerStatScreenState createState() => _PlayerStatScreenState();
}

class _PlayerStatScreenState extends State<PlayerStatScreen> {

  String opponent;
  List<String> opponents;

  int groupSize;
  List<int> groupSizes;

  MtgCard commander;
  List<MtgCard> commanders;

  @override
  void initState() {
    super.initState();
    commanders = <MtgCard>[null, ...widget.stat.commanders,];
    groupSizes = <int>[null, ...widget.stat.groupSizes,];
    opponents = <String>[null, ...widget.stat.opponents,];
  }

  @override
  Widget build(BuildContext context) {

    final int totalGames = widget.stat.totalGamesFilter(
      opponent: opponent,
      commanderId: commander?.id,
      groupSize: groupSize,
    );

    final int totalWins = widget.stat.totalWinsFilter(
      opponent: opponent,
      commanderId: commander?.id,
      groupSize: groupSize,
    );

    final double winRate = widget.stat.winRateFilter(
      opponent: opponent,
      commanderId: commander?.id,
      groupSize: groupSize,
    );

    return HeaderedAlert(
      "${widget.stat.name}'s stats",
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        StageBuild.offMainColors((_, __, colors) => Section(<Widget>[
          const SectionTitle("Stats"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(children: [
              Expanded(child: InfoDisplayer(
                title: const Text("Games"),
                value: Text("$totalGames"),
                background: const Icon(McIcons.cards),
                detail: const Text("(Total)"),
              ),),
              CSWidgets.extraButtonsDivider,
              Expanded(child: InfoDisplayer(
                title: const Text("Win rate"),
                value: Text("${InfoDisplayer.getString(winRate * 100)}%"),
                detail: Text("Overall wins: $totalWins"),
                background: const Icon(McIcons.trophy),
                color: CSColors.gold,
              ),),
            ]),
          ),
          
        ]),),

        Section(<Widget>[
          const SectionTitle("Filters"),

          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 6.0),
              child: const Text("Against:"),
            ),
            Expanded(child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  children: [for(final o in opponents) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(o ?? "-"),
                  )],
                  isSelected: [for(final o in opponents) opponent == o],
                  onPressed: (i) => setState((){
                    opponent = opponents[i];
                  }),
                ),
              ),
            )),
          ],),

          CSWidgets.height5,

          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 6.0),
              child: const Text("Piloting:"),
            ),
            Expanded(child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  children: [for(final c in commanders) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(c == null ? "-" : safeSubString(
                      untilSpaceOrComma(c.name),
                      8,
                    )),
                  )],
                  isSelected: [for(final c in commanders) commander?.id == c?.id],
                  onPressed: (i) => setState((){
                    commander = commanders[i];
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
                  children: [for(final s in groupSizes) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${s ?? "-"}"),
                  )],
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

  static String safeSubString(String start, int len){
    if(start.length >  len) return start.substring(0,len-1)+'.';
    else return start; 
  }

  static String untilSpaceOrComma(String from){
    return from.split(" ").first.split(",").first;
  }


}

