import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/leaderboards/all.dart';

class EditCustomStats extends StatelessWidget {
  static const double height = 500.0;

  final int index;

  const EditCustomStats({@required this.index});

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final listVar = logic.pastGames.pastGames;

    return listVar.build((context, list){
      final game = list[index];
      final names = [...game.state.players.keys];
      final stats = game.customStats;

      return HeaderedAlertCustom(

        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const AlertDrag(),
            GameTimeTile(game, index: index, delete: false),
          ],
        ),

        titleSize: 72.0 + AlertDrag.height,

        child: Column(mainAxisSize: MainAxisSize.min, children: [

          for(final title in CustomStat.all)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                  child: Text(title),
                ),
                Expanded(child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ToggleButtons(
                    children: [for(final n in names) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(n),
                    ),], 
                    isSelected: [for(final n in names) stats[title].contains(n)],
                    onPressed: (i){
                      final n = names[i];
                      listVar.value[index].customStats[title].toggle(n);
                      listVar.refresh();
                    },
                  ),
                ),),
              ],),
            ),

        ]),
      );
    });

  }
}

extension _SetToggle<E> on Set<E> {
  void toggle(E v) => contains(v) ? remove(v) : add(v);
}