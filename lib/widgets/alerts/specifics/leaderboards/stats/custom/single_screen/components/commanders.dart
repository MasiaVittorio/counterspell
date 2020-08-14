import 'package:counter_spell_new/core.dart';


class Commanders extends StatefulWidget {
  final CustomStat stat;

  Commanders(this.stat);

  @override
  _CommandersState createState() => _CommandersState();
}

class _CommandersState extends State<Commanders> {

  int absoluteIndex = 1; ///0 = relative

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final stat = widget.stat;
    final bool absolute = absoluteIndex == 1;
    final mapStats = {
      for(final e in logic.pastGames.commanderStats.value.entries)
        e.key: e.value,
    };
    final list = [...stat.commandersApplicable.entries]
      ..sort((e1, e2) => absolute
        ? e2.value.compareTo(e1.value)
        : (e2.value / mapStats[e2.key].games).compareTo(e1.value / mapStats[e1.key].games)
      );

    return Column(children: [
      Section([Padding(
        padding: const EdgeInsets.only(top: PanelTitle.height),
        child: RadioSlider(
          title: Text("Sort by"),
          hideOpenIcons: true,
          items: [
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
        physics: Stage.of(context).panelScrollPhysics,
        itemBuilder: (_, i) => _Commander(
          mapStats[list[i].key].card,
          appearances: list[i].value,
          games: mapStats[list[i].key].games,
        ),
        itemCount: list.length,
        itemExtent: _Commander.height,
      ),),
    ],);
  }
}

class _Commander extends StatelessWidget {

  static const double height = 56.0 + 10;
 
  final MtgCard card;
  final int games;
  final int appearances;

  _Commander(this.card, {
    @required this.appearances,
    @required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return SubSection([
      ListTile(
        // TODO: image?
        title: Text(card.name),
        leading: Icon(CSIcons.damageIconOutlined),
        subtitle: Text("${InfoDisplayer.getString(100 * appearances/games)}% of $games games"),
        trailing: Text("$appearances"),
      ),
    ],);
  }
}




