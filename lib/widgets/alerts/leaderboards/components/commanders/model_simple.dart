import 'package:counter_spell_new/core.dart';


class CommanderStats {

  //================================
  // Values
  final MtgCard card;

  final int wins;
  final int games;

  final int totalDamage;


  //================================
  // Getters
  double get winRate => wins / games;

  //average
  double get damage => totalDamage / games;

  //================================
  // Constructor(s)
  const CommanderStats(this.card, {
    @required this.wins,
    @required this.games,
    @required this.totalDamage,
  });

  factory CommanderStats.fromPastGames(MtgCard card, Iterable<PastGame> pastGames){

    int present = 0;
    int winner = 0;
    int totalDamage = 0;

    for(final game in pastGames){
      if(game.winner != null && game.commanderPlayed(card)){
        ++present;
        if(game.commanderPlayedBy(card, game.winner)){
          ++winner;
        }

        final Set<String> pilots = game.whoPlayedCommander(card);
        double average = 0.0;
        for(final pilot in pilots){
          final bool partnerA = game.commandersA[pilot].oracleId == card.oracleId;
          average += game.state.totalDamageDealtFrom(pilot, partnerA: partnerA);
        }
        average = average / pilots.length;
        totalDamage += average.round();
      }

    }

    return CommanderStats(card,
      wins: winner,
      games: present,
      totalDamage: totalDamage,
    );

  }

}
