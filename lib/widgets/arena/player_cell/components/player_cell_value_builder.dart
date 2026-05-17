import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/game.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:counter_spell/widgets/arena/player_cell/builders/cell_mode_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellValueBuilder extends StatelessWidget {
  const PlayerCellValueBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
    required this.mode,
  });

  final CellMode mode;
  final Widget? child;
  final Widget Function(BuildContext context, int value, Widget? child) builder;
  final int playerIndex;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final gameLogic = counterSpell.gameLogic;
    final interactionLogic = counterSpell.interactionLogic;
    final controller = context.arenaPlayerController;

    return _PlayerCellValueBuilder(
      builder: builder,
      game: gameLogic.gameReactive,
      cachedAttackerIndex: controller.cachedAttackerIndex,
      attackingPlayerIndex: interactionLogic.attackingPlayerIndex,
      playerIndex: playerIndex,
      usingPartnerA: interactionLogic.usingPartnerA,
      mode: mode,
      child: child,
    );
  }
}

class _PlayerCellValueBuilder extends StatefulWidget {
  const _PlayerCellValueBuilder({
    required this.child,
    required this.builder,
    required this.game,
    required this.cachedAttackerIndex,
    required this.attackingPlayerIndex,
    required this.playerIndex,
    required this.usingPartnerA,
    required this.mode,
  });

  final Widget? child;
  final Widget Function(BuildContext context, int value, Widget? child) builder;

  final Reactive<Game> game;
  final Reactive<int?> cachedAttackerIndex;
  final Reactive<int?> attackingPlayerIndex;
  final Reactive<List<bool>> usingPartnerA;

  final int playerIndex;
  final CellMode mode;

  @override
  State<_PlayerCellValueBuilder> createState() =>
      _PlayerCellValueBuilderState();
}

class _PlayerCellValueBuilderState extends State<_PlayerCellValueBuilder> {
  int value = 0;

  @override
  void initState() {
    super.initState();
    value = newValue();
    widget.attackingPlayerIndex.addListener(attackingListener);
    widget.cachedAttackerIndex.addListener(cachedListener);
    widget.game.addListener(gameListener);
    widget.usingPartnerA.addListener(usingPartnerAListener);
  }

  @override
  void dispose() {
    widget.attackingPlayerIndex.removeListener(attackingListener);
    widget.cachedAttackerIndex.removeListener(cachedListener);
    widget.game.removeListener(gameListener);
    widget.usingPartnerA.removeListener(usingPartnerAListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _PlayerCellValueBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playerIndex != oldWidget.playerIndex ||
        widget.mode != oldWidget.mode) {
      value = newValue();
    }
  }

  void attackingListener() => update();
  void cachedListener() => update();
  void gameListener() => update();
  void usingPartnerAListener() => update();

  void update() {
    if (!mounted) return;
    final v = newValue();
    if (v != value) {
      setState(() => value = v);
    }
  }

  int newValue() {
    if (widget.playerIndex >=
        widget.game.value.currentState.playerStates.length) {
      return 0;
    }
    final state =
        widget.game.value.currentState.playerStates[widget.playerIndex];
    if (widget.mode == CellMode.life) return state.life;

    final int? attackerIndex =
        widget.cachedAttackerIndex.value ?? widget.attackingPlayerIndex.value;
    if (attackerIndex == null) return state.life;
    if (attackerIndex == -1) return state.life;

    if (attackerIndex >= state.commanderDamageTaken.length) return 0;
    if (attackerIndex >= widget.usingPartnerA.value.length) return 0;

    return state.commanderDamageTaken[attackerIndex].from(
      widget.usingPartnerA.value[attackerIndex],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}
