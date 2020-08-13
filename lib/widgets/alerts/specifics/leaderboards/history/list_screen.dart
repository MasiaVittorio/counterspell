import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class PastGamesList extends StatelessWidget {

  const PastGamesList();

  @override
  Widget build(BuildContext context) {
    return _PastGamesList(Stage.of(context));
  }
}

class _PastGamesList extends StatefulWidget {

  const _PastGamesList(this.stage);
  final StageData stage;

  @override
  _PastGamesListState createState() => _PastGamesListState();
}

class _PastGamesListState extends State<_PastGamesList> {

  ScrollController controller;

  static const key = "history of games leaderboards scroll controller position";

  @override
  void initState() {
    super.initState();
    var saved = widget.stage.panelController
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
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_, pastGames){
      if(pastGames.isEmpty) return Container();

      return ListView.builder(
        controller: controller,
        physics: Stage.of(context).panelController.panelScrollPhysics(),
        itemBuilder: (_, index){
          final int gameIndex = pastGames.length - index - 1;
          return PastGameTile(
            pastGames[gameIndex], 
            gameIndex,
            onSingleScreenCallback: (){
              widget.stage.panelController.alertController
                .savedStates[key] = controller.offset;
            },
          );
        },
        itemCount: pastGames.length,
        itemExtent: PastGameTile.height,
      );
    });
  }

}
