import 'dart:convert';

import 'package:counter_spell/logic/game_logic.dart';
import 'package:counter_spell/models/game/game.dart';
import 'package:sid_base/sid_base.dart';

class PlaygroupLogic extends LogicBase {
  late final PersistentReactive<List<int>> listSeatOrder;
  late final PersistentReactive<List<int>> arenaSeatOrder;

  final PersistentReactive<Map<String, NameRecord>> pastNameRecords =
      PersistentReactive(
        {},
        key: 'pastNameRecords',
        fromJsonDecoded: (jsonDecoded) => {
          if (jsonDecoded case Map map)
            for (final entry in map.entries)
              if (entry.key case String name)
                if (entry.value case Map recordMap)
                  name: NameRecord.fromMap(recordMap as Map<String, dynamic>),
        },
        toJsonEncodable: (value) => <String, Map<String, dynamic>>{
          for (final entry in value.entries) entry.key: entry.value.toMap(),
        },
      );

  @override
  void dispose() {
    listSeatOrder.dispose();
    arenaSeatOrder.dispose();
    pastNameRecords.dispose();
    gameLogic.removeGameListener(_gameListener);
    super.dispose();
  }

  final GameLogic gameLogic;

  PlaygroupLogic(this.gameLogic) {
    listSeatOrder = PersistentReactive([
      for (int i = 0; i < gameLogic.readGame().playerCount; i++) i,
    ], key: 'listSeatOrder');
    arenaSeatOrder = PersistentReactive([
      for (int i = 0; i < gameLogic.readGame().playerCount; i++) i,
    ], key: 'arenaSeatOrder');
    gameLogic.addGameListener(_gameListener);
    arenaSeatOrder.accessAfterReading((_) => _gameListener());
    listSeatOrder.accessAfterReading((_) => _gameListener());
  }

  void _gameListener() {
    if (!gameLogic.gameReactive.finishedReading) return;
    final n = gameLogic.readGame().playerCount;

    if (listSeatOrder.finishedReading) {
      if (n != listSeatOrder.value.length) {
        if (n > listSeatOrder.value.length) {
          listSeatOrder.update([
            for (int i = 0; i < n; i++)
              if (i < listSeatOrder.value.length) listSeatOrder.value[i] else i,
          ]);
        } else {
          listSeatOrder.update([
            for (final index in listSeatOrder.value)
              if (index < n) index,
          ]);
        }
      }
    }
    if (!arenaSeatOrder.finishedReading) return;
    if (n != arenaSeatOrder.value.length) {
      if (n > arenaSeatOrder.value.length) {
        arenaSeatOrder.update([
          for (int i = 0; i < n; i++)
            if (i < arenaSeatOrder.value.length) arenaSeatOrder.value[i] else i,
        ]);
      } else {
        arenaSeatOrder.update([
          for (final index in arenaSeatOrder.value)
            if (index < n) index,
        ]);
      }
    }
  }

  void reorderListSeatOrder(int oldIndex, int newIndex) {
    final list = <int?>[...listSeatOrder.value];
    final removed = list[oldIndex]!;
    list[oldIndex] = null;
    list.insert(newIndex, removed);
    listSeatOrder.value = <int>[for (final e in list) ?e];
    listSeatOrder.refresh();
  }

  void recordPlaygroup(Game game) {
    if (game.gameStates.length <= 1) return;
    for (final ps in game.settings.playerSettings) {
      final name = ps.name;
      pastNameRecords.value[name] =
          pastNameRecords.value[name]?.incremented ?? NameRecord.fresh();
    }
    pastNameRecords.refresh();
  }
}

class NameRecord {
  final int counts;
  final DateTime lastUsed;

  NameRecord({required this.counts, required this.lastUsed});

  static NameRecord fresh() => NameRecord(counts: 1, lastUsed: DateTime.now());

  NameRecord get incremented =>
      NameRecord(counts: counts + 1, lastUsed: DateTime.now());

  double sortingWeight() =>
      counts * DateTime.now().difference(lastUsed).abs().recencyMultiplier;

  NameRecord copyWith({int? counts, DateTime? lastUsed}) {
    return NameRecord(
      counts: counts ?? this.counts,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'counts': counts,
      'lastUsed': lastUsed.toIso8601String(),
    };
  }

  factory NameRecord.fromMap(Map<String, dynamic> map) {
    return NameRecord(
      counts: map['counts'] as int,
      lastUsed: DateTime.parse(map['lastUsed']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NameRecord.fromJson(String source) =>
      NameRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NameRecord(counts: $counts, lastUsed: $lastUsed)';

  @override
  bool operator ==(covariant NameRecord other) {
    if (identical(this, other)) return true;

    return other.counts == counts && other.lastUsed == lastUsed;
  }

  @override
  int get hashCode => counts.hashCode ^ lastUsed.hashCode;
}

extension SortedPastNames on Map<String, NameRecord> {
  List<String> get sortedNames => [...keys]
    ..sort(
      (a, b) => -this[a]!.sortingWeight().compareTo(this[b]!.sortingWeight()),
    );
}

extension on Duration {
  static const thresholds = [
    (Duration(hours: 4), 6.0),
    (Duration(hours: 10), 4.0),
    (Duration(days: 1), 3.0),
    (Duration(days: 2), 2.5),
    (Duration(days: 7), 2.0),
    (Duration(days: 14), 1.5),
    (Duration(days: 30), 1.2),
    (Duration(days: 60), 1.0),
    (Duration(days: 120), 0.5),
    (Duration(days: 365), 0.2),
  ];
  double get recencyMultiplier {
    if (this < thresholds.first.$1) return thresholds.first.$2;
    for (int i = 1; i < thresholds.length; i++) {
      final a = thresholds[i - 1];
      final b = thresholds[i];
      if (this < b.$1) {
        return inMilliseconds.rangeMap(
          from: (a.$1.inMilliseconds, b.$1.inMilliseconds),
          to: (a.$2, b.$2),
        );
      }
    }
    return thresholds.last.$2;
  }
}
