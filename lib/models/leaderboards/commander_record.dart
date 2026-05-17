import 'package:counter_spell/models/leaderboards/record.dart';

class CommanderRecord extends Record {
  final String pilot;
  final int casts;
  final int damage;

  CommanderRecord({
    required super.result,
    required super.playersCount,
    required super.gameIndex,
    required super.timeStamp,
    required this.pilot,
    required this.casts,
    required this.damage,
  });
}

extension CommanderRecordsFilter on Iterable<CommanderRecord> {
  List<CommanderRecord> filter({
    int? filterByPlayerCount,
    String? filterByPilot,
    bool ignoreDraws = false,
  }) => <CommanderRecord>[
    for (final record in this)
      if (!(filterByPlayerCount != null &&
          record.playersCount != filterByPlayerCount))
        if (!(filterByPilot != null && record.pilot != filterByPilot))
          if (!ignoreDraws || record.result != null) record,
  ];
}
