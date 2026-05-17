import 'package:counter_spell/models/leaderboards/player_record.dart';
import 'package:counter_spell/models/leaderboards/record.dart';
import 'package:counter_spell/models/leaderboards/win_rate.dart';

class PlayerStats {
  final String name;
  final List<PlayerRecord> records;

  late List<String> opponents;
  late List<String> commanders;
  late List<int> playerCounts;
  late WinRate overallWinRate;

  PlayerStats({required this.name, required this.records}) {
    reset();
  }

  void reset() {
    final opponentsSet = {for (final record in records) ...record.against};
    final commandersSet = {for (final record in records) ...record.commanders};
    final playerCountsSet = {for (final record in records) record.playersCount};

    final Map<String, int> commanderCounts = {};
    final Map<String, int> opponentCounts = {};
    for (final record in records) {
      for (final commander in record.commanders) {
        commanderCounts[commander] = (commanderCounts[commander] ?? 0) + 1;
      }
      for (final opponent in record.against) {
        opponentCounts[opponent] = (opponentCounts[opponent] ?? 0) + 1;
      }
    }

    opponents = opponentsSet.toList()
      ..sort((a, b) => -(opponentCounts[a]!).compareTo(opponentCounts[b]!));
    commanders = commandersSet.toList()
      ..sort((a, b) => -(commanderCounts[a]!).compareTo(commanderCounts[b]!));
    playerCounts = playerCountsSet.toList()..sort();
    overallWinRate = records.winRate();
  }
}
