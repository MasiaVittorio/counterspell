import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/game/player_state.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/components/builders/animated_number_circle.dart';
import 'package:counter_spell/widgets/components/builders/attacker_index_builder.dart';
import 'package:counter_spell/widgets/components/builders/general_increment_builder.dart';
import 'package:counter_spell/widgets/components/builders/is_defending_builder.dart';
import 'package:counter_spell/widgets/components/builders/is_selected_builder.dart';
import 'package:counter_spell/widgets/components/builders/selected_counter_builder.dart';
import 'package:counter_spell/widgets/components/builders/using_partner_a_builder.dart';
import 'package:flutter/material.dart';

class PlayerTileNumberCircle extends StatelessWidget {
  const PlayerTileNumberCircle({
    super.key,
    required this.index,
    required this.playerState,
    required this.page,
  });

  final int index;
  final PlayerState playerState;
  final BodyPage page;

  @override
  Widget build(BuildContext context) {
    return AttackerIndexBuilder(
      builder: (context, attackerIndex, child) {
        final isAttacking = index == attackerIndex;
        return UsingPartnerABuilder(
          builder: (context, list, _) {
            final usingPartnerA = list[index];
            final bool isAttackerUsingPartnerA = attackerIndex == null
                ? false
                : list[attackerIndex];
            return IsSelectedBuilder(
              index: index,
              builder: (context, isSelected, _) {
                return GeneralIncrementBuilder(
                  builder: (context, increment, _) {
                    return IsDefendingBuilder(
                      index: index,
                      builder: (context, isDefending, _) {
                        return SelectedCounterBuilder(
                          builder: (context, selectedCounter, _) {
                            return _PlayerTileNumberCircle(
                              isAttacking: isAttacking,
                              page: page,
                              playerState: playerState,
                              usingPartnerA: usingPartnerA,
                              isAttackerUsingPartnerA: isAttackerUsingPartnerA,
                              isDefending: isDefending,
                              attackerIndex: attackerIndex,
                              increment: increment,
                              isSelected: isSelected,
                              selectedCounter: selectedCounter,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _PlayerTileNumberCircle extends StatelessWidget {
  const _PlayerTileNumberCircle({
    required this.isAttacking,
    required this.page,
    required this.playerState,
    required this.usingPartnerA,
    required this.isAttackerUsingPartnerA,
    required this.isDefending,
    required this.attackerIndex,
    required this.increment,
    required this.isSelected,
    required this.selectedCounter,
  });

  final bool isAttacking;
  final BodyPage page;
  final PlayerState playerState;
  final bool usingPartnerA;
  final bool isAttackerUsingPartnerA;
  final bool isDefending;
  final int? attackerIndex;
  final int increment;
  final bool? isSelected;
  final Counter selectedCounter;

  @override
  Widget build(BuildContext context) {
    return AnimatedNumberCircle(
      isAttacking: isAttacking,
      page: page,
      isSomeoneAttacking: attackerIndex != null,
      highlight: switch (page) {
        BodyPage.history => false,
        BodyPage.counters ||
        BodyPage.life ||
        BodyPage.cast => isSelected != false, // null is highlighted
        BodyPage.damage => isDefending || isAttacking,
      },
      value: switch (page) {
        BodyPage.life || BodyPage.history => playerState.life,
        BodyPage.counters => playerState.amountOfCounters(selectedCounter),
        BodyPage.cast => playerState.commanderCasts.of(usingPartnerA),
        BodyPage.damage => switch (attackerIndex) {
          null => 0,
          final int attacker => playerState.commanderDamageFrom(
            playerIndex: attacker,
            partnerA: isAttackerUsingPartnerA,
          ),
        },
      },
      increment: switch (page) {
        BodyPage.history => 0,
        BodyPage.counters ||
        BodyPage.life ||
        BodyPage.cast => switch (isSelected) {
          true => increment,
          false => 0,
          null => -increment,
        },
        BodyPage.damage => isDefending ? increment : 0,
      },
    );
  }
}
