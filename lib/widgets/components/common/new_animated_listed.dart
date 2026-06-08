import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class NewAnimatedListed extends ImplicitlyAnimatedWidget {
  const NewAnimatedListed({
    super.key,
    required this.listed,
    required this.child,
    super.curve = Easings.emphasized,
    super.duration = Durations.long2,
    this.fadeFirstFraction = 0.0,
    this.direction = Axis.vertical,
    this.axisAlignment = 1.0,
    this.unlistedFraction = 0,
  });

  final bool listed;
  final Widget? child;

  /// 1.0: the child has completely faded out at 50% of the animation
  /// (cannot be seen along other simililarly animated children)
  /// 0.0: the child has fades out during the whole animation
  /// (shares the visibility with any other children fading in-out the same way)
  final double fadeFirstFraction;

  final Axis direction;
  final double axisAlignment;

  final double unlistedFraction;

  @override
  AnimatedWidgetBaseState<NewAnimatedListed> createState() =>
      _DivisionAnimateState();
}

class _DivisionAnimateState extends AnimatedWidgetBaseState<NewAnimatedListed> {
  Tween<double>? _presented;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _presented =
        visitor(
              _presented,
              widget.listed ? 1.0 : 0.0,
              (dynamic value) => Tween<double>(begin: value),
            )
            as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    final double val = _presented!.evaluate(animation);
    final factor = val.rangeMap(to: (widget.unlistedFraction, 1));

    return IgnorePointer(
      ignoring: !widget.listed,
      child: ClipRect(
        child: Align(
          alignment: switch (widget.direction) {
            Axis.horizontal => Alignment(widget.axisAlignment, 0),
            Axis.vertical => Alignment(0, widget.axisAlignment),
          },
          widthFactor: switch (widget.direction) {
            Axis.horizontal => factor,
            Axis.vertical => 1.0,
          },
          heightFactor: switch (widget.direction) {
            Axis.horizontal => 1.0,
            Axis.vertical => factor,
          },
          child: Opacity(
            opacity: val.rangeMap(
              from: (widget.fadeFirstFraction.rangeMap(to: (0, .5)), 1),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
