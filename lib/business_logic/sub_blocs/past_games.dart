import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/leaderboards/components/commanders/model_simple.dart';
import 'package:counter_spell_new/widgets/alerts/leaderboards/components/games/winner_selector.dart';
import 'package:counter_spell_new/widgets/alerts/leaderboards/components/players/model_simple.dart';

class CSPastGames {

  //================================
  // Dispose resources 
  void dispose(){
    this.pastGames.dispose();
    this.commanderStats.dispose();
  }

  //================================
  // Values 
  final CSBloc parent; 
  final PersistentVar<List<PastGame>> pastGames;
  BlocVar<List<CommanderStats>> commanderStats;
  BlocVar<List<PlayerStats>> playerStats;

  CSPastGames(this.parent): pastGames = PersistentVar<List<PastGame>>(
    key: "counterspell_bloc_var_pastGames_pastGames",
    initVal: <PastGame>[],
    toJson: (list) => <Map<String,dynamic>>[
      for(final pastGame in list)
        pastGame.toJson,
    ],
    fromJson: (json) => <PastGame>[
      for(final encoded in (json as List))
        PastGame.fromJson(encoded),
    ],
    copier: (list) => [for(final e in list) e],
  ){
    this.commanderStats = BlocVar.fromCorrelate(
      pastGames, 
      (List<PastGame> pastGames) => <CommanderStats>[
        for(final card in cards(pastGames))
          CommanderStats.fromPastGames(card, pastGames),
      ]..sort((one,two) => two.games.compareTo(one.games)),
    );
    this.playerStats = BlocVar.fromCorrelate(
      pastGames, 
      (List<PastGame> pastGames) => <PlayerStats>[
        for(final name in names(pastGames))
          PlayerStats.fromPastGames(name, pastGames),
      ]..sort((one,two) => ((two.winRate - one.winRate)*1000).toInt()),
    );
  }

  void saveGame(GameState state, {
    @required Map<String,MtgCard> commandersA,
    @required Map<String,MtgCard> commandersB,
  }) async {

    if(state.historyLenght <= 1) return;

    final pastGame = PastGame.fromState(state.frozen, 
      commandersA: commandersA,
      commandersB: commandersB,
    );
    this.pastGames.value.add(pastGame);
    this.pastGames.value.sort((one, two) => one.dateTime.difference(two.dateTime).inMilliseconds);
    this.pastGames.refresh();

    if(parent.payments.unlocked.value && pastGame.winner == null){
      parent.stage.showAlert(
        WinnerSelector(
          pastGame.state.names,
          onConfirm: (winner) => pastGame.winner = winner,
          onDontSave: (){
            this.pastGames.value.removeLast();
            this.pastGames.refresh();
          },
        ),
        size: WinnerSelector.heightCalc(pastGame.state.players.length, true),
        replace: true,
      );
    }
  }

  void removeGameAt(int index){
    this.pastGames.value.removeAt(index);
    this.pastGames.refresh();
  }

  
  static Iterable<MtgCard> cards(List<PastGame> pastGames){

    final Map<String,MtgCard> map = <String,MtgCard>{
      for(final PastGame pastGame in pastGames)
        for(final commander in <MtgCard>[
          ...pastGame.commandersA.values,
          ...pastGame.commandersB.values,
        ])
          if(commander != null) 
            commander.oracleId : commander,
    };

    return map.values;

  }

  static Set<String> names(List<PastGame> pastGames) => <String>{
    for(final PastGame pastGame in pastGames)
      for(final name in pastGame.state.players.keys)
        name,
  };

}