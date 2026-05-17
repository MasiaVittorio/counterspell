import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:counter_spell/widgets/arena/player_cell/builders/cell_mode_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ArenaCellModeAndIncrementBuilder extends StatelessWidget {
  const ArenaCellModeAndIncrementBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  });

  final int playerIndex;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    CellMode mode,
    bool hasIncrement,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final generalInteraction = counterSpell.interactionLogic;
    final arenaPlayerController = context.arenaPlayerController;

    return _CellModeBuilder(
      playerIndex: playerIndex,
      attackingPlayerIndex: generalInteraction.attackingPlayerIndex,
      increment: arenaPlayerController.increment,
      cachedAttackerIndex: arenaPlayerController.cachedAttackerIndex,
      builder: builder,
      child: child,
    );
  }
}

class _CellModeBuilder extends StatefulWidget {
  const _CellModeBuilder({
    required this.playerIndex,
    required this.attackingPlayerIndex,
    required this.cachedAttackerIndex,
    required this.increment,
    required this.child,
    required this.builder,
  });

  final int playerIndex;
  final Reactive<int?> attackingPlayerIndex;
  final Reactive<int?> cachedAttackerIndex;
  final Reactive<int> increment;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    CellMode mode,
    bool hasIncrement,
    Widget? child,
  )
  builder;

  @override
  State<_CellModeBuilder> createState() => _CellModeBuilderState();
}

class _CellModeBuilderState extends State<_CellModeBuilder> {
  CellMode mode = CellMode.life;
  bool hasIncrement = false;

  @override
  void initState() {
    super.initState();
    final v = newValue();
    mode = v.mode;
    hasIncrement = v.hasIncrement;
    widget.attackingPlayerIndex.addListener(attackingListener);
    widget.increment.addListener(incrementListener);
    widget.cachedAttackerIndex.addListener(cachedListener);
  }

  @override
  void dispose() {
    widget.attackingPlayerIndex.removeListener(attackingListener);
    widget.increment.removeListener(incrementListener);
    widget.cachedAttackerIndex.removeListener(cachedListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _CellModeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerIndex != widget.playerIndex) {
      final v = newValue();
      mode = v.mode;
      hasIncrement = v.hasIncrement;
    }
  }

  ({CellMode mode, bool hasIncrement}) newValue() => (
    mode: ArenaCellModeBuilder.compute(
      cachedAttackerIndex: widget.cachedAttackerIndex.value,
      attackingPlayerIndex: widget.attackingPlayerIndex.value,
      playerIndex: widget.playerIndex,
    ),
    hasIncrement: widget.increment.value != 0,
  );

  void attackingListener() => update();
  void incrementListener() => update();
  void cachedListener() => update();

  void update() {
    if (!mounted) return;
    final v = newValue();
    if (v.mode != mode || v.hasIncrement != hasIncrement) {
      setState(() {
        mode = v.mode;
        hasIncrement = v.hasIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, mode, hasIncrement, widget.child);
  }
}
