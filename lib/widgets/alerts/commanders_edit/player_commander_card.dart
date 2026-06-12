import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/widgets/alerts/commanders_edit/commander_image_tile.dart';
import 'package:counter_spell/widgets/alerts/commanders_edit/damage_properties_buttons.dart';
import 'package:counter_spell/widgets/components/builders/card_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCommanderCard extends StatelessWidget {
  const PlayerCommanderCard({
    super.key,
    required this.playerSettings,
    required this.onChanged,
    required this.partnerA,
    required this.focusSettings,
  });

  final PlayerSettings playerSettings;
  final ValueChanged<PlayerSettings>? onChanged;
  final bool partnerA;
  final bool focusSettings;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return GroupedCard(
      isFirst: partnerA,
      marginAnimationDuration: Durations.long2,
      isLast: switch ((partnerA, playerSettings.runsTwoPartners)) {
        (true, true) => false,
        (true, false) => true,
        (false, _) => true,
      },
      child: CardBuilder.advanced(
        id: playerSettings.commanders.partner(partnerA),
        advancedBuilder: (context, card, isLoading, error, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CommanderImageTile(
              onChanged: onChanged,
              playerSettings: playerSettings,
              partnerA: partnerA,
              card: card,
              isLoading: isLoading,
              error: error,
              dense: focusSettings,
            ),
            AnimatedListed(
              duration: Motion.beginAndEndOnScreenEmphasized.duration,
              curve: Motion.beginAndEndOnScreenEmphasized.curve,
              listed: focusSettings,
              child: Row(
                children: [
                  Expanded(
                    child: Pad(
                      horizontal: theme.layout.padding.medium,
                      bottom: theme.layout.padding.medium,
                      child: DamagePropertiesButtons(
                        onChanged: onChanged,
                        playerSettings: playerSettings,
                        partnerA: partnerA,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
