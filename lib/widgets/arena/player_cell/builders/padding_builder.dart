import 'package:counter_spell/logic/interaction_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:flutter/material.dart';

class ArenaPlayerCellPaddingBuilder extends StatelessWidget {
  const ArenaPlayerCellPaddingBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  });

  final int playerIndex;
  final Widget? child;
  final Widget Function(BuildContext context, bool isPadded, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final generalInteraction = counterSpell.interactionLogic;
    final arenaPlayerController = context.arenaPlayerController;

    return _PaddingBuilder(
      playerIndex: playerIndex,
      generalInteraction: generalInteraction,
      arenaPlayerController: arenaPlayerController,
      builder: builder,
      child: child,
    );
  }
}

class _PaddingBuilder extends StatefulWidget {
  const _PaddingBuilder({
    required this.playerIndex,
    required this.generalInteraction,
    required this.arenaPlayerController,
    required this.child,
    required this.builder,
  });

  final int playerIndex;
  final InteractionLogic generalInteraction;
  final ArenaPlayerController arenaPlayerController;
  final Widget? child;
  final Widget Function(BuildContext context, bool isPadded, Widget? child)
  builder;

  @override
  State<_PaddingBuilder> createState() => _PaddingBuilderState();
}

class _PaddingBuilderState extends State<_PaddingBuilder> {
  @override
  void initState() {
    super.initState();
    isPadded = newValue();
    widget.generalInteraction.attackingPlayerIndex.addListener(
      attackingListener,
    );
    widget.arenaPlayerController.increment.addListener(incrementListener);
  }

  @override
  void dispose() {
    widget.generalInteraction.attackingPlayerIndex.removeListener(
      attackingListener,
    );
    widget.arenaPlayerController.increment.removeListener(incrementListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _PaddingBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerIndex != widget.playerIndex) {
      isPadded = newValue();
    }
  }

  bool isPadded = false;

  bool newValue() =>
      (widget.arenaPlayerController.increment.value != 0) ||
      (widget.generalInteraction.attackingPlayerIndex.value ==
          widget.playerIndex);

  void attackingListener() => update();
  void incrementListener() => update();

  void update() {
    if (!mounted) return;
    final newValue = this.newValue();
    if (newValue != isPadded) {
      setState(() {
        isPadded = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, isPadded, widget.child);
  }
}
