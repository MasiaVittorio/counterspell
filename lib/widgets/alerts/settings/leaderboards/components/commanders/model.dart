import 'package:counter_spell_new/core.dart';


class CommanderStats {

  //================================
  // Values
  final MtgCard card;

  final int wins;
  final int games;
  final Map<String,int> perPlayerWins;
  final Map<String,int> perPlayerGames;

  final int totalDamage;
  final Map<String,int> perPlayerTotalDamages;


  //================================
  // Getters
  double get winRate => wins / games;
  Map<String,double> get perPlayerWinRates => <String,double>{
    for(final key in perPlayerGames.keys)
      key: perPlayerWins[key] / perPlayerGames[key],
  };

  //average
  double get damage => totalDamage / games;
  Map<String,double> get perPlayerDamages => <String,double>{
    for(final key in perPlayerGames.keys)
      key: perPlayerTotalDamages[key] / perPlayerGames[key],
  };


  //================================
  // Constructor(s)
  const CommanderStats(this.card, {
    @required this.wins,
    @required this.games,
    @required this.perPlayerGames,
    @required this.perPlayerWins,
    @required this.totalDamage,
    @required this.perPlayerTotalDamages,
  });


  factory CommanderStats.fromPastGames(MtgCard card, Iterable<PastGame> pastGames){

    int present = 0;
    int winner = 0;

    int totalDamage = 0;

    final Set<String> players = CommanderStats.players(card, pastGames);
    final Map<String,int> presents = <String,int>{for(final player in players)
      player: 0,
    };
    final Map<String,int> winners = <String,int>{for(final player in players)
      player: 0,
    };

    final Map<String,int> totalDamages = <String,int>{for(final player in players)
      player: 0,
    };

    for(final game in pastGames){
      if(game.winner != null && game.commanderPlayed(card)){
        ++present;
        if(
          game.commandersA[game.winner]?.oracleId == card.oracleId
          ||
          game.commandersB[game.winner]?.oracleId == card.oracleId
        ){
          ++winner;
        }

        final String who = game.whoPlayedCommander(card);
        final bool a = game.commandersA[who].oracleId == card.oracleId;
        for(final defender in game.state.players.values){
          if(a){
            totalDamage += defender.states.last.damages[who].a;
          } else {
            totalDamage += defender.states.last.damages[who].b;
          }
        }
      }

      for(final player in players){
        if(game.state.players.containsKey(player)){
          if(game.winner != null && game.commanderPlayedBy(card, player)){
            ++presents[player];
            if(game.winner == player){
              ++winners[player];
            }
            final bool a = game.commandersA[player].oracleId == card.oracleId;
            for(final defender in game.state.players.values){
              if(a){
                totalDamages[player] += defender.states.last.damages[player].a;
              } else {
                totalDamages[player] += defender.states.last.damages[player].b;
              }
            }
          }
        }
      }
    }

    return CommanderStats(card,
      wins: winner,
      games: present,
      perPlayerWins: winners,
      perPlayerGames: presents,
      totalDamage: totalDamage,
      perPlayerTotalDamages: totalDamages, 
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
