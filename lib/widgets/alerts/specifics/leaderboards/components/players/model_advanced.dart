import 'package:counter_spell_new/core.dart';
import 'model_simple.dart';

class PlayerStatsAdvanced extends PlayerStats {

  //================================
  // Values
  final Map<String,int> perCommanderWins;
  final Map<String,int> perCommanderGames;
  //oracleID => number

  final Map<String,MtgCard> commandersUsed;

  //================================
  // Getters
  Map<String,double> get perCommanderWinRates => <String,double>{
    for(final key in perCommanderGames.keys)
      key: perCommanderGames[key] == 0 ? 0.0 : perCommanderWins[key] / perCommanderGames[key],
  };


  //================================
  // Constructor(s)
  const PlayerStatsAdvanced(String name, {
    @required int wins,
    @required int games,
    @required this.perCommanderGames,
    @required this.perCommanderWins,

    @required this.commandersUsed,
  }): super(name, wins: wins, games: games);


  factory PlayerStatsAdvanced.fromPastGames(PlayerStats simple, Iterable<PastGame> pastGames){

    final Map<String,MtgCard> commandersUsed = <String,MtgCard>{};
    final Map<String,int> presents = <String,int>{};
    final Map<String,int> winners = <String,int>{};


    for(final game in pastGames){

      for(final commander in game.commandersPlayedBy(simple.name)){
        final String id = commander.oracleId;
        commandersUsed[id] = commander;
        presents[id] = presents[id] ?? 0;
        winners[id] = winners[id] ?? 0;

        if(game.winner != null){
          ++presents[id];
          if(game.winner == simple.name){
            ++winners[id];
          }
        }
        
      }

    }

    return PlayerStatsAdvanced(simple.name,
      wins: simple.wins,
      games: simple.games,
      perCommanderWins: winners,
      perCommanderGames: presents,
      commandersUsed: commandersUsed,
    );

  }

}
