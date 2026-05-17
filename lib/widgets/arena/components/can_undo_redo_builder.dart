import 'package:counter_spell/logic/game_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';

class CanUndoRedoBuilder extends StatelessWidget {
  const CanUndoRedoBuilder({super.key, this.child, required this.builder});

  final Widget? child;
  final Widget Function(
    BuildContext context,
    bool canUndo,
    bool canRedo,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    return _CanUndoRedoBuilder(
      gameLogic: context.counterSpell.gameLogic,
      builder: builder,
      child: child,
    );
  }
}

class _CanUndoRedoBuilder extends StatefulWidget {
  const _CanUndoRedoBuilder({
    required this.gameLogic,
    required this.child,
    required this.builder,
  });

  final GameLogic gameLogic;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    bool canUndo,
    bool canRedo,
    Widget? child,
  )
  builder;

  @override
  State<_CanUndoRedoBuilder> createState() => _CanUndoRedoBuilderState();
}

class _CanUndoRedoBuilderState extends State<_CanUndoRedoBuilder> {
  bool canUndo = false;
  bool canRedo = false;
  @override
  void initState() {
    super.initState();
    final v = newValue();
    canUndo = v.undo;
    canRedo = v.redo;
    widget.gameLogic.gameReactive.addListener(gameListener);
    widget.gameLogic.deltas.addListener(deltasListener);
  }

  @override
  void dispose() {
    widget.gameLogic.gameReactive.removeListener(gameListener);
    widget.gameLogic.deltas.removeListener(deltasListener);
    super.dispose();
  }

  ({bool undo, bool redo}) newValue() {
    return (
      undo: widget.gameLogic.gameReactive.value.gameStates.length > 1,
      redo: widget.gameLogic.deltas.value.isNotEmpty,
    );
  }

  void update() {
    if (!mounted) return;
    final v = newValue();
    if (v.undo != canUndo || v.redo != canRedo) {
      setState(() {
        canUndo = v.undo;
        canRedo = v.redo;
      });
    }
  }

  void gameListener() => update();
  void deltasListener() => update();

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, canUndo, canRedo, widget.child);
  }
}
