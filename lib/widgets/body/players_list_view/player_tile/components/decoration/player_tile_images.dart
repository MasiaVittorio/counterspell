// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/arena/player_cell/builders/visibility_builder.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/decoration/partner_split.dart';
import 'package:counter_spell/widgets/components/builders/partner_focus_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerTilePartnerImages extends StatelessWidget {
  const PlayerTilePartnerImages({
    super.key,
    required this.cardA,
    required this.cardB,
    required this.partnerFocus,
    required this.tileWidth,
    required this.runsTwoPartners,
    required this.imageVisibility,
  });

  final MtgCard? cardA;
  final MtgCard? cardB;

  final PartnerFocus partnerFocus;

  final double tileWidth;

  final bool runsTwoPartners;

  final ImageVisibility imageVisibility;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final lowestVisOpacity = theme.brightness == Brightness.dark
        ? lowestVisOpacityDark
        : lowestVisOpacityLight;
    final lowVisOpacity = theme.brightness == Brightness.dark
        ? lowVisOpacityDark
        : lowVisOpacityLight;
    final neutralOpacity = theme.brightness == Brightness.dark
        ? neutralOpacityDark
        : neutralOpacityLight;
    final highlightedOpacity = theme.brightness == Brightness.dark
        ? highlightedOpacityDark
        : highlightedOpacityLight;

    final double backgroundOpacity = switch (imageVisibility) {
      ImageVisibility.high => highlightedOpacity,
      ImageVisibility.normal => neutralOpacity,
      ImageVisibility.low => lowVisOpacity,
      ImageVisibility.lowest => lowestVisOpacity,
    };

    final color = switch (imageVisibility) {
      ImageVisibility.high => theme.brightness.opposite.contrast,
      _ => theme.colorScheme.surfaceContainerLow,
    };

    return context.counterSpell.cardsLogic.cardsAlignments.build((
      context,
      alignments,
    ) {
      final partnerA = PlayerTileSingleImage(
        alignments: alignments,
        card: cardA,
        backgroundOpacity: backgroundOpacity,
        color: color,
      );
      if (!runsTwoPartners) return partnerA;
      return PartnerSplit(
        shrinking: 0.1 * tileWidth,
        parallax: 0.23 * tileWidth,
        partnerFocus: partnerFocus,
        partnerA: partnerA,
        partnerB: PlayerTileSingleImage(
          alignments: alignments,
          card: cardB,
          backgroundOpacity: backgroundOpacity,
          color: color,
        ),
      );
    });
  }

  double get lowestVisOpacityDark => 0.82;
  double get lowVisOpacityDark => 0.75;
  double get neutralOpacityDark => 0.60;
  double get highlightedOpacityDark => 0.35;

  double get lowestVisOpacityLight => 0.90;
  double get lowVisOpacityLight => 0.83;
  double get neutralOpacityLight => 0.70;
  double get highlightedOpacityLight => 0.48;
}

class PlayerTileSingleImage extends StatelessWidget {
  const PlayerTileSingleImage({
    super.key,
    required this.card,
    required this.alignments,
    required this.backgroundOpacity,
    required this.color,
  });

  final MtgCard? card;
  final Map<String, Alignment> alignments;
  final double backgroundOpacity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final card = this.card;
    final url = card?.imageUrl();
    if (card == null || url == null) return const SizedBox.expand();
    return AnimatedContainer(
      duration: Motion.beginAndEndOnScreenEmphasized.duration,
      curve: Motion.beginAndEndOnScreenEmphasized.curve,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.cover,
          alignment: alignments[card.id] ?? Alignment.center,
          colorFilter: ColorFilter.mode(
            color.withValues(alpha: backgroundOpacity),
            BlendMode.srcOver,
          ),
        ),
      ),
    );
  }
}
