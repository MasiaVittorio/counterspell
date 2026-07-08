import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/models/game/player_state.dart';
import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:counter_spell/widgets/arena/player_cell/builders/cell_mode_builder.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/split_theme.dart';
import 'package:counter_spell/widgets/components/builders/cell_mode_and_increment_builder.dart';
import 'package:counter_spell/widgets/components/builders/player_cards_and_themes_builder.dart';
import 'package:counter_spell/widgets/components/project/delta_chip.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

extension on String {
  String get initial => isEmpty ? this : this[0];
}

/// Which subset of quick-info chips a [PlayerCellQuickInfo] renders, so the two
/// groups can be pinned to opposite sides of the cell.
enum QuickInfoGroup {
  /// Commander damage taken (and dealt, when [PlayerCellQuickInfo.showDamageDealt]).
  commanderDamage,

  /// Counters, statuses and commander casts.
  other,
}

class PlayerCellQuickInfo extends StatelessWidget {
  const PlayerCellQuickInfo({
    super.key,
    required this.playerIndex,
    required this.axisAlignment,
    required this.group,
    this.showDamageDealt = false,
  });
  final int playerIndex;
  final double axisAlignment;
  final QuickInfoGroup group;
  final bool showDamageDealt;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: axisAlignment == -1 ? context.rightTheme : context.leftTheme,
      child: ArenaCellModeAndIncrementBuilder(
        playerIndex: playerIndex,
        child: context.counterSpell.gameLogic.buildWithGame(
          (context, game) => _PlayerCellQuickInfo(
            playerIndex: playerIndex,
            playerSettings: game.settings.playerSettings,
            playerStates: game.currentState.playerStates,
            group: group,
            showDamageDealt: showDamageDealt,
          ),
        ),
        builder: (context, mode, hasIncrement, child) => Al.topCenter(
          child: AnimatedListed(
            direction: Axis.horizontal,
            axisAlignment: axisAlignment,
            listed: mode == CellMode.life && !hasIncrement,
            duration: Durations.medium4,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PlayerCellQuickInfo extends StatelessWidget {
  const _PlayerCellQuickInfo({
    required this.playerIndex,
    required this.playerSettings,
    required this.playerStates,
    required this.group,
    required this.showDamageDealt,
  });

  final int playerIndex;
  final List<PlayerState> playerStates;
  final List<PlayerSettings> playerSettings;
  final QuickInfoGroup group;
  final bool showDamageDealt;

  @override
  Widget build(BuildContext context) {
    final PlayerSettings thisPlayerSettings = playerSettings[playerIndex];
    final PlayerState thisPlayerState = playerStates[playerIndex];

    final List<CommanderDamage> damageDealt = [
      for (final playerStateDelta in playerStates)
        playerStateDelta.commanderDamageTaken[playerIndex],
    ];

    final theme = context.theme;
    final layout = theme.layout;

    final List<Widget> chips = switch (group) {
      QuickInfoGroup.commanderDamage => <Widget>[
        for (
          int i = 0;
          i < thisPlayerState.commanderDamageTaken.length;
          i++
        ) ...[
          if (thisPlayerState.commanderDamageTaken[i].fromPartnerA
              case int damage)
            if (damage != 0)
              _CommanderDamageChip(
                attackerIndex: i,
                fromPartnerA: true,
                icon: CounterSpellIcons.defense_filled,
                result: damage,
                note: switch (playerSettings[i].runsTwoPartners) {
                  true => 'by ${playerSettings[i].name.initial} (A)',
                  false => 'by ${playerSettings[i].name.initial}',
                },
              ),
          if (thisPlayerState.commanderDamageTaken[i].fromPartnerB
              case int damage)
            if (damage != 0)
              _CommanderDamageChip(
                attackerIndex: i,
                fromPartnerA: false,
                icon: CounterSpellIcons.defense_filled,
                result: damage,
                note: 'by ${playerSettings[i].name.initial} (B)',
              ),
        ],
        if (showDamageDealt)
          for (int i = 0; i < damageDealt.length; i++) ...[
            if (damageDealt[i].fromPartnerA case int damage)
              if (damage != 0)
                _CommanderDamageChip(
                  attackerIndex: playerIndex,
                  fromPartnerA: true,
                  icon: CounterSpellIcons.attack,
                  result: damage,
                  note: switch (thisPlayerSettings.runsTwoPartners) {
                    true => 'to ${playerSettings[i].name.initial} (A)',
                    false => 'to ${playerSettings[i].name.initial}',
                  },
                ),
            if (damageDealt[i].fromPartnerB case int damage)
              if (damage != 0)
                _CommanderDamageChip(
                  attackerIndex: playerIndex,
                  fromPartnerA: false,
                  icon: CounterSpellIcons.attack,
                  result: damage,
                  note: 'to ${playerSettings[i].name.initial} (B)',
                ),
          ],
      ],
      QuickInfoGroup.other => <Widget>[
        if (thisPlayerState.counters.isNotEmpty)
          for (final counter in Counter.values)
            if (thisPlayerState.counters[counter] case int amount)
              if (amount != 0)
                DeltaChip.result(
                  icon: counter.filledIcon,
                  result: amount,
                  boolean: counter.isBoolean,
                ),
        if (thisPlayerState.commanderCasts.partnerA case int castsA)
          if (castsA != 0)
            DeltaChip.result(
              icon: InteractionMode.cast.filledIcon,
              note: switch (thisPlayerSettings.runsTwoPartners) {
                true => 'A',
                false => null,
              },
              result: castsA,
            ),
        if (thisPlayerState.commanderCasts.partnerB case int castsB)
          if (castsB != 0)
            DeltaChip.result(
              icon: InteractionMode.cast.filledIcon,
              note: 'B',
              result: castsB,
            ),
        // TODO: add is dead chip
      ],
    };

    if (chips.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: CallbackScrollPhysics(
        bottomBounce: true,
        topBounce: true,
        topBounceCallback: () {},
        bottomBounceCallback: () {},
      ),
      child: Pad(
        horizontal: layout.padding.small,
        vertical: layout.padding.smaller,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: chips.separateWith(Space.vertical(layout.spacing.tiny)),
        ),
      ),
    );
  }
}

/// A commander-damage [DeltaChip] themed by the commander that applied the
/// damage — [attackerIndex]'s partner A or B theme — so the pill takes that
/// commander's container color with a legible on-container foreground.
class _CommanderDamageChip extends StatelessWidget {
  const _CommanderDamageChip({
    required this.attackerIndex,
    required this.fromPartnerA,
    required this.icon,
    required this.result,
    this.note,
  });

  final int attackerIndex;
  final bool fromPartnerA;
  final IconData icon;
  final int result;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return PlayerCardsAndThemesBuilder(
      playerIndex: attackerIndex,
      builder: (context, cardA, cardB, themeA, themeB, child) {
        return Theme(
          data: fromPartnerA ? themeA : themeB,
          child: DeltaChip.result(icon: icon, result: result, note: note),
        );
      },
    );
  }
}
