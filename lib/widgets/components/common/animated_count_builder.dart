import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class AnimatedCountBuilder extends ImplicitlyAnimatedWidget {
  const AnimatedCountBuilder({
    super.key,
    required this.count,
    this.child,
    required this.builder,
    super.duration = Durations.long1,
    super.curve = Curves.linear,
  });

  final int count;
  final Widget? child;
  final ChildValueBuilder<int> builder;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState
    extends AnimatedWidgetBaseState<AnimatedCountBuilder> {
  IntTween? _count;

  @override
  void forEachTween(visitor) {
    _count =
        visitor(_count, widget.count, (dynamic value) => IntTween(begin: value))
            as IntTween?;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _count!.evaluate(animation), widget.child);
  }
}
