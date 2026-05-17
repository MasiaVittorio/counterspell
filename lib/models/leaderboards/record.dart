import 'package:counter_spell/models/leaderboards/win_rate.dart';

class Record {
  final bool? result; // true: win, false: loss, null: draw
  final int playersCount;
  final int gameIndex;
  final String timeStamp;

  Record({
    required this.result,
    required this.playersCount,
    required this.gameIndex,
    required this.timeStamp,
  });
}

extension RecordsWinRate on List<Record> {
  WinRate winRate() {
    int wins = 0;
    int draws = 0;
    int losses = 0;
    for (final record in this) {
      switch (record.result) {
        case true:
          wins++;
          break;
        case false:
          losses++;
          break;
        case null:
          draws++;
          break;
      }
    }
    return (wins: wins, draws: draws, losses: losses);
  }
}
