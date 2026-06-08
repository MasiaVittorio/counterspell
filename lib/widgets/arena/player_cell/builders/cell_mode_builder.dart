import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

enum CellMode { life, attacking, defending }

class ArenaCellModeBuilder extends StatelessWidget {
  const ArenaCellModeBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  });

  static CellMode compute({
    required int? cachedAttackerIndex,
    required int? attackingPlayerIndex,
    required int playerIndex,
  }) {
    return switch (cachedAttackerIndex ?? attackingPlayerIndex) {
      -1 => CellMode.life,
      int a when a == playerIndex => CellMode.attacking,
      int _ => CellMode.defending,
      null => CellMode.life,
    };
  }

  final int playerIndex;
  final Widget? child;
  final Widget Function(BuildContext context, CellMode mode, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final generalInteraction = counterSpell.interactionLogic;
    final arenaPlayerController = context.arenaPlayerController;

    return _CellModeBuilder(
      playerIndex: playerIndex,
      attackingPlayerIndex: generalInteraction.attackingPlayerIndex,
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
    required this.child,
    required this.builder,
  });

  final int playerIndex;
  final Reactive<int?> attackingPlayerIndex;
  final Reactive<int?> cachedAttackerIndex;
  final Widget? child;
  final Widget Function(BuildContext context, CellMode mode, Widget? child)
  builder;

  @override
  State<_CellModeBuilder> createState() => _CellModeBuilderState();
}

class _CellModeBuilderState extends State<_CellModeBuilder> {
  CellMode mode = CellMode.life;

  @override
  void initState() {
    super.initState();
    mode = newValue();
    widget.attackingPlayerIndex.addListener(attackingListener);
    widget.cachedAttackerIndex.addListener(cachedListener);
  }

  @override
  void dispose() {
    widget.attackingPlayerIndex.removeListener(attackingListener);
    widget.cachedAttackerIndex.removeListener(cachedListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _CellModeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerIndex != widget.playerIndex) {
      mode = newValue();
    }
  }

  CellMode newValue() {
    return ArenaCellModeBuilder.compute(
      cachedAttackerIndex: widget.cachedAttackerIndex.value,
      attackingPlayerIndex: widget.attackingPlayerIndex.value,
      playerIndex: widget.playerIndex,
    );
  }

  void attackingListener() => update();
  void cachedListener() => update();

  void update() {
    if (!mounted) return;
    final v = newValue();
    if (v != mode) {
      setState(() {
        mode = v;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, mode, widget.child);
  }
}
