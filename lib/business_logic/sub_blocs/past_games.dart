import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/leaderboards/stats/commanders/model_simple.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/leaderboards/history/winner_selector.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/leaderboards/stats/players/model_simple.dart';

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
  final BlocBox<PastGame> pastGames;
  BlocVar<List<CommanderStats>> commanderStats;
  BlocVar<List<PlayerStats>> playerStats;

  CSPastGames(this.parent): pastGames = BlocBox<PastGame>(
    <PastGame>[],
    key: "counterspell_bloc_var_pastGames_pastGames",
    itemToJson: (item) => item.toJson,
    jsonToItem: (json) => PastGame.fromJson(json),
  ){
    this.commanderStats = BlocVar.fromCorrelate(
      from: pastGames, 
      map: (List<PastGame> pastGames) => <CommanderStats>[
        for(final card in cards(pastGames))
          CommanderStats.fromPastGames(card, pastGames),
      ]..sort((one,two) => two.games.compareTo(one.games)),
    );
    this.playerStats = BlocVar.fromCorrelate(
      from: pastGames, 
      map: (List<PastGame> pastGames) => <PlayerStats>[
        for(final name in names(pastGames))
          PlayerStats.fromPastGames(name, pastGames),
      ]..sort((one,two) => ((two.games - one.games)*1000).toInt()),
    );
  }

  //returns true if a prompt is shown
  bool saveGame(GameState state, {
    @required Map<String,MtgCard> commandersA,
    @required Map<String,MtgCard> commandersB,
    @required bool avoidPrompt, 
  }) {

    if(state.historyLenght <= 1) return false;

    final pastGame = PastGame.fromState(state.frozen, 
      commandersA: commandersA,
      commandersB: commandersB,
      dateTime: state.firstTime,
    );
    this.pastGames.value.add(pastGame);
    this.pastGames.value.sort((one, two) 
      => one.startingDateTime.compareTo(two.startingDateTime)
    );
    this.pastGames.refresh();

    if(!avoidPrompt && parent.payments.unlocked.value && pastGame.winner == null){
      parent.stage.showAlert(
        WinnerSelector(
          pastGame.state.names,
          onConfirm: (winner){
            pastGame.winner = winner;
            pastGames.refresh(index: pastGames.value.length-1);
          },
          onDontSave: (){
            this.pastGames.removeLast();
          },
        ),
        size: WinnerSelector.heightCalc(pastGame.state.players.length, true),
        replace: true,
      );
      return true;
    }

    return false;
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