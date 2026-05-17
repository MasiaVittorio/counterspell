import 'package:counter_spell/logic/interaction_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

enum ImageVisibility { lowest, low, normal, high }

class ArenaPlayerCellVisibilityBuilder extends StatelessWidget {
  const ArenaPlayerCellVisibilityBuilder({
    super.key,
    required this.playerIndex,
    this.child,
    required this.builder,
  });

  final int playerIndex;
  final Widget? child;
  final ChildValueBuilder<ImageVisibility> builder;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final generalInteraction = counterSpell.interactionLogic;
    final arenaPlayerController = context.arenaPlayerController;

    return _VisibilityBuilder(
      playerIndex: playerIndex,
      generalInteraction: generalInteraction,
      arenaPlayerController: arenaPlayerController,
      builder: builder,
      child: child,
    );
  }
}

class _VisibilityBuilder extends StatefulWidget {
  const _VisibilityBuilder({
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
  final ChildValueBuilder<ImageVisibility> builder;

  @override
  State<_VisibilityBuilder> createState() => _VisibilityBuilderState();
}

class _VisibilityBuilderState extends State<_VisibilityBuilder> {
  @override
  void initState() {
    super.initState();
    visibility = newValue();
    widget.generalInteraction.attackingPlayerIndex.addListener(
      attackingListener,
    );
    widget.arenaPlayerController.increment.addListener(incrementListener);
    widget.arenaPlayerController.advanced.addListener(advancedListener);
  }

  @override
  void dispose() {
    widget.generalInteraction.attackingPlayerIndex.removeListener(
      attackingListener,
    );
    widget.arenaPlayerController.increment.removeListener(incrementListener);
    widget.arenaPlayerController.advanced.removeListener(advancedListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _VisibilityBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playerIndex != widget.playerIndex) {
      visibility = newValue();
    }
  }

  ImageVisibility visibility = ImageVisibility.normal;

  ImageVisibility newValue() {
    if (widget.arenaPlayerController.advanced.value) {
      return ImageVisibility.lowest;
    }
    if (widget.arenaPlayerController.increment.value != 0) {
      return ImageVisibility.high;
    }
    return switch (widget.generalInteraction.attackingPlayerIndex.value) {
      null => ImageVisibility.normal,
      int a when a == widget.playerIndex => ImageVisibility.high,
      int _ => ImageVisibility.low,
    };
  }

  void attackingListener() => update();
  void incrementListener() => update();
  void advancedListener() => update();

  void update() {
    if (!mounted) return;
    final newValue = this.newValue();
    if (newValue != visibility) {
      setState(() {
        visibility = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, visibility, widget.child);
  }
}
