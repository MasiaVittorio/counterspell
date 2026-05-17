import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class MapBuilder<A, T> extends StatefulWidget {
  const MapBuilder({
    super.key,
    required this.reactive,
    required this.map,
    required this.keys,
    required this.child,
    required this.builder,
  });

  final Reactive<A> reactive;
  final T Function(A a) map;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;
  final List<Object?> keys;

  @override
  State<MapBuilder<A, T>> createState() => _MapBuilderState<A, T>();
}

class _MapBuilderState<A, T> extends State<MapBuilder<A, T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.map(widget.reactive.value);
    widget.reactive.addListener(update);
  }

  @override
  void dispose() {
    widget.reactive.removeListener(update);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MapBuilder<A, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.keys, widget.keys)) {
      value = widget.map(widget.reactive.value);
    }
  }

  void update() {
    T? newValue;
    try {
      newValue = widget.map(widget.reactive.value);
    } catch (_) {}
    if (newValue == null) return;
    if (newValue != value) {
      setState(() {
        value = newValue as T;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}
