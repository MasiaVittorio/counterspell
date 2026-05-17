import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/map_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class IsAnybodySelectedBuilder extends StatelessWidget {
  const IsAnybodySelectedBuilder({
    super.key,
    this.child,
    required this.builder,
  });

  final Widget? child;
  final ChildValueBuilder<bool> builder;

  @override
  Widget build(BuildContext context) {
    return MapBuilder(
      reactive: context.counterSpell.interactionLogic.playersMultiSelection,
      map: (List<bool?> list) => list.any((element) => element != false),
      keys: [],
      builder: builder,
      child: child,
    );
  }
}

class IsAnybodySelectedAndThisInParticular extends StatelessWidget {
  const IsAnybodySelectedAndThisInParticular({
    super.key,
    required this.index,
    required this.builder,
    this.child,
  });

  final int index;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    bool isAnybodySelected,
    bool? isThisSelected,
    Widget? child,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    return _IsAnybodySelectedAndThisInParticular(
      index: index,
      playersMultiSelection:
          context.counterSpell.interactionLogic.playersMultiSelection,
      builder: builder,
      child: child,
    );
  }
}

class _IsAnybodySelectedAndThisInParticular extends StatefulWidget {
  const _IsAnybodySelectedAndThisInParticular({
    required this.index,
    required this.builder,
    required this.playersMultiSelection,
    required this.child,
  });

  final Reactive<List<bool?>> playersMultiSelection;
  final int index;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    bool isAnybodySelected,
    bool? isThisSelected,
    Widget? child,
  )
  builder;

  @override
  State<_IsAnybodySelectedAndThisInParticular> createState() =>
      _IsAnybodySelectedAndThisInParticularState();
}

class _IsAnybodySelectedAndThisInParticularState
    extends State<_IsAnybodySelectedAndThisInParticular> {
  late bool isAnybodySelected;
  late bool? isThisSelected;

  @override
  void initState() {
    super.initState();
    final list = widget.playersMultiSelection.value;
    isAnybodySelected = list.any((element) => element != false);
    isThisSelected = list[widget.index];
    widget.playersMultiSelection.addListener(listener);
  }

  void listener() {
    if (!mounted) return;
    final list = widget.playersMultiSelection.value;
    final bool newIsAnybodySelected = list.any((element) => element != false);
    final bool? newIsThisSelected = list[widget.index];
    if (newIsAnybodySelected != isAnybodySelected ||
        newIsThisSelected != isThisSelected) {
      setState(() {
        isAnybodySelected = newIsAnybodySelected;
        isThisSelected = newIsThisSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      isAnybodySelected,
      isThisSelected,
      widget.child,
    );
  }
}
