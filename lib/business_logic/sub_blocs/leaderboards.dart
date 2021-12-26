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
  late BlocVar<Map<String,CommanderStats>> commanderStats;
  late BlocVar<Map<String,PlayerStats>> playerStats;
  final PersistentVar<Set<String>> customStatTitles;
  late BlocVar<Map<String,CustomStat>> customStats;

  CSPastGames(this.parent): 
    pastGames = BlocBox<PastGame>(
      <PastGame>[],
      key: "counterspell_bloc_var_pastGames_pastGames",
      itemToJson: (item) => item!.toJson,
      jsonToItem: (json) => PastGame.fromJson(json),
    ),
    customStatTitles = PersistentVar<Set<String>>(
      initVal: <String>{...CustomStat.all},
      key: "counterspell_bloc_var_pastGames_allCustomStatTitles",
      toJson: (s) => [...s],
      fromJson: (j) => <String>{...(j as List) as Iterable<String>},
    ){
      this.commanderStats = BlocVar.fromCorrelate
        <Map<String,CommanderStats>, List<PastGame?>>
      (
        from: pastGames, 
        map: (List<PastGame?> pastGames) => <String,CommanderStats>{
          for(final card in cards(pastGames)) 
            card.oracleId: CommanderStats.fromPastGames(card, pastGames),
          /// oracle Id because we want to just use one print of a commander
        },
      ) as BlocVar<Map<String,CommanderStats>>;
      this.playerStats = BlocVar.fromCorrelate
        <Map<String,PlayerStats>, List<PastGame?>>
      (
        from: pastGames, 
        map: (List<PastGame?> pastGames) => <String,PlayerStats>{
          for(final name in names(pastGames))
            name: PlayerStats.fromPastGames(name, pastGames),
        },
      ) as BlocVar<Map<String, PlayerStats>>;
      this.customStats = BlocVar.fromCorrelateLatest2
        <Map<String,CustomStat>, List<PastGame?>, Set<String>>
      (pastGames, customStatTitles, map: (pastGames, titles) => <String,CustomStat>{
        for(final title in titles)
          title: CustomStat.fromPastGames(title, pastGames),
      },);
    }

  //returns true if a prompt is shown
  bool saveGame(GameState state, {
    required Map<String,MtgCard> commandersA,
    required Map<String,MtgCard> commandersB,
    required bool avoidPrompt, 
  }) {

    if(state.historyLenght <= 1) return false;

    final pastGame = PastGame.fromState(state.frozen, 
      commandersA: commandersA,
      commandersB: commandersB,
      dateTime: state.firstTime,
    );
    this.pastGames.value.add(pastGame);
    this.pastGames.value.sort((one, two) 
      => one!.startingDateTime.compareTo(two!.startingDateTime)
    );
    this.pastGames.refresh();

    if(!avoidPrompt && parent.payments.unlocked.value&& pastGame.winner == null){
      parent.stage!.showAlert(
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



  
  static Iterable<MtgCard> cards(List<PastGame?> pastGames){

    final Map<String?,MtgCard> map = <String?,MtgCard>{
      for(final PastGame? pastGame in pastGames)
        if(pastGame != null)
        for(final commander in <MtgCard?>[
          ...pastGame.commandersA.values,
          ...pastGame.commandersB.values,
        ])
          if(commander != null) 
            commander.oracleId : commander,
        /// oracle Id because we want to just use one print of a commander
    };

    return map.values;

  }

  static Set<String> names(List<PastGame?> pastGames) => <String>{
    for(final PastGame? pastGame in pastGames)
      for(final name in pastGame!.state.players.keys)
        name,
  };

}