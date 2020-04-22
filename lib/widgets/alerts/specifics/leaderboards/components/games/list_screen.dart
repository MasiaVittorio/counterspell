import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class PastGamesList extends StatelessWidget {

  const PastGamesList();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_, pastGames){
      if(pastGames.isEmpty) return Container();

      return ListView.builder(
        physics: Stage.of(context).panelScrollPhysics(),
        itemBuilder: (_, index){
          final int gameIndex = pastGames.length - index - 1;
          return PastGameTile(pastGames[gameIndex], gameIndex);
        },
        padding: const EdgeInsets.only(top: AlertTitle.height),
        //TODO: questo padding dovrebbe essere inutile now
        itemCount: pastGames.length,
        itemExtent: PastGameTile.height,
      );
    });
  }

}
