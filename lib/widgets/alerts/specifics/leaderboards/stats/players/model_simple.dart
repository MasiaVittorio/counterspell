import 'package:counter_spell_new/core.dart';


class PlayerStats {

  //================================
  // Values
  final String name;

  final int wins;
  final int games;

  //================================
  // Getters
  double get winRate => games == 0 ? 0.0 : wins / games;


  //================================
  // Constructor(s)
  const PlayerStats(this.name, {
    @required this.wins,
    @required this.games,
  });


  factory PlayerStats.fromPastGames(String name, Iterable<PastGame> pastGames){

    int present = 0;
    int winner = 0;

    for(final game in pastGames){

      if(game.winner != null && game.state.players.containsKey(name)){
        ++present;
        if(game.winner == name){
          ++winner;
        }
      }

    }

    return PlayerStats(name,
      wins: winner,
      games: present,
    );

  }


}
