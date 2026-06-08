import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/game_settings.dart';
import 'package:counter_spell/models/game/game_state.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/player_tile_gestures.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/player_tile_layout.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/player_tile_subtitle.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/player_tile_title.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/players_list_layout.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/decoration/player_tile_decoration.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/player_tile_number_circle.dart';
import 'package:counter_spell/widgets/components/builders/player_cards_and_themes_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

import 'components/player_tile_trailing.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
    required this.gameSettings,
    required this.gameState,
    required this.index,
    required this.screenWidth,
    required this.isLast,
    required this.isFirst,
  });

  final GameState gameState;
  final GameSettings gameSettings;
  final int index;
  final double screenWidth;
  final bool isLast;
  final bool isFirst;

  static const double minSize = PlayerListLayoutBuilder.minSize;

  bool get skip => false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final borderRadius = GroupedCard.borderRadius(
      layout,
      isFirst: isFirst,
      isLast: isLast,
    );

    return context.counterSpell.pagesLogic.bodyPage.build((context, page) {
      final settings = gameSettings.playerSettings[index];
      final playerState = gameState.playerStates[index];
      final height = context.playerTileHeight;

      final dense = height <= PlayerTile.minSize;
      final name = settings.name;

      final numberCircle = PlayerTileNumberCircle(
        index: index,
        playerState: playerState,
        page: page,
      );

      final trailing = PlayerTileTrailing(
        index: index,
        playerSettings: settings,
        page: page,
        dense: dense,
      );

      final Widget subtitle = PlayerTileSubtitle(
        page: page,
        gameSettings: gameSettings,
        settings: settings,
        index: index,
      );

      final playerTileLayout = PlayerTileLayout(
        title: PlayerTileTitle(name: name),
        numberCircle: numberCircle,
        bottomTrailing: trailing,
        subtitle: subtitle,
        dense: dense,
      );

      final playerTileGestures = PlayerTileGestures(
        page: page,
        index: index,
        screenWidth: screenWidth,
        child: playerTileLayout,
      );

      final margin = layout.margin.medium;

      return Pad(
        horizontal: margin,
        child: RepaintBoundary(
          child: PlayerCardsAndThemesBuilder(
            playerIndex: index,
            builder: (context, cardA, cardB, themeA, themeB, child) =>
                PlayerTileDecoration(
                  index: index,
                  interactionMode: page.toInteractionMode(),
                  tileWidth: screenWidth - margin * 2,
                  cardA: cardA,
                  cardB: cardB,
                  themeA: themeA,
                  themeB: themeB,
                  borderRadius: borderRadius,
                  runsTwoPartners: settings.runsTwoPartners,
                  child: playerTileGestures,
                ),
          ),
        ),
      );
    });
  }
}
