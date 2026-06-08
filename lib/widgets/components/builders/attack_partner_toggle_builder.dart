// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:counter_spell/logic/interaction_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/runs_partners_and_using_a_builder.dart';
import 'package:flutter/material.dart';

class AttackPartnerToggleBuilder extends StatelessWidget {
  const AttackPartnerToggleBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.onStartAttacking,
    required this.onStopAttacking,
    required this.builder,
  });

  final VoidCallback onStartAttacking;
  final VoidCallback onStopAttacking;
  final int playerIndex;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    VoidCallback onStartAttacking,
    VoidCallback onKeepPressingAttack,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    return RunsPartnersAndUsingABuilder(
      playerIndex: playerIndex,
      builder: (context, runsPartners, isUsingPartnerA, child) {
        return _AttackPartnerToggleBuilder(
          onStartAttacking: onStartAttacking,
          onStopAttacking: onStopAttacking,
          playerIndex: playerIndex,
          runsTwoPartners: runsPartners,
          isUsingPartnerA: isUsingPartnerA,
          interactionLogic: counterSpell.interactionLogic,
          builder: builder,
          child: child,
        );
      },
    );
  }
}

class _AttackPartnerToggleBuilder extends StatefulWidget {
  const _AttackPartnerToggleBuilder({
    required this.onStartAttacking,
    required this.onStopAttacking,
    required this.playerIndex,
    required this.child,
    required this.runsTwoPartners,
    required this.isUsingPartnerA,
    required this.interactionLogic,
    required this.builder,
  });

  final VoidCallback onStartAttacking;
  final VoidCallback onStopAttacking;
  final int playerIndex;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    VoidCallback onStartAttacking,
    VoidCallback onKeepPressingAttack,
  )
  builder;
  final bool runsTwoPartners;
  final bool isUsingPartnerA;
  final InteractionLogic interactionLogic;

  @override
  State<_AttackPartnerToggleBuilder> createState() =>
      _AttackPartnerToggleBuilderState();
}

class _AttackPartnerToggleBuilderState
    extends State<_AttackPartnerToggleBuilder> {
  bool wasUsingPartnerAWhenAttackingStarted = false;
  @override
  void initState() {
    super.initState();
    wasUsingPartnerAWhenAttackingStarted =
        widget.isUsingPartnerA && widget.runsTwoPartners;
  }

  @override
  Widget build(BuildContext context) {
    void onStartAttacking() {
      widget.onStartAttacking();
      wasUsingPartnerAWhenAttackingStarted =
          widget.isUsingPartnerA && widget.runsTwoPartners;
    }

    void togglePartner() {
      widget.interactionLogic.togglePartnerA(widget.playerIndex);
    }

    void onKeepPressingAttack() {
      if (!widget.runsTwoPartners) {
        widget.onStopAttacking();
        return;
      }
      if (wasUsingPartnerAWhenAttackingStarted == widget.isUsingPartnerA) {
        togglePartner();
        return;
      }
      widget.onStopAttacking();
      return;
    }

    return widget.builder(context, onStartAttacking, onKeepPressingAttack);
  }
}
