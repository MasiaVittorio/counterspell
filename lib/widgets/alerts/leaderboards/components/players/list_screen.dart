import 'model.dart';
import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class PlayerStatsList extends StatelessWidget {

  const PlayerStatsList();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_, pastGames){

      final stats = <PlayerStats>[
        for(final name in names(pastGames))
          PlayerStats.fromPastGames(name, pastGames),
      ];
      stats.sort((one,two) => (one.winRate - two.winRate).toInt());

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final stat in stats)
            PlayerStatTile(stat),
        ],
      );

    });
  }

  static Set<String> names(List<PastGame> pastGames) => <String>{
    for(final PastGame pastGame in pastGames)
      for(final name in pastGame.state.players.keys)
        name,
  };
}



