import 'package:flutter/gestures.dart';

typedef GestureVelocityDragUpdateCallback =
    void Function(VelocityDragUpdateDetails details);

class VelocityDragUpdateDetails implements PositionedGestureDetails {
  VelocityDragUpdateDetails({
    required this.globalPosition,
    Offset? localPosition,
    this.sourceTimeStamp,
    this.delta = Offset.zero,
    this.primaryDelta,
    this.kind,
    this.velocity = Velocity.zero,
    this.primaryVelocity,
  }) : assert(
         primaryDelta == null ||
             (primaryDelta == delta.dx && delta.dy == 0.0) ||
             (primaryDelta == delta.dy && delta.dx == 0.0),
       ),
       assert(
         primaryVelocity == null ||
             (primaryVelocity == velocity.pixelsPerSecond.dx &&
                 velocity.pixelsPerSecond.dy == 0.0) ||
             (primaryVelocity == velocity.pixelsPerSecond.dy &&
                 velocity.pixelsPerSecond.dx == 0.0),
       ),
       localPosition = localPosition ?? globalPosition;

  @override
  final Offset globalPosition;

  @override
  final Offset localPosition;

  final Duration? sourceTimeStamp;

  final Offset delta;

  final double? primaryDelta;

  final PointerDeviceKind? kind;

  final Velocity velocity;

  final double? primaryVelocity;

  VelocityDragUpdateDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
    Duration? sourceTimeStamp,
    Offset? delta,
    double? primaryDelta,
    PointerDeviceKind? kind,
    Velocity? velocity,
    double? primaryVelocity,
  }) {
    return VelocityDragUpdateDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      sourceTimeStamp: sourceTimeStamp ?? this.sourceTimeStamp,
      delta: delta ?? this.delta,
      primaryDelta: primaryDelta ?? this.primaryDelta,
      kind: kind ?? this.kind,
      velocity: velocity ?? this.velocity,
      primaryVelocity: primaryVelocity ?? this.primaryVelocity,
    );
  }
}
