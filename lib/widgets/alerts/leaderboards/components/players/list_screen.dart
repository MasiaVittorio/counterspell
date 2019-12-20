import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class PlayerStatsList extends StatelessWidget {

  const PlayerStatsList();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.playerStats.build((_, stats)
      => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final stat in stats)
            PlayerStatTile(stat, 
              pastGames: bloc.pastGames.pastGames.value,
            ),
        ],
      ),
    );
  }

}



