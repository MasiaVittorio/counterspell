import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/builders/selector.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class IsAnybodyAttackingBuilder extends StatelessWidget {
  const IsAnybodyAttackingBuilder({
    super.key,
    this.child,
    required this.builder,
  });

  final Widget? child;
  final ChildValueBuilder<bool> builder;

  @override
  Widget build(BuildContext context) {
    return Selector<int?>(
      target: null,
      keys: [],
      reactive: context.counterSpell.interactionLogic.attackingPlayerIndex,
      child: child,
      builder: (context, nobodyAttacking, child) =>
          builder(context, !nobodyAttacking, child),
    );
  }
}

class IsAnyBodyAttackingAndThisInParticular extends StatelessWidget {
  const IsAnyBodyAttackingAndThisInParticular({
    super.key,
    required this.index,
    required this.builder,
    this.child,
  });

  final int index;
  final Widget Function(
    BuildContext context,
    bool isAnybodyAttacking,
    bool isThisAttacking,
    Widget? child,
  )
  builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _IsAnyBodyAttackingAndThisInParticular(
      attackerReactive:
          context.counterSpell.interactionLogic.attackingPlayerIndex,
      index: index,
      builder: builder,
      child: child,
    );
  }
}

class _IsAnyBodyAttackingAndThisInParticular extends StatefulWidget {
  const _IsAnyBodyAttackingAndThisInParticular({
    required this.attackerReactive,
    required this.index,
    required this.builder,
    required this.child,
  });

  final Reactive<int?> attackerReactive;
  final int index;
  final Widget Function(
    BuildContext context,
    bool isAnybodyAttacking,
    bool isThisAttacking,
    Widget? child,
  )
  builder;
  final Widget? child;

  @override
  State<_IsAnyBodyAttackingAndThisInParticular> createState() =>
      _IsAnyBodyAttackingAndThisInParticularState();
}

class _IsAnyBodyAttackingAndThisInParticularState
    extends State<_IsAnyBodyAttackingAndThisInParticular> {
  late bool isAnybodyAttacking;
  late bool isThisAttacking;

  @override
  void initState() {
    super.initState();
    final attackerIndex = widget.attackerReactive.value;
    isAnybodyAttacking = attackerIndex != null;
    isThisAttacking = attackerIndex == widget.index;
    widget.attackerReactive.addListener(listener);
  }

  void listener() {
    if (!mounted) return;
    final attackerIndex = widget.attackerReactive.value;
    final newIsAnybodyAttacking = attackerIndex != null;
    final newIsThisAttacking = attackerIndex == widget.index;
    if (newIsAnybodyAttacking != isAnybodyAttacking ||
        newIsThisAttacking != isThisAttacking) {
      setState(() {
        isAnybodyAttacking = newIsAnybodyAttacking;
        isThisAttacking = newIsThisAttacking;
      });
    }
  }

  @override
  void dispose() {
    widget.attackerReactive.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      isAnybodyAttacking,
      isThisAttacking,
      widget.child,
    );
  }
}
