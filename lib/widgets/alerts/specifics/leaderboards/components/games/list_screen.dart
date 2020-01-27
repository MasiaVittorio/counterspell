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
          if(index == 0) return Container();
          final int gameIndex = pastGames.length - index;
          return PastGameTile(pastGames[gameIndex], gameIndex);
        },
        itemCount: pastGames.length + 1,
        itemExtent: PastGameTile.height,
      );
    });
  }

}
