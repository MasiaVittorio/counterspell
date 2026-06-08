// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/game.dart';
import 'package:counter_spell/widgets/components/builders/double_map_builder.dart';
import 'package:flutter/material.dart';

class RunsPartnersAndUsingABuilder extends StatelessWidget {
  const RunsPartnersAndUsingABuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  });

  final Widget? child;
  final int playerIndex;
  final Widget Function(
    BuildContext context,
    bool runsPartners,
    bool isUsingPartnerA,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    return DoubleMapBuilder<Game, List<bool>, ({bool runsTwo, bool usingA})>(
      reactiveA: counterSpell.gameLogic.gameReactive,
      reactiveB: counterSpell.interactionLogic.usingPartnerA,
      keys: [playerIndex],
      map: (game, using) {
        final playersSettings = game.settings.playerSettings;
        if (playerIndex >= playersSettings.length) {
          return (runsTwo: false, usingA: true);
        }
        if (!playersSettings[playerIndex].runsTwoPartners) {
          return (runsTwo: false, usingA: true);
        }
        if (playerIndex >= using.length) {
          return (runsTwo: false, usingA: true);
        }
        return (runsTwo: true, usingA: using[playerIndex]);
      },
      child: child,
      builder: (context, value, child) =>
          builder(context, value.runsTwo, value.usingA, child),
    );
  }
}
