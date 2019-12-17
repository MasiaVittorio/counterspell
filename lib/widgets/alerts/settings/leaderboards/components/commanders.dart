import 'package:counter_spell_new/core.dart';


class CommandersLeaderboards extends StatelessWidget {

  const CommandersLeaderboards();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_, pastGames){

      final stats = <_CommanderStats>[
        for(final card in cards(pastGames))
          _CommanderStats.fromPastGames(card, pastGames),
      ];

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final stat in stats)
            _StatWidget(stat),
        ],
      );

    });
  }

  static Iterable<MtgCard> cards(List<PastGame> pastGames){
    final Map<String,MtgCard> map = <String,MtgCard>{
      for(final PastGame pastGame in pastGames)
        for(final commander in <MtgCard>[
          ...pastGame.commandersA.values,
          ...pastGame.commandersB.values,
        ])
          if(commander != null) 
            commander.oracleId : commander,
    };

    return map.values;
  }
}



class _StatWidget extends StatelessWidget {

  final _CommanderStats stat;

  _StatWidget(this.stat);

  @override
  Widget build(BuildContext context) {
    return Section([
      CardTile(stat.card, callback: (_){},),
      CSWidgets.divider,
      ListTile(
        title: const Text("Win rate"),
        subtitle: Text("${stat.winRate}"),
        leading: const Icon(McIcons.trophy),
      ),
      CSWidgets.divider,
      const SectionTitle("Per player win rates"),
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 200.0),
        child: SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for(final entry in stat.perPlayerWinRates.entries)
              ListTile(
                title: Text("${entry.key}'s win rate"),
                subtitle: Text("${entry.value}"),
              ),
          ],
        )), 
      ),
    ]);
  }
}

class _CommanderStats {
  final MtgCard card;
  final double winRate;
  final Map<String,double> perPlayerWinRates;

  const _CommanderStats(this.card, {
    @required this.winRate,
    @required this.perPlayerWinRates,
  });

  factory _CommanderStats.fromPastGames(MtgCard card, Iterable<PastGame> pastGames){

    int present = 0;
    int winner = 0;

    final Set<String> players = _CommanderStats.players(card, pastGames);
    final Map<String,int> presents = <String,int>{for(final player in players)
      player: 0,
    };
    final Map<String,int> winners = <String,int>{for(final player in players)
      player: 0,
    };

    for(final game in pastGames){
      if(game.winner != null && game.commanderPlayed(card)){
        ++present;
        if(
          game.commandersA[game.winner].oracleId == card.oracleId
          ||
          game.commandersB[game.winner].oracleId == card.oracleId
        ){
          ++winner;
        }
      }

      for(final player in players){
        if(game.state.players.containsKey(player)){
          if(game.winner != null && game.commanderPlayedBy(card, player)){
            ++presents[player];
            if(game.winner == player){
              ++winners[player];
            }
          }
        }
      }
    }

    return _CommanderStats(card,
      winRate: winner / present,
      perPlayerWinRates: <String,double>{
        for(final player in players)
          player: winners[player] / presents[player],
      },
    );

  }

  static Set<String> players(MtgCard card, List<PastGame> pastGames) => <String>{
    for(final PastGame game in pastGames)
      for(final String player in game.state.players.keys)
        if(
          (game.commandersA[player]?.oracleId) == card.oracleId
          ||
          (game.commandersB[player]?.oracleId) == card.oracleId
        ) player,
  };

}
