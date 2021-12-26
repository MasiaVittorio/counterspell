import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class PlayerStatsList extends StatelessWidget {

  const PlayerStatsList();

  @override
  Widget build(BuildContext context) {
    return _PlayersStatsLists(Stage.of(context));
  }
}

class _PlayersStatsLists extends StatefulWidget {

  const _PlayersStatsLists(this.stage);
  final StageData? stage;

  @override
  _PlayersStatsListsState createState() => _PlayersStatsListsState();
}

class _PlayersStatsListsState extends State<_PlayersStatsLists> {

  ScrollController? controller;

  static const key = "players leaderboards scroll controller position";

  @override
  void initState() {
    super.initState();
    var saved = widget.stage!.panelController
        .alertController.savedStates[key];
    controller = ScrollController(
      initialScrollOffset: ((saved is double) ? saved : null ) ?? 0.0,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;

    return bloc.pastGames.playerStats.build((_, map){
      final list = [...map.values]
        ..sort((one,two) => two.games.compareTo(one.games));
      return ListView.builder(
        controller: controller,
        physics: Stage.of(context)!.panelController.panelScrollPhysics(),
        itemBuilder: (_, index)
          => PlayerStatTile(list[index], 
            pastGames: bloc.pastGames.pastGames.value,
            //playerStats is updated whenever pastGames is updated
            //so it is safe to access that value brutally
            onSingleScreenCallback: (){
              widget.stage!.panelController.alertController.savedStates[key] = controller!.offset;
            },
          ),
        padding: const EdgeInsets.only(top: PanelTitle.height),
        itemCount: list.length,
        itemExtent: PlayerStatTile.height,
      );
    },
    );
  }

}



