import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/game.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/components/builders/card_builder.dart';
import 'package:counter_spell/widgets/components/builders/map_builder.dart';
import 'package:flutter/material.dart';

class PlayerCardsBuilder extends StatelessWidget {
  const PlayerCardsBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  });

  final int? playerIndex;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    MtgCard? cardA,
    MtgCard? cardB,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final playerIndex = this.playerIndex;
    if (playerIndex == null) return builder(context, null, null, child);

    return MapBuilder<Game, Commanders>(
      keys: [playerIndex],
      reactive: context.counterSpell.gameLogic.gameReactive,
      map: (game) {
        final settings = game.settings.playerSettings;
        if (playerIndex >= settings.length) {
          return (partnerA: null, partnerB: null);
        }
        return settings[playerIndex].commanders;
      },
      builder: (context, value, child) => CardBuilder(
        id: value.partnerA,
        child: child,
        builder: (context, cardA, child) => CardBuilder(
          id: value.partnerB,
          child: child,
          builder: (context, cardB, child) =>
              builder(context, cardA, cardB, child),
        ),
      ),
      child: child,
    );
  }
}
