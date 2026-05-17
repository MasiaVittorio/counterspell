import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class OpenSide extends StatelessWidget {
  const OpenSide.remove({
    super.key,
    this.top = false,
    this.left = false,
    this.bottom = false,
    this.right = false,
    required this.child,
  }) : quarterTurns = null;
  const OpenSide.rotate({
    super.key,
    required int this.quarterTurns,
    required this.child,
  }) : top = false,
       left = false,
       bottom = false,
       right = false;

  final bool top;
  final bool left;
  final bool bottom;
  final bool right;

  final int? quarterTurns;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (quarterTurns case int quarterTurns) {
      return CleanProvider(
        data: context.openSides.rotated(quarterTurns),
        child: child,
      );
    }
    return CleanProvider(
      data: context.openSides.remove(
        top: top,
        bottom: bottom,
        right: right,
        left: left,
      ),
      child: child,
    );
  }
}

class OpenSides {
  final bool top;
  final bool left;
  final bool bottom;
  final bool right;

  OpenSides({
    required this.top,
    required this.left,
    required this.bottom,
    required this.right,
  });

  OpenSides.allOpen({
    this.top = true,
    this.left = true,
    this.bottom = true,
    this.right = true,
  });

  OpenSides remove({
    bool top = false,
    bool left = false,
    bool bottom = false,
    bool right = false,
  }) => OpenSides(
    top: (!top) && this.top,
    left: (!left) && this.left,
    bottom: (!bottom) && this.bottom,
    right: (!right) && this.right,
  );

  OpenSides rotated(int quarterTurns) {
    final turns = quarterTurns % 4;
    return switch (turns) {
      0 => this,
      1 => OpenSides(top: right, left: top, bottom: left, right: bottom),
      2 => OpenSides(top: bottom, left: right, bottom: top, right: left),
      3 => OpenSides(top: left, left: bottom, bottom: right, right: top),
      _ => throw ArgumentError.value(
        quarterTurns,
        'quarterTurns',
        'Must be an integer.',
      ),
    };
  }
}

extension OpenSideContext on BuildContext {
  OpenSides get openSides => provideMaybe<OpenSides>() ?? OpenSides.allOpen();
}
