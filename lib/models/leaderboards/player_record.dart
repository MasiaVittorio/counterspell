import 'package:counter_spell/models/leaderboards/record.dart';

class PlayerRecord extends Record {
  final Set<String> against;
  final Set<String> commanders;

  PlayerRecord({
    required super.result,
    required super.playersCount,
    required super.gameIndex,
    required super.timeStamp,
    required this.against,
    required this.commanders,
  });
}

extension PlayerRecordsFilter on Iterable<PlayerRecord> {
  List<PlayerRecord> filter({
    int? filterByPlayerCount,
    Set<String> filterByOpponents = const {},
    Set<String> filterByCommanders = const {},
    bool ignoreDraws = false,
  }) => <PlayerRecord>[
    for (final record in this)
      if (!(filterByPlayerCount != null &&
          filterByPlayerCount != record.playersCount))
        if (!(filterByOpponents.isNotEmpty &&
            filterByOpponents.intersection(record.against).isEmpty))
          if (!(filterByCommanders.isNotEmpty &&
              filterByCommanders.intersection(record.commanders).isEmpty))
            if (!ignoreDraws || record.result != null) record,
  ];
}
