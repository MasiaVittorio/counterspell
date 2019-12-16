import 'package:counter_spell_new/core.dart';

class CSPastGames {

  //================================
  // Dispose resources 
  void dispose(){
    this.pastGames.dispose();
  }

  //================================
  // Values 
  final CSBloc parent; 
  final PersistentVar<List<PastGame>> pastGames;

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
  );

  void saveGame(GameState state, {
    @required Map<String,MtgCard> commandersA,
    @required Map<String,MtgCard> commandersB,
  }){
    this.pastGames.value.add(PastGame.fromState(state, 
      commandersA: commandersA,
      commandersB: commandersB,
    ));
    this.pastGames.value.sort((one, two) => one.dateTime.difference(two.dateTime).inMilliseconds);
    this.pastGames.refresh();
  }

  void removeGameAt(int index){
    this.pastGames.value.removeAt(index);
    this.pastGames.refresh();
  }

  
}