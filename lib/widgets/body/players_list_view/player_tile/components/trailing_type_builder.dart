import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

enum PlayerTileTrailingType { none, partnerSwap, incrementInversion }

class TrailingTypeBuilder extends StatelessWidget {
  const TrailingTypeBuilder({
    super.key,
    this.child,
    required this.builder,
    required this.index,
    required this.playerSettings,
    required this.page,
  });

  final Widget? child;
  final Widget Function(
    BuildContext context,
    PlayerTileTrailingType type,
    bool usingPartnerA,
    bool isInverted,
    Widget? child,
  )
  builder;

  final int index;
  final PlayerSettings playerSettings;
  final BodyPage page;

  @override
  Widget build(BuildContext context) {
    final interactionLogic = context.counterSpell.interactionLogic;
    return _TrailingTypeBuilder(
      playersMultiSelection: interactionLogic.playersMultiSelection,
      attackerIndex: interactionLogic.attackingPlayerIndex,
      usingPartnerA: interactionLogic.usingPartnerA,
      index: index,
      builder: builder,
      bodyPage: page,
      playerSettings: playerSettings,
      child: child,
    );
  }
}

class _TrailingTypeBuilder extends StatefulWidget {
  const _TrailingTypeBuilder({
    required this.child,
    required this.playersMultiSelection,
    required this.attackerIndex,
    required this.index,
    required this.builder,
    required this.bodyPage,
    required this.playerSettings,
    required this.usingPartnerA,
  });

  final Widget? child;
  final Widget Function(
    BuildContext context,
    PlayerTileTrailingType type,
    bool usingPartnerA,
    bool isInverted,
    Widget? child,
  )
  builder;

  final Reactive<List<bool>> usingPartnerA;
  final Reactive<List<bool?>> playersMultiSelection;
  final Reactive<int?> attackerIndex;
  final BodyPage bodyPage;
  final int index;
  final PlayerSettings playerSettings;

  @override
  State<_TrailingTypeBuilder> createState() => _TrailingTypeBuilderState();
}

class _TrailingTypeBuilderState extends State<_TrailingTypeBuilder> {
  late PlayerTileTrailingType type;
  late bool usingPartnerA;
  late bool isInverted;

  @override
  void initState() {
    super.initState();
    type = calculateType();
    usingPartnerA = widget.usingPartnerA.value[widget.index];
    isInverted = widget.playersMultiSelection.value[widget.index] == null;
    widget.playersMultiSelection.addListener(playersMultiSelectionListener);
    widget.attackerIndex.addListener(attackerIndexListener);
    widget.usingPartnerA.addListener(usingPartnerAListener);
  }

  @override
  void dispose() {
    widget.playersMultiSelection.removeListener(playersMultiSelectionListener);
    widget.attackerIndex.removeListener(attackerIndexListener);
    widget.usingPartnerA.removeListener(usingPartnerAListener);
    super.dispose();
  }

  void playersMultiSelectionListener() {
    if (!mounted) return;
    final t = calculateType();
    if (widget.index >= widget.playersMultiSelection.value.length) return;
    final i = widget.playersMultiSelection.value[widget.index] == null;
    if (i != isInverted || t != type) {
      setState(() {
        isInverted = i;
        type = t;
      });
    }
  }

  void attackerIndexListener() {
    if (!mounted) return;
    final t = calculateType();
    if (t != type) {
      setState(() {
        type = t;
      });
    }
  }

  void usingPartnerAListener() {
    if (!mounted) return;
    if (widget.index >= widget.usingPartnerA.value.length) return;
    final p = widget.usingPartnerA.value[widget.index];
    if (p != usingPartnerA) {
      setState(() {
        usingPartnerA = p;
      });
    }
  }

  PlayerTileTrailingType calculateType() {
    final bool isAttacking = widget.attackerIndex.value == widget.index;
    if (widget.index >= widget.playersMultiSelection.value.length) {
      return PlayerTileTrailingType.none;
    }

    final isSelected = widget.playersMultiSelection.value[widget.index];
    final activePlayersCount = widget.playersMultiSelection.value
        .where((e) => e != false)
        .length;

    return switch (widget.bodyPage) {
      BodyPage.life when isSelected != false && activePlayersCount > 1 =>
        PlayerTileTrailingType.incrementInversion,
      BodyPage.damage
          when isAttacking && widget.playerSettings.runsTwoPartners =>
        PlayerTileTrailingType.partnerSwap,
      BodyPage.cast when widget.playerSettings.runsTwoPartners =>
        PlayerTileTrailingType.partnerSwap,
      _ => PlayerTileTrailingType.none,
    };
  }

  @override
  void didUpdateWidget(covariant _TrailingTypeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bodyPage != widget.bodyPage) {
      type = calculateType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      type,
      usingPartnerA,
      isInverted,
      widget.child,
    );
  }
}
