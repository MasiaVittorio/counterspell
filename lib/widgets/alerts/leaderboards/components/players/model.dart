import 'package:counter_spell_new/core.dart';


class PlayerStats {

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
  const PlayerStats(this.name, {
    @required this.wins,
    @required this.games,
    @required this.perCommanderGames,
    @required this.perCommanderWins,

    @required this.commandersUsed,
  });


  factory PlayerStats.fromPastGames(String name, Iterable<PastGame> pastGames){

    int present = 0;
    int winner = 0;

    final Map<String,MtgCard> commanders = PlayerStats.allCommanders(name, pastGames);
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

    return PlayerStats(name,
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
