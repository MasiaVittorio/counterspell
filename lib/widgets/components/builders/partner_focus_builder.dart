import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:flutter/material.dart';

enum PartnerFocus { both, partnerA, partnerB }

class PartnerFocusBuilder extends StatelessWidget {
  const PartnerFocusBuilder.listView({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  }) : considerBodyPage = true;

  const PartnerFocusBuilder.arenaView({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  }) : considerBodyPage = false;

  final int playerIndex;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    PartnerFocus focus,
    bool runsTwoPartners,
    Widget? child,
  )
  builder;
  final bool considerBodyPage;

  @override
  Widget build(BuildContext context) {
    return _PartnerFocusBuilder(
      playerIndex: playerIndex,
      counterSpell: context.counterSpell,
      considerBodyPage: considerBodyPage,
      builder: builder,
      child: child,
    );
  }
}

class _PartnerFocusBuilder extends StatefulWidget {
  const _PartnerFocusBuilder({
    required this.playerIndex,
    required this.counterSpell,
    required this.child,
    required this.builder,
    required this.considerBodyPage,
  });

  final int playerIndex;
  final CounterSpell counterSpell;
  final Widget? child;
  final bool considerBodyPage;
  final Widget Function(
    BuildContext context,
    PartnerFocus focus,
    bool runsTwoPartners,
    Widget? child,
  )
  builder;

  @override
  State<_PartnerFocusBuilder> createState() => _PartnerFocusBuilderState();
}

class _PartnerFocusBuilderState extends State<_PartnerFocusBuilder> {
  PartnerFocus partnerFocus = PartnerFocus.partnerA;
  bool runsTwoPartners = false;

  @override
  void initState() {
    super.initState();
    final v = newValue();
    partnerFocus = v.focus;
    runsTwoPartners = v.runsTwo;
    widget.counterSpell.interactionLogic.attackingPlayerIndex.addListener(
      attackingListener,
    );
    widget.counterSpell.interactionLogic.usingPartnerA.addListener(
      usingPartnerAListener,
    );
    widget.counterSpell.gameLogic.gameReactive.addListener(gameListener);
    if (widget.considerBodyPage) {
      widget.counterSpell.pagesLogic.bodyPage.addListener(pageListener);
    }
  }

  @override
  void dispose() {
    widget.counterSpell.interactionLogic.attackingPlayerIndex.removeListener(
      attackingListener,
    );
    widget.counterSpell.interactionLogic.usingPartnerA.removeListener(
      usingPartnerAListener,
    );
    widget.counterSpell.gameLogic.gameReactive.removeListener(gameListener);
    if (widget.considerBodyPage) {
      widget.counterSpell.pagesLogic.bodyPage.removeListener(pageListener);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _PartnerFocusBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerIndex != widget.playerIndex ||
        oldWidget.considerBodyPage != widget.considerBodyPage) {
      final v = newValue();
      partnerFocus = v.focus;
      runsTwoPartners = v.runsTwo;
    }
  }

  ({PartnerFocus focus, bool runsTwo}) newValue() {
    final playersSettings = widget
        .counterSpell
        .gameLogic
        .gameReactive
        .value
        .settings
        .playerSettings;

    final index = widget.playerIndex;

    if (index >= playersSettings.length) {
      return (focus: PartnerFocus.partnerA, runsTwo: false);
    }

    if (playersSettings[widget.playerIndex].runsTwoPartners == false) {
      return (focus: PartnerFocus.partnerA, runsTwo: false);
    }
    final interactionLogic = widget.counterSpell.interactionLogic;

    final usingPartnerA = interactionLogic.usingPartnerA.value;
    if (index >= usingPartnerA.length) {
      return (focus: PartnerFocus.partnerA, runsTwo: true);
    }
    final isUsingPartnerA =
        interactionLogic.usingPartnerA.value[widget.playerIndex];

    final isThisAttacking =
        interactionLogic.attackingPlayerIndex.value == widget.playerIndex;

    final InteractionMode? interactionMode = widget.considerBodyPage
        ? widget.counterSpell.pagesLogic.bodyPage.value.toInteractionMode()
        : interactionLogic.attackingPlayerIndex.value != null
        ? InteractionMode.damage
        : InteractionMode.life;

    return (
      focus: switch (interactionMode) {
        InteractionMode.damage when isThisAttacking =>
          isUsingPartnerA ? PartnerFocus.partnerA : PartnerFocus.partnerB,
        InteractionMode.cast =>
          isUsingPartnerA ? PartnerFocus.partnerA : PartnerFocus.partnerB,
        _ => PartnerFocus.both,
      },
      runsTwo: true,
    );
  }

  void attackingListener() => update();
  void usingPartnerAListener() => update();
  void pageListener() => update();
  void gameListener() => update();

  void update() {
    if (!mounted) return;
    final v = newValue();
    if (v.focus != partnerFocus || v.runsTwo != runsTwoPartners) {
      setState(() {
        partnerFocus = v.focus;
        runsTwoPartners = v.runsTwo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, partnerFocus, runsTwoPartners, widget.child);
  }
}
