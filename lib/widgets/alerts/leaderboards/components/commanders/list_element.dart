import 'model.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/resources/visible_pages.dart';


class StatWidget extends StatelessWidget {

  final CommanderStats stat;

  StatWidget(this.stat);

  @override
  Widget build(BuildContext context) {

    final Widget winRates = _Details(
      title: const Text("Win rate"),
      value: "${(stat.winRate * 100).toStringAsFixed(1)}%",
      icon: const Icon(McIcons.trophy),
      annotation: "(${stat.games} games)",
      children: <Widget>[
        for(final entry in stat.perPlayerWinRates.entries)
          ListTile(
            title: Text("${entry.key}"),
            subtitle: Text("${(entry.value * 100).toStringAsFixed(1)}%"),
            trailing: Text("(${stat.perPlayerGames[entry.key]} games)"),
          ),
      ],
    );

    final Widget damage = _Details(
      title: const Text("Damage"),
      value: "${(stat.damage).toStringAsFixed(1)}",
      icon: const Icon(CSIcons.attackIconTwo),
      annotation: "(${stat.games} games)",
      children: <Widget>[
        for(final entry in stat.perPlayerDamages.entries)
          ListTile(
            title: Text("${entry.key}"),
            subtitle: Text("${(entry.value).toStringAsFixed(1)}"),
            trailing: Text("(${stat.perPlayerGames[entry.key]} games)"),
          ),
      ],
    );

    return Section([
      CardTile(stat.card, callback: (_){}, autoClose: false,),
      VisiblePages(
        children: <Widget>[
          winRates,
          damage,
        ],
      ),
    ]);
  }
}

class _Details extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final String annotation;
  final String value;
  final List<Widget> children;

  _Details({
    @required this.icon,
    @required this.title,
    @required this.annotation,
    @required this.value,
    @required this.children,
  });

  static const double subsectionHeight = 130.0;

  @override
  Widget build(BuildContext context) {
    return SubSection([
      ListTile(
        title: title,
        subtitle: Text(value),
        leading: icon,
        trailing: Text(annotation),
      ),
      if(children.length > 1)...[
        CSWidgets.divider,
        const SectionTitle("Per player"),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: subsectionHeight),
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),),
        ),
      ]
    ]);
  }

}
