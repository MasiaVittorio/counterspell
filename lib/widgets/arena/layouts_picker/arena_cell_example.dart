import 'package:auto_size_text/auto_size_text.dart';
import 'package:counter_spell/models/game/game.dart';
import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:counter_spell/widgets/arena/components/open_side.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/decoration/player_tile_decoration.dart';
import 'package:counter_spell/widgets/components/builders/player_cards_and_themes_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ArenaCellExample extends StatelessWidget {
  const ArenaCellExample({
    super.key,
    required this.cellIndex,
    required this.playerIndex,
    required this.game,
    required this.onDropPlayerIndexOnCellIndex,
    required this.flat,
  });

  final int cellIndex;
  final int? playerIndex;
  final Game game;
  final void Function(int playerIndex, int cellIndex)?
  onDropPlayerIndexOnCellIndex;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final openSides = context.openSides;

    final borderRadius = flat
        ? BorderRadius.zero
        : BorderRadius.only(
            topLeft: Radius.circular(
              openSides.top && openSides.left
                  ? layout.radius.medium
                  : layout.radius.tiny,
            ),
            topRight: Radius.circular(
              openSides.top && openSides.right
                  ? layout.radius.medium
                  : layout.radius.tiny,
            ),
            bottomLeft: Radius.circular(
              openSides.bottom && openSides.left
                  ? layout.radius.medium
                  : layout.radius.tiny,
            ),
            bottomRight: Radius.circular(
              openSides.bottom && openSides.right
                  ? layout.radius.medium
                  : layout.radius.tiny,
            ),
          );
    final playerIndex = this.playerIndex;

    Widget child(
      int? playerIndex, {
      bool skipName = false,
      bool forceBorder = false,
      bool forceLowVis = false,
    }) {
      final playerSettings = playerIndex == null
          ? null
          : game.settings.playerSettings.elementAtOrNull(playerIndex);
      return Material(
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: borderRadius,
        child: PlayerCardsAndThemesBuilder(
          playerIndex: playerIndex,
          builder: (context, cardA, cardB, themeA, themeB, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: constraints,
                  child: PlayerTileDecoration(
                    cardA: cardA,
                    cardB: cardB,
                    themeA: themeA,
                    themeB: themeB,
                    interactionMode: InteractionMode.life,
                    borderRadius: borderRadius,
                    runsTwoPartners: playerSettings?.runsTwoPartners ?? false,
                    tileWidth: constraints.maxWidth,
                    index: playerIndex ?? -1,
                    forceHighlight: forceBorder,
                    forceLowVisibility: forceLowVis,
                    child: skipName
                        ? const SizedBox.expand()
                        : Pad(
                            horizontal: layout.padding.medium,
                            child: Center(
                              child: AutoSizeText(
                                forceBorder
                                    ? ''
                                    : playerSettings?.name ??
                                          'Cell #${cellIndex + 1}',
                                style: theme.textTheme.displayLarge,
                                maxLines: 1,
                              ),
                            ),
                          ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    if (playerIndex == null) return child(null);
    final onDropPlayerIndexOnCellIndex = this.onDropPlayerIndexOnCellIndex;
    if (onDropPlayerIndexOnCellIndex == null) return child(playerIndex);
    const double fs = 128;
    return Draggable<int>(
      data: playerIndex,
      feedback: Center(
        child: SizedBox.square(
          dimension: fs,
          child: child(playerIndex, skipName: true),
        ),
      ),
      dragAnchorStrategy: (_, _, _) => const Offset(fs / 2, fs / 2),
      childWhenDragging: child(playerIndex, skipName: true, forceLowVis: true),
      child: DragTarget<int>(
        builder: (context, candidateData, _) =>
            child(playerIndex, forceBorder: candidateData.isNotEmpty),
        onAcceptWithDetails: (details) =>
            onDropPlayerIndexOnCellIndex(details.data, cellIndex),
        onWillAcceptWithDetails: (details) => details.data != playerIndex,
      ),
    );
  }
}
