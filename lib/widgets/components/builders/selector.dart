import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class Selector<T> extends StatefulWidget {
  const Selector({
    super.key,
    required this.builder,
    required this.child,
    required this.target,
    required this.reactive,
    required this.keys,
  });

  final Widget Function(BuildContext context, bool isTarget, Widget? child)
  builder;
  final Widget? child;
  final T target;
  final Reactive<T?> reactive;
  final List<Object?> keys;

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  late bool isTarget;

  @override
  void initState() {
    super.initState();
    isTarget = widget.reactive.value == widget.target;
    widget.reactive.addListener(listener);
  }

  @override
  void dispose() {
    widget.reactive.removeListener(listener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Selector<dynamic> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.keys, widget.keys)) {
      isTarget = widget.reactive.value == widget.target;
    } else if (widget.target != oldWidget.target) {
      isTarget = widget.reactive.value == widget.target;
    }
  }

  void listener() {
    if (!mounted) return;
    final bool newValue = widget.reactive.value == widget.target;
    if (newValue != isTarget) {
      setState(() {
        isTarget = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, isTarget, widget.child);
  }
}
