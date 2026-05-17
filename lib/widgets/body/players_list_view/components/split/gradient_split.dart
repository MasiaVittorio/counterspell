import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class GradientSplit extends StatelessWidget {
  const GradientSplit({
    super.key,
    required this.value,
    required this.leftChild,
    required this.rightChild,
    this.maxGradientWidthFraction = 0.05,
    this.parallax = 0,
    this.shrinking = 0,
  });

  final double value; // 0: all right child, 1: all left child
  final Widget leftChild;
  final Widget? rightChild;
  final double maxGradientWidthFraction;
  final double parallax;
  final double shrinking;

  @override
  Widget build(BuildContext context) {
    final rightChild = this.rightChild;
    if (rightChild == null) return leftChild;

    final double leftParallax = value.rangeMap(
      to: (0, parallax),
      from: (1, 0.5),
    );

    final double rightParallax = value.rangeMap(
      to: (0, parallax),
      from: (0, 0.5),
    );

    final double leftShrinking = value.rangeMap(
      to: (0, shrinking),
      from: (1, 0.5),
    );

    final double rightShrinking = value.rangeMap(
      to: (0, shrinking),
      from: (0, 0.5),
    );

    const Curve curve = Curves.easeInOut;
    final double gradientWidth = (value - 0.5).abs().rangeMap(
      to: (0, maxGradientWidthFraction),
      from: (0.5, 0),
    );
    final double gradientStart = value - gradientWidth / 2;
    final double gradientEnd = value + gradientWidth / 2;
    const int n = 6; // number of gradient stops

    final List<({double opacity, double stop})> gradientValues = switch ((
      value,
      gradientWidth,
    )) {
      (0, _) => [(opacity: 1, stop: 0), (opacity: 1, stop: 1)],
      (1, _) => [(opacity: 0, stop: 0), (opacity: 0, stop: 1)],
      (double value, 0) => [
        (opacity: 0, stop: 0),
        (opacity: 1, stop: value),
        (opacity: 1, stop: 1),
      ],
      _ => [
        (opacity: 0, stop: 0),
        (opacity: 0, stop: gradientStart),
        for (int i = 1; i < n; i++)
          if (i / n case final double t)
            (
              opacity: curve.transform(t),
              stop: t.rangeMap(to: (gradientStart, gradientEnd)),
            ),
        (opacity: 1, stop: gradientEnd),
        (opacity: 1, stop: 1),
      ],
    };

    return Stack(
      children: [
        Positioned.fill(
          left: -leftParallax + leftShrinking,
          right: leftParallax + leftShrinking,
          child: leftChild,
        ),
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (Rect bounds) => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [for (final g in gradientValues) g.stop],
              colors: [
                for (final g in gradientValues)
                  Colors.white.withValues(alpha: g.opacity),
              ],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: Transform.translate(
              offset: Offset(rightParallax, 0),
              child: Pad(horizontal: rightShrinking, child: rightChild),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedGradientSplit extends StatelessWidget {
  const AnimatedGradientSplit({
    super.key,
    required this.value,
    required this.leftChild,
    required this.rightChild,
    this.maxGradientWidthFraction = 0.1,
    this.parallax = 0,
    this.shrinking = 0,
    this.duration = Durations.long2,
    this.curve = Easings.emphasized,
  });

  final double value; // 0: all right child, 1: all left child
  final Widget leftChild;
  final Widget? rightChild;
  final double maxGradientWidthFraction;
  final double parallax;
  final Duration duration;
  final Curve curve;
  final double shrinking;

  @override
  Widget build(BuildContext context) {
    if (rightChild == null) return leftChild;

    return GenericAnimatedBuilder(
      duration: duration,
      curve: curve,
      value: value,
      child: rightChild,
      builder: (context, v, child) {
        return GradientSplit(
          value: v,
          leftChild: leftChild,
          rightChild: child!,
          maxGradientWidthFraction: maxGradientWidthFraction,
          parallax: parallax,
          shrinking: shrinking,
        );
      },
    );
  }
}
