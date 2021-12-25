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

  static CustomStat fromPastGames(String _title, List<PastGame?> pastGames){
    Map<String?,int> _cmdrApply = <String?,int>{};
    Map<String,int> _plrApply = <String,int>{};

    int _appearances = 0;
    int _wins = 0;

    for(final g in pastGames){

      bool _appeared = false;
      bool _won = false;

      for(final e in [...g!.commandersA.entries, ...g.commandersB.entries]){
        final MtgCard? card = e.value;
        final String pilot = e.key;
        if(card != null){
          final String? id = card.oracleId;
          if(g.customStats[_title]?.contains(pilot) ?? false){
            _cmdrApply[id] = (_cmdrApply[id] ?? 0) + 1;
          }
        }
      }

      for(final name in g.state.players.keys){
        if(g.customStats[_title]?.contains(name) ?? false){

          _appeared = true;

          _plrApply[name] = (_plrApply[name] ?? 0) + 1;

          if(g.winner == name) _won = true;

        }
      }

      if(_appeared) ++_appearances;
      if(_won) ++_wins;
      
    }

    return CustomStat(
      title: _title,
      commandersApplicable: _cmdrApply,
      playersApplicable: _plrApply,
      appearances: _appearances,
      wins: _wins,
    );
  }
}

