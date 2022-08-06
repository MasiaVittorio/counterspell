import 'package:counter_spell_new/core.dart';

/// Turn 1 Sol Ring (Games appearanece / game won by applicable player)
/// Single screen
/// Players most times / most frequently
/// Commanders most times / most frequently
/// Games appearance / game won by applicable player

class CustomGame {
  // final String customStat;
  // final String winner;
  // final Map<String>  
}



class CustomStat {
  static const List<String> all = [
    "Turn 1 Sol Ring",
    "Cycloninc Rift",
    "Lab man",
  ];

  final String title;

  final Map<String,int> playersApplicable;

  final Map<String?,int> commandersApplicable; /// commander card oracleId => number

  final int appearances;
  final int wins;
  
  CustomStat({
    required this.title,
    required this.appearances,
    required this.wins,

    required this.commandersApplicable,

    required this.playersApplicable,
  });

  static CustomStat fromPastGames(String title, List<PastGame?> pastGames){
    Map<String?,int> cmdrApply = <String?,int>{};
    Map<String,int> plrApply = <String,int>{};

    int appearances = 0;
    int wins = 0;

    for(final g in pastGames){

      bool appeared = false;
      bool won = false;

      for(final e in [...g!.commandersA.entries, ...g.commandersB.entries]){
        final MtgCard? card = e.value;
        final String pilot = e.key;
        if(card != null){
          final String id = card.oracleId;
          if(g.customStats[title]?.contains(pilot) ?? false){
            cmdrApply[id] = (cmdrApply[id] ?? 0) + 1;
          }
        }
      }

      for(final name in g.state.players.keys){
        if(g.customStats[title]?.contains(name) ?? false){

          appeared = true;

          plrApply[name] = (plrApply[name] ?? 0) + 1;

          if(g.winner == name) won = true;

        }
      }

      if(appeared) ++appearances;
      if(won) ++wins;
      
    }

    return CustomStat(
      title: title,
      commandersApplicable: cmdrApply,
      playersApplicable: plrApply,
      appearances: appearances,
      wins: wins,
    );
  }
}

