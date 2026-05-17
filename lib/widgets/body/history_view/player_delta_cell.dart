import 'dart:async';

import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/logic/settings_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/models/game/player_state.dart';
import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:counter_spell/widgets/components/project/delta_chip.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerDeltaCell extends StatelessWidget {
  const PlayerDeltaCell({
    super.key,
    required this.playerStateDeltas,
    required this.timeStamp,
    required this.thisPlayerIndex,
    required this.playerSettings,
    required this.finalPlayerStates,
    required this.arenaView,
  });

  final DateTime timeStamp;
  final int thisPlayerIndex;
  final List<PlayerState> finalPlayerStates;
  final List<PlayerStateDelta> playerStateDeltas;
  final List<PlayerSettings> playerSettings;
  final bool arenaView;

  @override
  Widget build(BuildContext context) {
    final PlayerState thisFinalPlayerState = finalPlayerStates[thisPlayerIndex];
    final PlayerSettings thisPlayerSettings = playerSettings[thisPlayerIndex];
    final PlayerStateDelta thisPlayerDelta = playerStateDeltas[thisPlayerIndex];

    final List<CommanderDamage> damageDealtDelta = [
      for (final playerStateDelta in playerStateDeltas)
        playerStateDelta.commanderDamageTaken[thisPlayerIndex],
    ];

    final theme = context.theme;
    final layout = theme.layout;
    final isEmpty =
        PlayerStateDelta.zero(
              playerCount: thisPlayerDelta.commanderDamageTaken.length,
            ) ==
            thisPlayerDelta &&
        damageDealtDelta.every(
          (element) => element == (fromPartnerA: 0, fromPartnerB: 0),
        );

    final stampStyle = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100),
      child: Material(
        borderRadius: BorderRadius.circular(layout.radius.medium),
        color: theme.colorScheme.surfaceContainerLowest,
        child: Pad(
          horizontal: layout.padding.small,
          bottom: layout.padding.tiny,
          top: !isEmpty ? layout.padding.tiny : layout.padding.small,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEmpty)
                arenaView
                    ? Text(thisPlayerSettings.name, style: stampStyle)
                    : HistoryTimeStamp(timeStamp, style: stampStyle),
              Expanded(
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: layout.spacing.small,
                  runSpacing: layout.spacing.small,
                  children: [
                    if (thisPlayerDelta.life != 0)
                      DeltaChip(
                        icon: InteractionMode.life.filledIcon,
                        increment: thisPlayerDelta.life,
                        result: thisFinalPlayerState.life,
                      ),
                    if (thisPlayerDelta.counters.isNotEmpty)
                      for (final counter in Counter.values)
                        if (thisPlayerDelta.counters[counter] case int amount)
                          if (amount != 0)
                            DeltaChip(
                              icon: counter.filledIcon,
                              increment: amount,
                              result:
                                  thisFinalPlayerState.counters[counter] ?? 0,
                            ),
                    for (
                      int i = 0;
                      i < thisPlayerDelta.commanderDamageTaken.length;
                      i++
                    ) ...[
                      if (thisPlayerDelta.commanderDamageTaken[i].fromPartnerA
                          case int damage)
                        if (damage != 0)
                          DeltaChip(
                            icon: CounterSpellIcons.defense_filled,
                            increment: damage,
                            note: switch (playerSettings[i].runsTwoPartners) {
                              true => 'by ${playerSettings[i].name} (A)',
                              false => 'by ${playerSettings[i].name}',
                            },
                            result: thisFinalPlayerState
                                .commanderDamageTaken[i]
                                .fromPartnerA,
                          ),
                      if (thisPlayerDelta.commanderDamageTaken[i].fromPartnerB
                          case int damage)
                        if (damage != 0)
                          DeltaChip(
                            icon: CounterSpellIcons.defense_filled,
                            note: 'by ${playerSettings[i].name} (B)',
                            increment: damage,
                            result: thisFinalPlayerState
                                .commanderDamageTaken[i]
                                .fromPartnerB,
                          ),
                    ],

                    for (int i = 0; i < damageDealtDelta.length; i++) ...[
                      if (damageDealtDelta[i].fromPartnerA case int damage)
                        if (damage != 0)
                          DeltaChip(
                            icon: CounterSpellIcons.attack,
                            increment: damage,
                            note: switch (thisPlayerSettings.runsTwoPartners) {
                              true => 'to ${playerSettings[i].name} (A)',
                              false => 'to ${playerSettings[i].name}',
                            },
                            result: finalPlayerStates[i]
                                .commanderDamageTaken[thisPlayerIndex]
                                .fromPartnerA,
                          ),
                      if (damageDealtDelta[i].fromPartnerB case int damage)
                        if (damage != 0)
                          DeltaChip(
                            icon: CounterSpellIcons.attack,
                            note: 'to ${playerSettings[i].name} (B)',
                            increment: damage,
                            result: finalPlayerStates[i]
                                .commanderDamageTaken[thisPlayerIndex]
                                .fromPartnerB,
                          ),
                    ],

                    if (thisPlayerDelta.commanderCasts.partnerA case int castsA)
                      if (castsA != 0)
                        DeltaChip(
                          icon: InteractionMode.cast.filledIcon,
                          note: switch (thisPlayerSettings.runsTwoPartners) {
                            true => 'Partner A',
                            false => null,
                          },
                          increment: castsA,
                          result: thisFinalPlayerState.commanderCasts.partnerA,
                        ),
                    if (thisPlayerDelta.commanderCasts.partnerB case int castsB)
                      if (castsB != 0)
                        DeltaChip(
                          icon: InteractionMode.cast.filledIcon,
                          note: 'Partner B',
                          increment: castsB,
                          result: thisFinalPlayerState.commanderCasts.partnerB,
                        ),
                  ],
                ),
              ),
            ].separateWith(Space.vertical(layout.spacing.medium)),
          ),
        ),
      ),
    );
  }
}

class HistoryTimeStamp extends StatelessWidget {
  const HistoryTimeStamp(
    this.timeStamp, {
    super.key,
    this.style,
    this.overrideMode,
  }) : builder = null;
  const HistoryTimeStamp.builder(
    this.timeStamp, {
    super.key,
    required Widget Function(BuildContext context, String formattedText)
    this.builder,
    this.overrideMode,
  }) : style = null;

  final TextStyle? style;
  final DateTime timeStamp;
  final HistoryTimeStampMode? overrideMode;

  final Widget Function(BuildContext context, String formattedText)? builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    return (
      counterSpell.settingsLogic.historyTimeStampMode,
      counterSpell.settingsLogic.force24H,
    ).build(
      (context, mode, force) => _Ticking(
        builder: (context) {
          final formattedText = (overrideMode ?? mode).format(timeStamp, force);
          return builder?.call(context, formattedText) ??
              Text(formattedText, style: style);
        },
      ),
    );
  }
}

class _Ticking extends StatefulWidget {
  const _Ticking({required this.builder});

  final WidgetBuilder builder;

  @override
  State<_Ticking> createState() => _TickingState();
}

class _TickingState extends State<_Ticking> {
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000), callback);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void callback(Timer timer) {
    if (!mounted) {
      if (timer.isActive) timer.cancel();
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
