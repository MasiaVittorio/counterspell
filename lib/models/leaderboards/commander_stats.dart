import 'package:counter_spell/models/leaderboards/commander_record.dart';
import 'package:counter_spell/models/leaderboards/record.dart';
import 'package:counter_spell/models/leaderboards/win_rate.dart';

class CommanderStats {
  final String id;
  final List<CommanderRecord> records;

  late List<int> playerCounts;
  late List<String> pilots;
  late WinRate overallWinRate;
  late double overallAverageDamage;
  late double overallAverageCasts;

  CommanderStats({required this.id, required this.records}) {
    reset();
  }

  void reset() {
    final pilotsSet = {for (final record in records) record.pilot};
    final playerCountsSet = {for (final record in records) record.playersCount};

    final Map<String, int> pilotCounts = {};
    for (final record in records) {
      pilotCounts[record.pilot] = (pilotCounts[record.pilot] ?? 0) + 1;
    }

    pilots = pilotsSet.toList()
      ..sort((a, b) => -(pilotCounts[a]!).compareTo(pilotCounts[b]!));
    playerCounts = playerCountsSet.toList()..sort();

    overallWinRate = records.winRate();

    overallAverageCasts = records.averageMap((e) => e.casts);
    overallAverageDamage = records.averageMap((e) => e.damage);
  }
}

extension IterableSumMap<T> on Iterable<T> {
  num sumMap(num Function(T e) map) {
    num sum = 0;
    for (final e in this) {
      sum += map(e);
    }
    return sum;
  }

  double averageMap(num Function(T e) map) {
    return sumMap(map) / length;
  }
}

extension IterableSum on Iterable<int> {
  int sum() => reduce((a, b) => a + b);
  double average() => sum() / length;
}
