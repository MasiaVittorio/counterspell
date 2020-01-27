import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class PlayerStatsList extends StatelessWidget {

  const PlayerStatsList();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.playerStats.build((_, stats)
      => ListView.builder(
        physics: Stage.of(context).panelScrollPhysics(),
        itemBuilder: (_, index){
          if(index == 0) return Container();
          return PlayerStatTile(stats[index - 1], 
            pastGames: bloc.pastGames.pastGames.value,
            //playerStats is updated whenever pastGames is updated
            //so it is safe to access that value brutally
          );
        },
        itemCount: stats.length + 1,
        itemExtent: PlayerStatTile.height,
      ),
    );
  }

}



