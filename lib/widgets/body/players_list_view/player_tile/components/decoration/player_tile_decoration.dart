import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/arena/player_cell/builders/visibility_builder.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/decoration/highlight_and_border_builder.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/decoration/player_tile_borders.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/decoration/player_tile_images.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/split_theme.dart';
import 'package:counter_spell/widgets/components/builders/partner_focus_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerTileDecoration extends StatelessWidget {
  const PlayerTileDecoration({
    super.key,
    required this.cardA,
    required this.cardB,
    required this.themeA,
    required this.themeB,
    required this.interactionMode,
    required this.borderRadius,
    required this.child,
    required this.runsTwoPartners,
    required this.tileWidth,
    required this.index,
    this.forceLowVisibility = false,
    this.forceHighlight = false,
  });

  final int index;
  final MtgCard? cardA;
  final MtgCard? cardB;
  final ThemeData themeA;
  final ThemeData themeB;
  final bool runsTwoPartners;
  final InteractionMode? interactionMode;
  final BorderRadius borderRadius;
  final double tileWidth;
  final bool forceHighlight;
  final bool forceLowVisibility;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DefaultTextStyle(
      style: DefaultTextStyle.of(
        context,
      ).style.merge(TextStyle(color: theme.colorScheme.surface.contrast)),
      child: HighlightAndBorderBuilder(
        index: index,
        interactionMode: interactionMode,
        child: child,
        builder: (context, h, b, child) {
          return RawPlayerDecoration(
            borderRadius: borderRadius,
            themeA: themeA,
            themeB: themeB,
            imageVisibility: forceHighlight
                ? ImageVisibility.high
                : forceLowVisibility
                ? ImageVisibility.low
                : switch (h) {
                    true => ImageVisibility.high,
                    false => ImageVisibility.low,
                    null => ImageVisibility.normal,
                  },
            cardA: cardA,
            tileWidth: tileWidth,
            showBorder: forceHighlight
                ? true
                : forceLowVisibility
                ? false
                : b,
            index: index,
            cardB: cardB,
            child: child!,
          );
        },
      ),
    );
  }
}

class RawPlayerDecoration extends StatelessWidget {
  const RawPlayerDecoration({
    super.key,
    required this.borderRadius,
    required this.imageVisibility,
    required this.cardA,
    required this.cardB,
    required this.themeA,
    required this.themeB,
    required this.tileWidth,
    required this.showBorder,
    required this.index,
    required this.child,
  });

  final int index;
  final BorderRadius borderRadius;
  final MtgCard? cardA;
  final MtgCard? cardB;
  final ThemeData themeA;
  final ThemeData themeB;
  final double tileWidth;
  final bool showBorder;
  final ImageVisibility imageVisibility;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: switch (imageVisibility) {
          ImageVisibility.lowest => theme.colorScheme.surfaceContainerLow,
          ImageVisibility.high => theme.colorScheme.surfaceContainerHighest,
          _ => theme.colorScheme.surfaceContainer,
        },
      ),
      child: PartnerFocusBuilder.listView(
        playerIndex: index,
        child: child,
        builder: (context, partnerFocus, runsTwoPartners, child) {
          return Stack(
            children: [
              if (cardA != null || (runsTwoPartners && cardB != null))
                Positioned.fill(
                  child: PlayerTilePartnerImages(
                    tileWidth: tileWidth,
                    imageVisibility: imageVisibility,
                    cardA: cardA,
                    cardB: cardB,
                    partnerFocus: partnerFocus,
                    runsTwoPartners: runsTwoPartners,
                  ),
                ),
              Positioned.fill(
                child: PlayerTilePartnerBorders(
                  showBorder: showBorder,
                  borderRadius: borderRadius,
                  cardA: cardA,
                  cardB: cardB,
                  themeA: themeA,
                  themeB: themeB,
                  partnerFocus: partnerFocus,
                  runsTwoPartners: runsTwoPartners,
                ),
              ),
              Material(
                type: MaterialType.transparency,
                child: SplitThemesProvider(
                  cardA: cardA,
                  cardB: cardB,
                  themeA: themeA,
                  themeB: themeB,
                  partnerFocus: partnerFocus,
                  runsTwoPartners: runsTwoPartners,
                  child: child!,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
