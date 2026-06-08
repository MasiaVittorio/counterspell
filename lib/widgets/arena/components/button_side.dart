import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

class ButtonSide extends StatelessWidget {
  const ButtonSide.center({super.key, required this.child})
    : mode = _ButtonSideMode.override,
      data = ButtonSideData.center,
      quarterTurns = null;

  const ButtonSide.left({super.key, required this.child})
    : mode = _ButtonSideMode.override,
      data = ButtonSideData.left,
      quarterTurns = null;

  const ButtonSide.right({super.key, required this.child})
    : mode = _ButtonSideMode.override,
      data = ButtonSideData.right,
      quarterTurns = null;

  const ButtonSide.rightUnless(bool flip, {super.key, required this.child})
    : mode = _ButtonSideMode.override,
      data = flip ? ButtonSideData.left : ButtonSideData.right,
      quarterTurns = null;

  const ButtonSide.leftUnless(bool flip, {super.key, required this.child})
    : mode = _ButtonSideMode.override,
      data = flip ? ButtonSideData.right : ButtonSideData.left,
      quarterTurns = null;

  const ButtonSide({
    super.key,
    required ButtonSideData this.data,
    required this.child,
  }) : mode = _ButtonSideMode.override,
       quarterTurns = null;

  const ButtonSide.overrideCenter({
    super.key,
    required ButtonSideData this.data,
    required this.child,
  }) : mode = _ButtonSideMode.overrideCenter,
       quarterTurns = null;

  const ButtonSide.flip({super.key, required this.child})
    : mode = _ButtonSideMode.flip,
      quarterTurns = null,
      data = null;

  const ButtonSide.rotate({
    super.key,
    required int this.quarterTurns,
    required this.child,
  }) : mode = _ButtonSideMode.rotate,
       data = null;

  const ButtonSide.keep({super.key, required this.child})
    : mode = _ButtonSideMode.keep,
      quarterTurns = null,
      data = null;

  // ignore: library_private_types_in_public_api
  final _ButtonSideMode mode;
  final ButtonSideData? data;
  final int? quarterTurns;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return switch (mode) {
      _ButtonSideMode.keep => child,
      _ButtonSideMode.flip => CleanProvider<ButtonSideData>(
        data: context.buttonSide.flipped(),
        child: child,
      ),
      _ButtonSideMode.overrideCenter => CleanProvider<ButtonSideData>(
        data: switch (context.buttonSide) {
          ButtonSideData.center => data!,
          final other => other,
        },
        child: child,
      ),
      _ButtonSideMode.override => CleanProvider<ButtonSideData>(
        data: data!,
        child: child,
      ),
      _ButtonSideMode.rotate => CleanProvider<ButtonSideData>(
        data: context.buttonSide.rotated(quarterTurns!),
        child: child,
      ),
    };
  }
}

extension ButtonSideContext on BuildContext {
  ButtonSideData get buttonSide =>
      provideMaybe<ButtonSideData>() ?? ButtonSideData.center;
}

enum ButtonSideData {
  left,
  center,
  right;

  ButtonSideData flipped() => switch (this) {
    ButtonSideData.left => ButtonSideData.right,
    ButtonSideData.center => ButtonSideData.center,
    ButtonSideData.right => ButtonSideData.left,
  };

  ButtonSideData rotated(int quarterTurns) => switch (quarterTurns % 4) {
    1 => switch (this) {
      ButtonSideData.center => ButtonSideData.left,
      ButtonSideData.left => ButtonSideData.center,
      ButtonSideData.right => ButtonSideData.center,
    },
    2 => flipped(),
    3 => switch (this) {
      ButtonSideData.center => ButtonSideData.right,
      ButtonSideData.left => ButtonSideData.center,
      ButtonSideData.right => ButtonSideData.center,
    },
    _ => this,
  };
}

enum _ButtonSideMode { keep, flip, override, rotate, overrideCenter }
