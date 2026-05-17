import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

enum MoreMode { resting, cancel, closeAdvanced }

class ArenaCellMoreButtonBuilder extends StatelessWidget {
  const ArenaCellMoreButtonBuilder({
    super.key,
    this.child,
    required this.builder,
  });

  final Widget? child;
  final Widget Function(BuildContext context, MoreMode mode, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final generalInteraction = counterSpell.interactionLogic;
    final arenaPlayerController = context.arenaPlayerController;

    return _MoreModeBuilder(
      attackingPlayerIndex: generalInteraction.attackingPlayerIndex,
      increment: arenaPlayerController.increment,
      cachedAttackerIndex: arenaPlayerController.cachedAttackerIndex,
      advanced: arenaPlayerController.advanced,
      builder: builder,
      child: child,
    );
  }
}

class _MoreModeBuilder extends StatefulWidget {
  const _MoreModeBuilder({
    required this.attackingPlayerIndex,
    required this.cachedAttackerIndex,
    required this.advanced,
    required this.increment,
    required this.child,
    required this.builder,
  });

  final Reactive<int?> attackingPlayerIndex;
  final Reactive<int?> cachedAttackerIndex;
  final Reactive<int> increment;
  final Reactive<bool> advanced;
  final Widget? child;
  final Widget Function(BuildContext context, MoreMode mode, Widget? child)
  builder;

  @override
  State<_MoreModeBuilder> createState() => _MoreModeBuilderState();
}

class _MoreModeBuilderState extends State<_MoreModeBuilder> {
  MoreMode mode = MoreMode.resting;

  @override
  void initState() {
    super.initState();
    mode = newValue();
    widget.attackingPlayerIndex.addListener(attackingListener);
    widget.increment.addListener(incrementListener);
    widget.cachedAttackerIndex.addListener(cachedListener);
    widget.advanced.addListener(advancedListener);
  }

  @override
  void dispose() {
    widget.attackingPlayerIndex.removeListener(attackingListener);
    widget.increment.removeListener(incrementListener);
    widget.cachedAttackerIndex.removeListener(cachedListener);
    widget.advanced.removeListener(advancedListener);
    super.dispose();
  }

  MoreMode newValue() {
    if (widget.increment.value != 0) {
      return MoreMode.cancel;
    }
    if (widget.advanced.value) {
      return MoreMode.closeAdvanced;
    }
    return switch (widget.cachedAttackerIndex.value ??
        widget.attackingPlayerIndex.value) {
      -1 => MoreMode.resting,
      null => MoreMode.resting,
      int _ => MoreMode.cancel,
    };
  }

  void attackingListener() => update();
  void incrementListener() => update();
  void cachedListener() => update();
  void advancedListener() => update();

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
