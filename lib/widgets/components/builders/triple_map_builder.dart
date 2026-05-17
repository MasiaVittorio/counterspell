import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class TripleMapBuilder<A, B, C, T> extends StatefulWidget {
  const TripleMapBuilder({
    super.key,
    required this.reactiveA,
    required this.reactiveB,
    required this.reactiveC,
    required this.map,
    required this.builder,
    required this.child,
    required this.keys,
  });

  final Reactive<A> reactiveA;
  final Reactive<B> reactiveB;
  final Reactive<C> reactiveC;
  final T Function(A a, B b, C c) map;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;
  final List<Object?> keys;

  @override
  State<TripleMapBuilder<A, B, C, T>> createState() =>
      _TripleMapBuilderState<A, B, C, T>();
}

class _TripleMapBuilderState<A, B, C, T>
    extends State<TripleMapBuilder<A, B, C, T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.map(
      widget.reactiveA.value,
      widget.reactiveB.value,
      widget.reactiveC.value,
    );
    widget.reactiveA.addListener(listenerA);
    widget.reactiveB.addListener(listenerB);
    widget.reactiveC.addListener(listenerC);
  }

  @override
  void dispose() {
    widget.reactiveA.removeListener(listenerA);
    widget.reactiveB.removeListener(listenerB);
    widget.reactiveC.removeListener(listenerC);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TripleMapBuilder<A, B, C, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.keys, oldWidget.keys)) {
      value = widget.map(
        widget.reactiveA.value,
        widget.reactiveB.value,
        widget.reactiveC.value,
      );
    }
  }

  void listenerA() => update();
  void listenerB() => update();
  void listenerC() => update();

  void update() {
    final newValue = widget.map(
      widget.reactiveA.value,
      widget.reactiveB.value,
      widget.reactiveC.value,
    );
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
