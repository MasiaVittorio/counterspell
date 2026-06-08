import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:counter_spell/widgets/arena/player_cell/builders/cell_mode_builder.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_bottom.dart';
import 'package:counter_spell/widgets/components/builders/attack_partner_toggle_builder.dart';
import 'package:counter_spell/widgets/components/builders/cell_mode_and_increment_builder.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';

class PlayerCellModeIcon extends StatelessWidget {
  const PlayerCellModeIcon({super.key, required this.playerIndex});

  final int playerIndex;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final controller = context.arenaPlayerController;
    final delay = context.delay;

    void stopAttacking() {
      controller.increment.update(0);
      delay.cancel();
      controller.cachedAttackerIndex.update(null);
      counterSpell.interactionLogic.attackingPlayerIndex.update(null);
    }

    void rawStartAttacking() {
      controller.increment.update(0);
      delay.cancel();
      controller.cachedAttackerIndex.update(null);
      counterSpell.interactionLogic.attackingPlayerIndex.update(playerIndex);
    }

    return SizedBox.square(
      dimension: PlayerCellBottom.iconButtonsSize,
      child: ArenaCellModeAndIncrementBuilder(
        playerIndex: playerIndex,
        child: null,
        builder: (context, mode, hasIncrement, _) {
          return AttackPartnerToggleBuilder(
            playerIndex: playerIndex,
            onStartAttacking: rawStartAttacking,
            onStopAttacking: stopAttacking,
            builder: (context, onStartAttacking, onKeepPressingAttack) {
              return switch (mode) {
                CellMode.life =>
                  hasIncrement
                      ? IgnorePointer(
                          child: Center(child: Icon(BodyPage.life.filledIcon)),
                        )
                      : InkResponse(
                          onTap: onStartAttacking,
                          child: const Center(
                            child: Icon(CounterSpellIcons.damage_outlined),
                          ),
                        ),
                CellMode.attacking => InkResponse(
                  onTap: onKeepPressingAttack,
                  child: const Center(child: Icon(CounterSpellIcons.attack)),
                ),
                CellMode.defending => InkResponse(
                  onTap: stopAttacking,
                  child: Center(
                    child: Icon(
                      hasIncrement
                          ? CounterSpellIcons.defense_filled
                          : CounterSpellIcons.defense_outlined,
                    ),
                  ),
                ),
              };
            },
          );
        },
      ),
    );
  }
}
