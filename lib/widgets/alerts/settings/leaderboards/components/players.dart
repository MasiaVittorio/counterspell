import 'package:counter_spell_new/core.dart';

class PlayersLeaderboards extends StatelessWidget {

  const PlayersLeaderboards();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_, pastGames){

      final stats = <_PlayerStats>[
        for(final name in names(pastGames))
          _PlayerStats.fromPastGames(name, pastGames),
      ];
      stats.sort((one,two) => (one.winRate - two.winRate).toInt());

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final stat in stats)
            _StatWidget(stat),
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



class _StatWidget extends StatelessWidget {

  final _PlayerStats stat;

  _StatWidget(this.stat);

  static const double subsectionHeight = 140.0;

  @override
  Widget build(BuildContext context) {

    return Section([
      ListTile(
        title: Text("${stat.name}"),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(McIcons.trophy, size: 16),
            ),
            Text("Win rate: ${(stat.winRate * 100).toStringAsFixed(1)}%"),
          ],
        ),
        trailing: Text("(${stat.games} games)"),
      ),
      SubSection([
        const SectionTitle("Per commander"),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: subsectionHeight),
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for(final entry in stat.perCommanderWinRates.entries)
                CardTile(
                  stat.commandersUsed[entry.key], 
                  callback: (_){}, 
                  autoClose: false,
                  trailing: SidChip(
                    color: stat.commandersUsed[entry.key].singleBkgColor(),
                    // color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    text: "${(entry.value * 100).toStringAsFixed(0)}%",
                    icon: McIcons.trophy,
                    subText: "${stat.perCommanderGames[entry.key]} games",
                  ),
                ),
            ],
          ),),
        ),
      ]),
    ]);
  }
}


class _PlayerStats {

  //================================
  // Values
  final String name;

  final int wins;
  final int games;
  final Map<String,int> perCommanderWins;
  final Map<String,int> perCommanderGames;
  //oracleID => number

  final Map<String,MtgCard> commandersUsed;
  //oracleID => card


  //================================
  // Getters
  double get winRate => wins / games;
  Map<String,double> get perCommanderWinRates => <String,double>{
    for(final key in perCommanderGames.keys)
      key: perCommanderWins[key] / perCommanderGames[key],
  };


  //================================
  // Constructor(s)
  const _PlayerStats(this.name, {
    @required this.wins,
    @required this.games,
    @required this.perCommanderGames,
    @required this.perCommanderWins,

    @required this.commandersUsed,
  });


  factory _PlayerStats.fromPastGames(String name, Iterable<PastGame> pastGames){

    int present = 0;
    int winner = 0;

    final Map<String,MtgCard> commanders = _PlayerStats.allCommanders(name, pastGames);
    final Map<String,int> presents = <String,int>{for(final commander in commanders.keys)
      commander: 0,
    };
    final Map<String,int> winners = <String,int>{for(final commander in commanders.keys)
      commander: 0,
    };


    for(final game in pastGames){

      if(game.winner != null && game.state.players.containsKey(name)){
        ++present;
        if(game.winner == name){
          ++winner;
        }
      }

      for(final entry in commanders.entries){
        if(game.commanderPlayed(entry.value)){
          if(game.winner != null && game.state.players.containsKey(name)){
            ++presents[entry.key];
            if(game.winner == name){
              ++winners[entry.key];
            }
          }
        }
      }
    }

    return _PlayerStats(name,
      wins: winner,
      games: present,
      perCommanderWins: winners,
      perCommanderGames: presents,
      commandersUsed: commanders,
    );

  }

  static Map<String,MtgCard> allCommanders(String player, List<PastGame> pastGames) => <String,MtgCard>{
    for(final PastGame game in pastGames)
      ...{
        if(game.commandersA[player] != null)
          game.commandersA[player].oracleId: game.commandersA[player],
        if(game.commandersB[player] != null)
          game.commandersB[player].oracleId: game.commandersB[player]
      }
  };

}
