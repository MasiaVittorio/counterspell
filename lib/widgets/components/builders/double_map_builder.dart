import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class DoubleMapBuilder<A, B, T> extends StatefulWidget {
  const DoubleMapBuilder({
    super.key,
    required this.reactiveA,
    required this.reactiveB,
    required this.map,
    required this.builder,
    required this.child,
    required this.keys,
  });

  final Reactive<A> reactiveA;
  final Reactive<B> reactiveB;
  final T Function(A a, B b) map;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;
  final List<Object?> keys;

  @override
  State<DoubleMapBuilder<A, B, T>> createState() =>
      _DoubleMapBuilderState<A, B, T>();
}

class _DoubleMapBuilderState<A, B, T> extends State<DoubleMapBuilder<A, B, T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.map(widget.reactiveA.value, widget.reactiveB.value);
    widget.reactiveA.addListener(listenerA);
    widget.reactiveB.addListener(listenerB);
  }

  @override
  void dispose() {
    widget.reactiveA.removeListener(listenerA);
    widget.reactiveB.removeListener(listenerB);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DoubleMapBuilder<A, B, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.keys, oldWidget.keys)) {
      value = widget.map(widget.reactiveA.value, widget.reactiveB.value);
    }
  }

  void listenerA() => update();
  void listenerB() => update();

  void update() {
    final newValue = widget.map(widget.reactiveA.value, widget.reactiveB.value);
    if (newValue != value) {
      setState(() {
        value = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}
