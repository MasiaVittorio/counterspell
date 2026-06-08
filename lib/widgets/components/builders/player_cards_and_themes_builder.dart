import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/components/builders/card_theme_builder.dart';
import 'package:counter_spell/widgets/components/builders/player_cards_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCardsAndThemesBuilder extends StatelessWidget {
  const PlayerCardsAndThemesBuilder({
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
    ThemeData themeA,
    ThemeData themeB,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return PlayerCardsBuilder(
      playerIndex: playerIndex,
      child: child,
      builder: (context, cardA, cardB, child) => switch ((cardA, cardB)) {
        (null, null) => builder(context, null, null, theme, theme, child),
        (final MtgCard cardA, null) => CardThemeBuilder(
          card: cardA,
          child: child,
          builder: (context, themeA, child) =>
              builder(context, cardA, null, themeA, theme, child),
        ),
        (null, final MtgCard cardB) => CardThemeBuilder(
          card: cardB,
          child: child,
          builder: (context, themeB, child) =>
              builder(context, null, cardB, theme, themeB, child),
        ),
        (final MtgCard cardA, final MtgCard cardB) => CardThemeBuilder(
          card: cardA,
          child: child,
          builder: (context, themeA, child) => CardThemeBuilder(
            card: cardB,
            child: child,
            builder: (context, themeB, child) =>
                builder(context, cardA, cardB, themeA, themeB, child),
          ),
        ),
      },
    );
  }
}
