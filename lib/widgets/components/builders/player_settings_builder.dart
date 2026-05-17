import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/widgets/components/builders/map_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

class PlayerSettingsBuilder extends StatelessWidget {
  const PlayerSettingsBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  });

  final int playerIndex;
  final Widget? child;
  final ChildValueBuilder<PlayerSettings> builder;

  @override
  Widget build(BuildContext context) {
    return MapBuilder(
      reactive: context.counterSpell.gameLogic.gameReactive,
      map: (game) {
        if (playerIndex >= game.settings.playerSettings.length ||
            playerIndex < 0) {
          return game.settings.playerSettings.first;
        }
        return game.settings.playerSettings[playerIndex];
      },
      keys: [playerIndex],
      builder: builder,
      child: child,
    );
  }
}

class NullablePlayerSettingsBuilder extends StatelessWidget {
  const NullablePlayerSettingsBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  });

  final int? playerIndex;
  final Widget? child;
  final ChildValueBuilder<PlayerSettings?> builder;

  @override
  Widget build(BuildContext context) {
    return MapBuilder(
      reactive: context.counterSpell.gameLogic.gameReactive,
      map: (game) => switch (playerIndex) {
        int playerIndex => game.settings.playerSettings[playerIndex],
        null => null,
      },
      keys: [playerIndex],
      builder: builder,
      child: child,
    );
  }
}
