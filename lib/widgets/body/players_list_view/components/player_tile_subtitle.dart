// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_spell/models/game/game_settings.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/components/builders/attacker_index_builder.dart';
import 'package:counter_spell/widgets/components/builders/card_builder.dart';
import 'package:counter_spell/widgets/components/builders/is_defending_builder.dart';
import 'package:counter_spell/widgets/components/builders/is_selected_builder.dart';
import 'package:counter_spell/widgets/components/builders/using_partner_a_builder.dart';
import 'package:counter_spell/widgets/components/common/new_animated_listed.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerTileSubtitle extends StatelessWidget {
  const PlayerTileSubtitle({
    super.key,
    required this.page,
    required this.gameSettings,
    required this.settings,
    required this.index,
  });

  final PlayerSettings settings;
  final int index;

  final BodyPage page;
  final GameSettings gameSettings;

  @override
  Widget build(BuildContext context) {
    return AttackerIndexBuilder(
      builder: (context, attackerIndex, child) {
        final PlayerSettings? attackerSettings = attackerIndex == null
            ? null
            : gameSettings.playerSettings[attackerIndex];

        final isAttacking = index == attackerIndex;

        return IsSelectedBuilder(
          index: index,
          builder: (context, isSelected, child) {
            return NewAnimatedListed(
              listed: switch (page) {
                BodyPage.life when isSelected == null => true,
                BodyPage.damage when attackerIndex != null => true,
                _ => false,
              },
              child: UsingPartnerABuilder(
                builder: (context, value, _) {
                  final bool isAttackerUsingPartnerA = attackerIndex != null
                      ? value[attackerIndex]
                      : false;
                  final usingPartnerA = value[index];

                  return CardBuilder(
                    id: attackerSettings?.commanders.partner(
                      isAttackerUsingPartnerA,
                    ),
                    builder: (context, card, _) {
                      return IsDefendingBuilder(
                        index: index,
                        builder: (context, isDefending, _) {
                          return _PlayerTileSubtitle(
                            page: page,
                            isSelected: isSelected,
                            isAttacking: isAttacking,
                            settings: settings,
                            usingPartnerA: usingPartnerA,
                            isDefending: isDefending,
                            attackerSettings: attackerSettings,
                            isAttackerUsingPartnerA: isAttackerUsingPartnerA,
                            card: card,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _PlayerTileSubtitle extends StatelessWidget {
  const _PlayerTileSubtitle({
    required this.page,
    required this.isSelected,
    required this.isAttacking,
    required this.settings,
    required this.usingPartnerA,
    required this.isDefending,
    required this.attackerSettings,
    required this.isAttackerUsingPartnerA,
    required this.card,
  });

  final BodyPage page;
  final bool? isSelected;
  final bool isAttacking;
  final PlayerSettings settings;
  final bool usingPartnerA;
  final bool isDefending;
  final PlayerSettings? attackerSettings;
  final bool isAttackerUsingPartnerA;
  final MtgCard? card;

  @override
  Widget build(BuildContext context) {
    final attackerSettings = this.attackerSettings;
    final card = this.card;

    final text = switch (page) {
      BodyPage.life when isSelected == null => 'Opposite increment',
      BodyPage.damage
          when isAttacking && settings.runsTwoPartners && card == null =>
        'Attacking with ${usingPartnerA ? "A" : "B"}',
      BodyPage.damage when isAttacking && settings.runsTwoPartners =>
        'Attacking with ${card?.name}',
      BodyPage.damage when isAttacking && isDefending => 'Attacking themselves',
      BodyPage.damage when isAttacking => 'Attacking',
      BodyPage.damage
          when !isAttacking &&
              attackerSettings != null &&
              attackerSettings.runsTwoPartners == true &&
              card == null =>
        'Damage from ${attackerSettings.name} (${isAttackerUsingPartnerA ? "A" : "B"})',
      BodyPage.damage
          when !isAttacking &&
              attackerSettings != null &&
              attackerSettings.runsTwoPartners == true =>
        'Damage from ${card?.name}',
      BodyPage.damage
          when !isAttacking && attackerSettings != null && card == null =>
        'Damage from ${attackerSettings.name}',
      BodyPage.damage when !isAttacking && attackerSettings != null =>
        'Damage from ${card?.name}',
      _ => '',
    };

    return Row(
      children: [
        Expanded(
          child: Opacity(
            opacity: switch (page) {
              BodyPage.life => isSelected == false ? 0.8 : 1,
              BodyPage.damage => isAttacking || isDefending ? 1 : 0.8,
              _ => 0.8,
            },
            child: AnimatedText(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
