import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/decoration/partner_split.dart';
import 'package:counter_spell/widgets/components/builders/partner_focus_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerTilePartnerBorders extends StatelessWidget {
  const PlayerTilePartnerBorders({
    super.key,
    required this.cardA,
    required this.cardB,
    required this.themeA,
    required this.themeB,
    required this.partnerFocus,
    required this.borderRadius,
    required this.runsTwoPartners,
    required this.showBorder,
  });

  final MtgCard? cardA;
  final MtgCard? cardB;
  final ThemeData themeA;
  final ThemeData themeB;

  final PartnerFocus partnerFocus;

  final BorderRadius borderRadius;

  final bool runsTwoPartners;

  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final partnerABorder = PlayerTileSingleBorder(
      card: cardA,
      theme: themeA,
      showBorder: showBorder,
      borderRadius: borderRadius,
    );

    if (!runsTwoPartners) return partnerABorder;

    return PartnerSplit(
      shrinking: 0,
      parallax: 0,
      partnerFocus: partnerFocus,
      partnerA: partnerABorder,
      partnerB: runsTwoPartners
          ? PlayerTileSingleBorder(
              card: cardB,
              theme: themeB,
              showBorder: showBorder,
              borderRadius: borderRadius,
            )
          : null,
    );
  }
}

class PlayerTileSingleBorder extends StatelessWidget {
  const PlayerTileSingleBorder({
    super.key,
    required this.showBorder,
    required this.card,
    required this.theme,
    required this.borderRadius,
  });

  final bool showBorder;
  final BorderRadius borderRadius;
  final MtgCard? card;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Motion.beginAndEndOnScreenEmphasized.duration,
      curve: Motion.beginAndEndOnScreenEmphasized.curve,
      decoration: BoxDecoration(
        border: showBorder
            ? Border.all(color: theme.colorScheme.primary, width: 2)
            : null,
        borderRadius: borderRadius,
      ),
    );
  }
}
