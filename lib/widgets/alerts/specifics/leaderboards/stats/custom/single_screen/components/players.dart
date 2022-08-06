import 'package:counter_spell_new/core.dart';


class Players extends StatefulWidget {
  final CustomStat stat;

  const Players(this.stat);

  @override
  State createState() => _PlayersState();
}

class _PlayersState extends State<Players> {

  int absoluteIndex = 1; ///0 = relative

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context)!;
    final stat = widget.stat;
    final bool absolute = absoluteIndex == 1;
    final mapTotals = <String,int>{
      for(final e in logic.pastGames.playerStats.value.entries)
        e.key: e.value.games,
    };
    final list = [...stat.playersApplicable.entries]
      ..sort((e1, e2) => absolute
        ? e2.value.compareTo(e1.value)
        : (e2.value / mapTotals[e2.key]!).compareTo(e1.value / mapTotals[e1.key]!)
      );

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Section([Padding(
        padding: const EdgeInsets.only(top: PanelTitle.height),
        child: RadioSlider(
          title: const Text("Sort by"),
          hideOpenIcons: true,
          items: const [
            RadioSliderItem(title: Text("Relative"), icon: Text("Relative")),
            RadioSliderItem(title: Text("Overall"), icon: Text("Overall")),
          ],
          onTap: (i) => setState((){
            absoluteIndex = i;
          }),
          selectedIndex: absoluteIndex,
        ),
      ),],),
      Expanded(child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: Stage.of(context)!.panelScrollPhysics,
        itemBuilder: (_, i) => _Player(
          list[i].key,
          appearances: list[i].value,
          games: mapTotals[list[i].key],
        ),
        itemCount: list.length,
        itemExtent: _Player.height,
      ),),
    ],);
  }
}

class _Player extends StatelessWidget {

  static const double height = 82.0;
 
  final String player;
  final int? games;
  final int appearances;

  const _Player(this.player, {
    required this.appearances,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return SubSection([
      ListTile(
        title: Text(player),
        leading: const Icon(Icons.person_outline),
        subtitle: Text("${InfoDisplayer.getString(100*appearances/games!)}% of $games games"),
        trailing: Text("$appearances"),
      ),
    ],margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),);
  }
}



