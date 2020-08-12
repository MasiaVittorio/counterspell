import 'package:counter_spell_new/core.dart';
import 'model_simple.dart';


class PlayerGame {

  final bool won;
  final Set<String> opponents;
  final int groupSize;
  final Set<String> commandersIds;

  const PlayerGame({
    @required this.groupSize,
    @required this.won,
    @required this.opponents,
    @required this.commandersIds,
  });

  bool playedCommander(String id) => this.commandersIds.contains(id);
  bool playedWith(String opponent) => this.opponents.contains(opponent);
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
    String commanderId,
    String opponent,
    int groupSize,
  }) => (commanderId == null && opponent == null && groupSize == null) 
    ? super.games 
    : _totalFilter(
      commanderId: commanderId,
      opponent: opponent,
      groupSize: groupSize,
      stat: (game) => 1,
    );
  
  int totalWinsFilter({
    String commanderId,
    String opponent,
    int groupSize,
  }) => (commanderId == null && opponent == null && groupSize == null) 
    ? super.wins 
    : _totalFilter(
      commanderId: commanderId,
      opponent: opponent,
      groupSize: groupSize,
      stat: (game) => game.won ? 1 : 0,
    );

  int _totalFilter({
    String commanderId,
    String opponent,
    int groupSize,
    @required int Function(PlayerGame) stat,
  }){
    int val = 0;
    for(final game in this.playerGames)
      if(commanderId == null || game.playedCommander(commanderId))
        if(groupSize == null || game.groupSize == groupSize)
          if(opponent == null || game.opponents.contains(opponent)){
            val += stat(game);
          }
    return val;
  }

  double winRateFilter({
    String opponent,
    String commanderId,
    int groupSize,
  }) => (opponent == null && commanderId == null && groupSize == null) 
    ? super.winRate 
    : _averageFilter(
    commanderId: commanderId,
    groupSize: groupSize,
    opponent: opponent,
    stat: (game) => game.won ? 1 : 0,
  );


  double _averageFilter({
    String commanderId,
    String opponent,
    int groupSize,
    @required num Function(PlayerGame) stat,
  }){
    double val = 0.0;
    int len = 0;
    for(final game in this.playerGames)
      if(commanderId == null || game.playedCommander(commanderId))
        if(groupSize == null || game.groupSize == groupSize)
          if(opponent == null || game.opponents.contains(opponent)){
            val += stat(game);
            ++len;
          }
    return len == 0 ? 0 : val/len;
  }


  //================================
  // Constructor(s)
  const PlayerStatsAdvanced(String name, {
    @required int wins,
    @required int games,
    @required this.playerGames,
    @required this.groupSizes,
    @required this.commanders,
    @required this.opponents,
  }): super(
    name,
    wins: wins, 
    games: games, 
  );



  factory PlayerStatsAdvanced.fromPastGames(
    PlayerStats simple, 
    Iterable<PastGame> pastGames,
  ) {
    Set<MtgCard> _commanders = <MtgCard>{};

    final _games = <PlayerGame>[
      for(final game in pastGames)
        if(game.winner != null)
        if(game.state.players.containsKey(simple.name))
          ((){
            Set<String> _ids = <String>{};
            final a = game.commandersA[simple.name];
            if(a != null){
              _ids.add(a.id);
              _commanders.add(a);
            }
            final b = game.commandersB[simple.name];
            if(b != null){
              _ids.add(b.id);
              _commanders.add(b);
            }
            print(game.winner);
            return PlayerGame(
              won: simple.name == game.winner,
              groupSize: game.state.players.length,
              commandersIds: _ids,
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
      playerGames: _games,
      groupSizes: <int>{
        for(final g in _games)
          g.groupSize,
      },
      opponents: <String>{
        for(final g in _games)
          ...g.opponents,
      },
      commanders: _commanders,
    );
  }

}


