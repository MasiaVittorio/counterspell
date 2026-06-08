import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/leaderboards/commander_record.dart';
import 'package:counter_spell/models/leaderboards/commander_stats.dart';
import 'package:counter_spell/models/leaderboards/game_record.dart';
import 'package:counter_spell/models/leaderboards/player_record.dart';
import 'package:counter_spell/models/leaderboards/player_stats.dart';

class GamesStats {
  final List<GameRecord> games;
  late final Map<String, PlayerStats> playerStats;
  late final Map<String, CommanderStats> commanderStats;

  GamesStats({required this.games}) {
    playerStats = {};
    commanderStats = {};
    for (int gameIndex = 0; gameIndex < games.length; gameIndex++) {
      final game = games[gameIndex];

      final playersCount = game.gameState.playerStates.length;
      for (int playerIndex = 0; playerIndex < playersCount; playerIndex++) {
        final settings = game.settings.playerSettings[playerIndex];
        final playerName = settings.name;
        final result = switch (game.winner) {
          null => null,
          int winnerIndex => winnerIndex == playerIndex,
        };
        playerStats[playerName] ??= PlayerStats(name: playerName, records: []);
        playerStats[playerName]!.records.add(
          PlayerRecord(
            gameIndex: gameIndex,
            result: result,
            timeStamp: game.startTime.toIso8601String(),
            playersCount: playersCount,
            against: {
              for (final oppo in game.settings.playerSettings)
                if (oppo.name != playerName) oppo.name,
            },
            commanders: {
              ?settings.commanders.partnerA,
              ?settings.commanders.partnerB,
            },
          ),
        );
        final playerState = game.gameState.playerStates[playerIndex];

        for (final commander in [
          (settings.commanders.partnerA, true),
          (settings.commanders.partnerB, false),
        ]) {
          final commanderId = commander.$1;
          if (commanderId == null) continue;
          final a = commander.$2;
          commanderStats[commanderId] ??= CommanderStats(
            id: commanderId,
            records: [],
          );
          int totalDamageDealt = 0;
          for (final pl in game.gameState.playerStates) {
            totalDamageDealt += pl.commanderDamageTaken[playerIndex].from(a);
          }
          commanderStats[commanderId]!.records.add(
            CommanderRecord(
              gameIndex: gameIndex,
              timeStamp: game.startTime.toIso8601String(),
              result: result,
              playersCount: playersCount,
              pilot: playerName,
              casts: playerState.commanderCasts.of(a),
              damage: totalDamageDealt,
            ),
          );
        }
      }
    }
    for (final stat in playerStats.values) {
      stat.reset();
    }
    for (final stat in commanderStats.values) {
      stat.reset();
    }
  }
}
