import 'package:counter_spell/core.dart';

class Commanders extends StatefulWidget {
  final CustomStat stat;

  const Commanders(this.stat, {super.key});

  @override
  State createState() => _CommandersState();
}

class _CommandersState extends State<Commanders> {
  int absoluteIndex = 1;

  ///0 = relative

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final stat = widget.stat;
    final bool absolute = absoluteIndex == 1;
    final mapStats = {
      for (final e in logic.pastGames.commanderStats.value.entries)
        e.key: e.value,
    };
    final list = [...stat.commandersApplicable.entries]..sort((e1, e2) =>
        absolute
            ? e2.value.compareTo(e1.value)
            : (e2.value / mapStats[e2.key!]!.games)
                .compareTo(e1.value / mapStats[e1.key!]!.games));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Section(
          [
            Padding(
              padding: const EdgeInsets.only(top: PanelTitle.height),
              child: RadioSlider(
                title: const Text("Sort by"),
                hideOpenIcons: true,
                items: const [
                  RadioSliderItem(
                      title: Text("Relative"), icon: Text("Relative")),
                  RadioSliderItem(
                      title: Text("Overall"), icon: Text("Overall")),
                ],
                onTap: (i) => setState(() {
                  absoluteIndex = i;
                }),
                selectedIndex: absoluteIndex,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: Stage.of(context)!.panelScrollPhysics,
            itemBuilder: (_, i) => _Commander(
              mapStats[list[i].key!]!.card,
              appearances: list[i].value,
              games: mapStats[list[i].key!]!.games,
            ),
            itemCount: list.length,
            itemExtent: _Commander.height,
          ),
        ),
      ],
    );
  }
}

// TODO: mini stats gratis da mostrare quando non hai ancora sbloccato tutto

class _Commander extends StatelessWidget {
  static const double height = 82.0;

  final MtgCard card;
  final int games;
  final int appearances;

  const _Commander(
    this.card, {
    required this.appearances,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return SubSection(
      [
        ListTile(
          title: Text(card.name),
          leading: const Icon(CSIcons.damageOutlined),
          subtitle: Text(
              "${InfoDisplayer.getString(100 * appearances / games)}% of $games games"),
          trailing: Text("$appearances"),
        ),
      ],
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    );
  }
}
