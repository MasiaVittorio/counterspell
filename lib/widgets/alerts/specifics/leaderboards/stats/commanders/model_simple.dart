import 'package:counter_spell_new/core.dart';


class CommanderStats {

  //================================
  // Values
  final MtgCard card;

  final int wins;
  final int games;

  final int totalDamage;
  final int totalCasts;


  //================================
  // Getters
  double get winRate => games == 0 ? 0 : wins / games;

  /// average
  double get damage =>  games == 0 ? 0 : totalDamage / games;

  /// average
  double get casts =>  games == 0 ? 0 : totalCasts / games;

  //================================
  // Constructor(s)
  const CommanderStats(this.card, {
    required this.wins,
    required this.games,
    required this.totalDamage,
    required this.totalCasts,
  });

  factory CommanderStats.fromPastGames(MtgCard card, Iterable<PastGame?> pastGames){

    int present = 0;
    int winner = 0;
    int totalDamage = 0;
    int totalCasts = 0;

    for(final game in pastGames){
      if(game != null){
        if(game.winner != null && game.commanderPlayed(card)){
          ++present;
          if(game.commanderPlayedBy(card, game.winner)){
            ++winner;
          }

          final Set<String> pilots = game.whoPlayedCommander(card);

          //average from pilots of the same commander this single same game
          double averageDamageThisGame = 0.0; 
          for(final pilot in pilots){
            ///could have partnerA null and partnerB not null
            final bool partnerA = game.commandersA[pilot]?.oracleId == card.oracleId;
            averageDamageThisGame += game.state.totalDamageDealtFrom(pilot, partnerA: partnerA);
          }
          averageDamageThisGame = averageDamageThisGame / pilots.length;
          totalDamage += averageDamageThisGame.round();

          double averageCastsThisGame = 0.0; 
          for(final pilot in pilots){
            ///could have partnerA null and partnerB not null
            final bool partnerA = game.commandersA[pilot]?.oracleId == card.oracleId;
            averageCastsThisGame += game.state.players[pilot]!.states.last.cast.fromPartner(partnerA);
          }
          averageCastsThisGame = averageCastsThisGame / pilots.length;
          totalCasts += averageCastsThisGame.round();
        }
      }
    }

    return CommanderStats(card,
      wins: winner,
      games: present,
      totalDamage: totalDamage,
      totalCasts: totalCasts,
    );

  }

}
