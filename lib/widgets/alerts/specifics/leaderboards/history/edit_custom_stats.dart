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
    final gamesVar = logic.pastGames.pastGames;
    final titlesVar = logic.pastGames.customStatTitles;

    return titlesVar.build((_, titles) => gamesVar.build((_, games){
      final game = games[index];
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

        canvasBackground: true,
        titleSize: 72.0 + AlertDrag.height,

        child: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            for(final title in titles)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                      child: Text(title),
                    ),
                    ToggleButtons(
                      children: [for(final n in names) Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(n),
                      ),], 
                      isSelected: [for(final n in names) stats[title]?.contains(n) ?? false],
                      onPressed: (i){
                        final n = names[i];
                        gamesVar.value[index].customStats[title]
                          = gamesVar.value[index].customStats[title].toggled(n);
                        gamesVar.refresh();
                      },
                    ),
                    if(!CustomStat.all.contains(title))
                      IconButton(
                        icon: Icon(Icons.delete_forever),
                        color: CSColors.delete,
                        onPressed: () => stage.showAlert(
                          ConfirmAlert(
                            action: () => titlesVar.edit((s) => s.remove(title)),
                            warningText: 'Delete "$title" stats?',
                            confirmColor: CSColors.delete,
                            confirmIcon: Icons.delete_forever,
                          ),
                          size: ConfirmAlert.height,
                        )
                      ),
                  ],),
                ),
              ),

            CSWidgets.divider,
            CSWidgets.height10,

            SubSection([ListTile(
              title: const Text("New custom stat"),
              leading: const Icon(Icons.add),
              onTap: () => stage.showAlert(
                InsertAlert(
                  labelText: "New custom stat",
                  onConfirm: (nT) => titlesVar.edit((sT) => sT.add(nT)),
                ),
                size: InsertAlert.height,
              ),
            ),],),

            CSWidgets.height10,

            ConfirmableTile(
              subTitleBuilder: (_, pressed) => AnimatedText(pressed
                ? "Confirm?" : "(Only this game stats)" 
              ), 
              leading: const Icon(Icons.clear_all, color: CSColors.delete,),
              titleBuilder: (_,__) => const Text("Clear all"),
              onConfirm: (){
                for(final title in titles){
                  gamesVar.value[index].customStats[title] = <String>{};
                }
                gamesVar.refresh();
              },
            ),

          ],
        ),
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