import 'package:counter_spell_new/core.dart';
import 'model_simple.dart';


class PlayerGame {

  final bool won;
  final Set<String> opponents;
  final int groupSize;
  final Set<String?> commandersOracleIds;

  const PlayerGame({
    required this.groupSize,
    required this.won,
    required this.opponents,
    required this.commandersOracleIds,
  });

  bool playedCommander(String oracleIds) => commandersOracleIds.contains(oracleIds);
  bool playedWith(String opponent) => opponents.contains(opponent);
}


class PlayerStatsAdvanced extends PlayerStats {

  //================================
  // Values

  final List<PlayerGame> playerGames;
  final Set<String> opponents;
  final Set<MtgCard> commanders;
  final Set<int> groupSizes;

  //================================
  // Getters

  int totalGamesFilter({
    String? commanderOracleId,
    String? opponent,
    int? groupSize,
  }) => (commanderOracleId == null && opponent == null && groupSize == null) 
    ? super.games 
    : _totalFilter(
      commanderOracleId: commanderOracleId,
      opponent: opponent,
      groupSize: groupSize,
      stat: (game) => 1,
    );
  
  int totalWinsFilter({
    String? commanderOracleId,
    String? opponent,
    int? groupSize,
  }) => (commanderOracleId == null && opponent == null && groupSize == null) 
    ? super.wins 
    : _totalFilter(
      commanderOracleId: commanderOracleId,
      opponent: opponent,
      groupSize: groupSize,
      stat: (game) => game.won ? 1 : 0,
    );

  int _totalFilter({
    String? commanderOracleId,
    String? opponent,
    int? groupSize,
    required int Function(PlayerGame) stat,
  }){
    int val = 0;
    for(final game in playerGames) {
      if(commanderOracleId == null || game.playedCommander(commanderOracleId)){
        if(groupSize == null || game.groupSize == groupSize) {
          if(opponent == null || game.opponents.contains(opponent)){
            val += stat(game);
          }
        }
      }
    }
    return val;
  }

  double winRateFilter({
    String? opponent,
    String? commanderOracleId,
    int? groupSize,
  }) => (opponent == null && commanderOracleId == null && groupSize == null) 
    ? super.winRate 
    : _averageFilter(
    commanderOracleId: commanderOracleId,
    groupSize: groupSize,
    opponent: opponent,
    stat: (game) => game.won ? 1 : 0,
  );


  double _averageFilter({
    String? commanderOracleId,
    String? opponent,
    int? groupSize,
    required num Function(PlayerGame) stat,
  }){
    double val = 0.0;
    int len = 0;
    for(final game in playerGames) {
      if(commanderOracleId == null || game.playedCommander(commanderOracleId)){
        if(groupSize == null || game.groupSize == groupSize) {
          if(opponent == null || game.opponents.contains(opponent)){
            val += stat(game);
            ++len;
          }
        }
      }
    }
    return len == 0 ? 0 : val/len;
  }


  //================================
  // Constructor(s)
  const PlayerStatsAdvanced(String name, {
    required int wins,
    required int games,
    required this.playerGames,
    required this.groupSizes,
    required this.commanders,
    required this.opponents,
  }): super(
    name,
    wins: wins, 
    games: games, 
  );



  factory PlayerStatsAdvanced.fromPastGames(
    PlayerStats simple, 
    Iterable<PastGame?> pastGames,
  ) {
    Set<MtgCard> commanders = <MtgCard>{};

    final games = <PlayerGame>[
      for(final game in pastGames)
        if(game!.winner != null)
        if(game.state.players.containsKey(simple.name))
          ((){
            Set<String?> oracleIds = <String?>{};
            final a = game.commandersA[simple.name];
            if(a != null){
              oracleIds.add(a.oracleId);
              commanders.add(a);
            }
            final b = game.commandersB[simple.name];
            if(b != null){
              oracleIds.add(b.oracleId);
              commanders.add(b);
            }
            return PlayerGame(
              won: simple.name == game.winner,
              groupSize: game.state.players.length,
              commandersOracleIds: oracleIds,
              opponents: <String>{
                for(final k in game.state.players.keys)
                  if(k != simple.name) k,
              },
            );
          })(),
    ];

    return PlayerStatsAdvanced(simple.name,
      wins: simple.wins,
      games: simple.games,
      playerGames: games,
      groupSizes: <int>{
        for(final g in games)
          g.groupSize,
      },
      opponents: <String>{
        for(final g in games)
          ...g.opponents,
      },
      commanders: commanders,
    );
  }

}


