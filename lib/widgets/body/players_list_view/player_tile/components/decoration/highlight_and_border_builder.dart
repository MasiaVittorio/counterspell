// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class HighlightAndBorderBuilder extends StatelessWidget {
  const HighlightAndBorderBuilder({
    super.key,
    this.child,
    required this.builder,
    required this.index,
    required this.interactionMode,
  });

  final InteractionMode? interactionMode;
  final int index;

  final Widget? child;

  final Widget Function(
    BuildContext context,
    bool? highlight,
    bool showBorder,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    if (index == -1) return builder(context, null, false, child);
    final interactionLogic = context.counterSpell.interactionLogic;
    return _HighlightAndBorderBuilder(
      builder: builder,
      index: index,
      playersMultiSelection: interactionLogic.playersMultiSelection,
      defendingPlayerIndex: interactionLogic.defendingPlayerIndex,
      attackingPlayerIndex: interactionLogic.attackingPlayerIndex,
      interactionMode: interactionMode,
      child: child,
    );
  }
}

class _HighlightAndBorderBuilder extends StatefulWidget {
  const _HighlightAndBorderBuilder({
    required this.builder,
    required this.index,
    required this.child,
    required this.playersMultiSelection,
    required this.defendingPlayerIndex,
    required this.attackingPlayerIndex,
    required this.interactionMode,
  });

  final InteractionMode? interactionMode;
  final Reactive<List<bool?>> playersMultiSelection;
  final Reactive<int?> defendingPlayerIndex;
  final Reactive<int?> attackingPlayerIndex;

  final int index;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    bool? highlight,
    bool showBorder,
    Widget? child,
  )
  builder;

  @override
  State<_HighlightAndBorderBuilder> createState() =>
      _HighlightAndBorderBuilderState();
}

class _HighlightAndBorderBuilderState
    extends State<_HighlightAndBorderBuilder> {
  late bool? highlight;
  late bool showBorder;

  @override
  void initState() {
    super.initState();
    final v = newValues();
    highlight = v.highlight;
    showBorder = v.border;
    widget.attackingPlayerIndex.addListener(_attackingPlayerIndexListener);
    widget.defendingPlayerIndex.addListener(_defendingPlayerIndexListener);
    widget.playersMultiSelection.addListener(_playersMultiSelectionListener);
  }

  @override
  void didUpdateWidget(covariant _HighlightAndBorderBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index ||
        oldWidget.interactionMode != widget.interactionMode) {
      final v = newValues();
      highlight = v.highlight;
      showBorder = v.border;
    }
  }

  @override
  void dispose() {
    widget.attackingPlayerIndex.removeListener(_attackingPlayerIndexListener);
    widget.defendingPlayerIndex.removeListener(_defendingPlayerIndexListener);
    widget.playersMultiSelection.removeListener(_playersMultiSelectionListener);
    super.dispose();
  }

  void _attackingPlayerIndexListener() => update();
  void _defendingPlayerIndexListener() => update();
  void _playersMultiSelectionListener() => update();

  ({bool? highlight, bool border}) newValues() {
    if (widget.index >= widget.playersMultiSelection.value.length) {
      return (highlight: null, border: false);
    }
    final bool? isThisSelected =
        widget.playersMultiSelection.value[widget.index];
    final bool isAnybodyAttacking = widget.attackingPlayerIndex.value != null;
    final bool isThisAttacking =
        widget.attackingPlayerIndex.value == widget.index;
    final bool isDefending = widget.defendingPlayerIndex.value == widget.index;
    final isAnybodySelected = widget.playersMultiSelection.value.any(
      (element) => element != false,
    );

    final h = switch (widget.interactionMode) {
      InteractionMode.life ||
      InteractionMode.cast ||
      InteractionMode.counters =>
        isThisSelected != false
            ? true
            : isAnybodySelected
            ? false
            : null,
      InteractionMode.damage =>
        isThisAttacking || isDefending
            ? true
            : isAnybodyAttacking
            ? false
            : null,
      null => null,
    };

    final b = switch (widget.interactionMode) {
      InteractionMode.life ||
      InteractionMode.cast ||
      InteractionMode.counters =>
        isThisSelected == true || isThisSelected == null,
      InteractionMode.damage => isThisAttacking,
      null => false,
    };

    return (highlight: h, border: b);
  }

  void update() {
    if (!mounted) return;
    final v = newValues();
    if (v.border != showBorder || v.highlight != highlight) {
      setState(() {
        highlight = v.highlight;
        showBorder = v.border;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, highlight, showBorder, widget.child);
  }
}
