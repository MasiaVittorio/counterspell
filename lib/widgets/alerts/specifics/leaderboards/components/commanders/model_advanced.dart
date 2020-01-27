import 'package:counter_spell_new/core.dart';
import 'model_simple.dart';

class CommanderStatsAdvanced extends CommanderStats {

  //================================
  // Values

  final Map<String,int> perPlayerWins;
  final Map<String,int> perPlayerTotalDamages;

  final Map<String,int> perPlayerGames;

  //================================
  // Getters
  Map<String,double> get perPlayerWinRates => <String,double>{
    for(final key in perPlayerGames.keys)
      key: perPlayerWins[key] / perPlayerGames[key],
  };

  //average
  Map<String,double> get perPlayerDamages => <String,double>{
    for(final key in perPlayerGames.keys)
      key: perPlayerTotalDamages[key] / perPlayerGames[key],
  };


  //================================
  // Constructor(s)
  const CommanderStatsAdvanced(MtgCard card, {
    @required int wins,
    @required int games,
    @required int totalDamage,
    @required this.perPlayerGames,
    @required this.perPlayerWins,
    @required this.perPlayerTotalDamages,
  }): super(
    card, 
    wins: wins, 
    games: games, 
    totalDamage: totalDamage,
  );


  factory CommanderStatsAdvanced.fromPastGames(CommanderStats simpleStats, Iterable<PastGame> pastGames){

    final Set<String> players = <String>{
      for(final PastGame game in pastGames)
        ...game.whoPlayedCommander(simpleStats.card),
    };

    final Map<String,int> wins = <String,int>{for(final player in players)
      player: 0,
    };
    final Map<String,int> totalDamages = <String,int>{for(final player in players)
      player: 0,
    };
    final Map<String,int> games = <String,int>{for(final player in players)
      player: 0,
    };


    for(final game in pastGames){
      for(final player in players){
        if(game.state.players.containsKey(player)){
          if(game.winner != null && game.commanderPlayedBy(simpleStats.card, player)){
            ++games[player];
            if(game.winner == player){
              ++wins[player];
            }
            final bool a = game.commandersA[player].oracleId == simpleStats.card.oracleId;
            totalDamages[player] += game.state.totalDamageDealtFrom(player, partnerA: a);
          }
        }
      }
    }

    return CommanderStatsAdvanced(simpleStats.card,
      wins: simpleStats.wins,
      games: simpleStats.games,
      perPlayerWins: wins,
      perPlayerGames: games,
      totalDamage: simpleStats.totalDamage,
      perPlayerTotalDamages: totalDamages, 
    );

  }

}
