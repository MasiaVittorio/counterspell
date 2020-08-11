import 'package:counter_spell_new/core.dart';
import 'model_simple.dart';

class CommanderGame {

  /// multiple players may be playing the same commander
  final Map<String,int> damage;
  final Map<String,int> casts;
  final String winner;
  final int groupSize;

  const CommanderGame({
    @required this.groupSize,
    @required this.winner,
    @required this.damage,
    @required this.casts,
  });

  Set<String> get pilots => {
    ...damage.keys,
  };

  bool get won => damage.containsKey(winner);
  bool wonByPilot(String pilot) => (pilot == null) ? won : (pilot == winner);

  int get averageDamage {
    double avg = 0.0;
    for(final val in damage.values){
      avg += val;
    } 
    return (avg / damage.length).round();
  }  
  int get averageCasts {
    double avg = 0.0;
    for(final val in casts.values){
      avg += val;
    } 
    return (avg / casts.length).round();
  }

  int damageByPilot(String pilot) => pilot == null ? averageDamage : damage[pilot];
  int castsByPilot(String pilot) => pilot == null ? averageCasts : casts[pilot];

}


class CommanderStatsAdvanced extends CommanderStats {

  //================================
  // Values

  final List<CommanderGame> commanderGames;
  final Set<String> pilots;
  final Set<int> groupSizes;

  //================================
  // Getters

  int totalGamesFilter({
    String pilot,
    int groupSize,
  }) => (pilot == null && groupSize == null) 
    ? super.games 
    : _totalFilter(
      pilot: pilot,
      groupSize: groupSize,
      stat: (game) => 1,
    );
  
  int _totalFilter({
    String pilot,
    int groupSize,
    @required int Function(CommanderGame) stat,
  }){
    int val = 0;
    for(final game in this.commanderGames)
      if(pilot == null || game.pilots.contains(pilot))
        if(groupSize == null || game.groupSize == groupSize){
          val += stat(game);
        }
    return val;
  }

  double averageCastsFilter({
    String pilot,
    int groupSize,
  }) => (pilot == null && groupSize == null) 
    ? super.casts 
    : _averageFilter(
    pilot: pilot,
    groupSize: groupSize,
    stat: (game) => game.castsByPilot(pilot),
  );

  double winRateFilter({
    String pilot,
    int groupSize,
  }) => (pilot == null && groupSize == null) 
    ? super.winRate 
    : _averageFilter(
    pilot: pilot,
    groupSize: groupSize,
    stat: (game) => game.wonByPilot(pilot) ? 1 : 0,
  );

  double averageDamageFilter({
    String pilot,
    int groupSize,
  }) => (pilot == null && groupSize == null) 
    ? super.damage 
    : _averageFilter(
      pilot: pilot,
      groupSize: groupSize,
      stat: (game) => game.damageByPilot(pilot),
    );

  double _averageFilter({
    String pilot,
    int groupSize,
    @required num Function(CommanderGame) stat,
  }){
    double val = 0.0;
    int len = 0;
    for(final game in this.commanderGames)
      if(pilot == null || game.pilots.contains(pilot))
        if(groupSize == null || game.groupSize == groupSize){
          val += stat(game);
          ++len;
        }
    return len == 0 ? 0 : val/len;
  }


  //================================
  // Constructor(s)
  const CommanderStatsAdvanced(MtgCard card, {
    @required int wins,
    @required int games,
    @required int totalDamage,
    @required int totalCasts,
    @required this.commanderGames,
    @required this.groupSizes,
    @required this.pilots,
  }): super(
    card, 
    wins: wins, 
    games: games, 
    totalDamage: totalDamage,
    totalCasts: totalCasts,
  );



  factory CommanderStatsAdvanced.fromPastGames(
    CommanderStats simpleStats, 
    Iterable<PastGame> pastGames,
  ) {
    final _games = <CommanderGame>[
      for(final game in pastGames)
        if(game.winner != null)
        if(game.commanderPlayed(simpleStats.card))
          ((){
            final pilots = game.whoPlayedCommander(simpleStats.card);
            return CommanderGame(
              winner: game.winner,
              groupSize: game.state.players.length,
              casts: <String,int>{
                for(final player in pilots)
                  player: game.state.players[player].states.last.cast.fromPartner(
                    game.commandersA[player].id == simpleStats.card.id,
                  ),
              }, 
              damage: <String,int>{
                for(final player in pilots)
                  player: game.state.totalDamageDealtFrom(
                    player, 
                    partnerA: game.commandersA[player].id == simpleStats.card.id,
                  ),
              },
            );
          })(),
    ];

    return CommanderStatsAdvanced(simpleStats.card,
      wins: simpleStats.wins,
      games: simpleStats.games,
      totalDamage: simpleStats.totalDamage,
      totalCasts: simpleStats.totalCasts,
      commanderGames: _games,
      groupSizes: <int>{
        for(final g in _games)
          g.groupSize,
      },
      pilots: <String>{
        for(final g in _games)
          ...g.pilots,
      },
    );
  }

}
