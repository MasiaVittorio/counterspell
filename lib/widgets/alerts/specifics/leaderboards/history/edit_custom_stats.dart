import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/leaderboards/all.dart';

class EditCustomStats extends StatelessWidget {
  static const double height = 500.0;

  final int index;

  const EditCustomStats({@required this.index});

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final logic = CSBloc.of(context);
    final listVar = logic.pastGames.pastGames;
    final titlesVar = logic.pastGames.customStatTitles;

    return titlesVar.build((_, titles) => listVar.build((_, list){
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

          for(final title in titles)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(children: [
                if(!CustomStat.all.contains(title))
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    color: CSColors.delete,
                    onPressed: () => stage.showAlert(
                      ConfirmAlert(
                        action: () => titlesVar.edit((s) => s.remove(title)),
                        warningText: "Delete $title stat?",
                        confirmColor: CSColors.delete,
                        confirmIcon: Icons.delete_forever,
                      ),
                      size: ConfirmAlert.height,
                    )
                  ),
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
                    isSelected: [for(final n in names) stats[title]?.contains(n) ?? false],
                    onPressed: (i){
                      final n = names[i];
                      listVar.value[index].customStats[title]
                        = listVar.value[index].customStats[title].toggled(n);
                      listVar.refresh();
                    },
                  ),
                ),),
              ],),
            ),

            ListTile(
              title: const Text("New"),
              leading: const Icon(Icons.add),
              onTap: () => stage.showAlert(
                InsertAlert(
                  labelText: "New custom stat",
                  onConfirm: (nT) => titlesVar.edit((sT) => sT.add(nT)),
                ),
                size: InsertAlert.height,
              ),
            ),

        ],),
      );
    },),);

  }
}

extension _SetToggle<E> on Set<E> {
  Set<E> toggled(E v) {
    if(this == null){
      return<E>{v};
    } else {
      if(this.contains(v)){
        return this..remove(v);
      } else {
        return this..add(v);
      }
    }
  } 

  // void toggle(E v) => contains(v) ? remove(v) : add(v);
}