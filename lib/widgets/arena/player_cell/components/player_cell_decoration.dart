import 'package:counter_spell/widgets/arena/components/open_side.dart';
import 'package:counter_spell/widgets/arena/player_cell/builders/border_builder.dart';
import 'package:counter_spell/widgets/arena/player_cell/builders/visibility_builder.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/decoration/player_tile_borders.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/decoration/player_tile_images.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/split_theme.dart';
import 'package:counter_spell/widgets/components/builders/partner_focus_builder.dart';
import 'package:counter_spell/widgets/components/builders/player_cards_and_themes_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellDecoration extends StatelessWidget {
  const PlayerCellDecoration({
    super.key,
    required this.playerIndex,
    required this.child,
    required this.flat,
  });

  final int playerIndex;
  final Widget child;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final openSides = context.openSides;

    final BorderRadius borderRadius = flat
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

    return CleanProvider<BorderRadius>(
      data: borderRadius,
      child: PlayerCardsAndThemesBuilder(
        playerIndex: playerIndex,
        child: child,
        builder: (context, cardA, cardB, themeA, themeB, child) {
          return PartnerFocusBuilder.arenaView(
            playerIndex: playerIndex,
            child: child,
            builder: (context, focus, runsTwoPartners, child) {
              final bordersAndChild = Stack(
                children: [
                  Positioned.fill(
                    child: ArenaPlayerCellBorderBuilder(
                      playerIndex: playerIndex,
                      builder: (context, hasBorder, child) {
                        return PlayerTilePartnerBorders(
                          showBorder: hasBorder,
                          borderRadius: borderRadius,
                          cardA: cardA,
                          cardB: cardB,
                          themeA: themeA,
                          themeB: themeB,
                          partnerFocus: focus,
                          runsTwoPartners: runsTwoPartners,
                        );
                      },
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: SplitThemesProvider(
                      cardA: cardA,
                      cardB: cardB,
                      themeA: themeA,
                      themeB: themeB,
                      partnerFocus: focus,
                      runsTwoPartners: runsTwoPartners,
                      child: child!,
                    ),
                  ),
                ],
              );

              return ArenaPlayerCellVisibilityBuilder(
                playerIndex: playerIndex,
                child: bordersAndChild,
                builder: (context, visibility, child) {
                  final backgroundColor = switch (visibility) {
                    ImageVisibility.lowest =>
                      theme.colorScheme.surfaceContainerLow,
                    ImageVisibility.high =>
                      theme.colorScheme.surfaceContainerHighest,
                    _ => theme.colorScheme.surfaceContainer,
                  };

                  if (cardA == null && (!runsTwoPartners || cardB == null)) {
                    return AnimatedContainer(
                      duration: Motion.beginAndEndOnScreenEmphasized.duration,
                      curve: Motion.beginAndEndOnScreenEmphasized.curve,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: backgroundColor,
                      ),
                      child: child!,
                    );
                  }

                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: backgroundColor,
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return ConstrainedBox(
                                constraints: constraints,
                                child: PlayerTilePartnerImages(
                                  tileWidth: constraints.maxWidth,
                                  imageVisibility: visibility,
                                  cardA: cardA,
                                  cardB: cardB,
                                  partnerFocus: focus,
                                  runsTwoPartners: runsTwoPartners,
                                ),
                              );
                            },
                          ),
                        ),
                        child!,
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
