import 'dart:math';

import 'package:flutter/material.dart';

class BiggestSquareAtLeast extends StatelessWidget {
  const BiggestSquareAtLeast({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final size = min(constraints.maxHeight, constraints.maxWidth);
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: constraints.maxHeight,
          maxWidth: constraints.maxWidth,
          minHeight: size,
          minWidth: size,
        ),
        child: child,
      );
    });
  }
}

class BiggestSquareBuilder extends StatelessWidget {
  const BiggestSquareBuilder({
    required this.builder,
    required this.scale,
    super.key,
  });

  final Widget Function(BuildContext, double) builder;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = min(constraints.maxHeight, constraints.maxWidth) * scale;
      return SizedBox.square(
        dimension: size,
        child: builder(context, size),
      );
    });
  }
}
