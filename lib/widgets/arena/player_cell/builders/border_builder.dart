import 'package:counter_spell/logic/interaction_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:flutter/material.dart';

class ArenaPlayerCellBorderBuilder extends StatelessWidget {
  const ArenaPlayerCellBorderBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  });

  final int playerIndex;
  final Widget? child;
  final Widget Function(BuildContext context, bool hasBorder, Widget? child)
  builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final generalInteraction = counterSpell.interactionLogic;

    return _BorderBuilder(
      playerIndex: playerIndex,
      generalInteraction: generalInteraction,
      arenaPlayerController: context.arenaPlayerController,
      builder: builder,
      child: child,
    );
  }
}

class _BorderBuilder extends StatefulWidget {
  const _BorderBuilder({
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
  final Widget Function(BuildContext context, bool hasBorder, Widget? child)
  builder;

  @override
  State<_BorderBuilder> createState() => _BorderBuilderState();
}

class _BorderBuilderState extends State<_BorderBuilder> {
  @override
  void initState() {
    super.initState();
    hasBorder = newValue();
    widget.generalInteraction.attackingPlayerIndex.addListener(
      attackingListener,
    );
    widget.arenaPlayerController.increment.addListener(incrementListener);
  }

  @override
  void didUpdateWidget(covariant _BorderBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerIndex != widget.playerIndex) {
      hasBorder = newValue();
    }
  }

  @override
  void dispose() {
    widget.generalInteraction.attackingPlayerIndex.removeListener(
      attackingListener,
    );
    widget.arenaPlayerController.increment.removeListener(incrementListener);
    super.dispose();
  }

  bool hasBorder = false;

  bool newValue() =>
      (widget.arenaPlayerController.increment.value != 0) ||
      (widget.generalInteraction.attackingPlayerIndex.value ==
          widget.playerIndex);

  void attackingListener() => update();
  void incrementListener() => update();

  void update() {
    if (!mounted) return;
    final newValue = this.newValue();
    if (newValue != hasBorder) {
      setState(() {
        hasBorder = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, hasBorder, widget.child);
  }
}
