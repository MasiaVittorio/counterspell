import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ListSelector<T> extends StatefulWidget {
  const ListSelector({
    super.key,
    required this.reactive,
    required this.index,
    required this.builder,
    this.child,
  });

  final Reactive<List<T>> reactive;
  final int index;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;

  @override
  State<ListSelector<T>> createState() => _ListSelectorState<T>();
}

class _ListSelectorState<T> extends State<ListSelector<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.reactive.value[widget.index];
    widget.reactive.addListener(listener);
  }

  @override
  void dispose() {
    widget.reactive.removeListener(listener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ListSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      value = widget.reactive.value[widget.index];
    }
  }

  void listener() {
    if (!mounted) return;
    if (widget.index >= widget.reactive.value.length) return;
    final T newValue = widget.reactive.value[widget.index];
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
