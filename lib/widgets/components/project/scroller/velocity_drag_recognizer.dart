import 'package:counter_spell/models/interaction/velocity_drag_update_details.dart';
import 'package:flutter/gestures.dart';

import 'mono_drag_updated.dart';

class VelocityPanGestureRecognizer extends PublicPanGestureRecognizer {
  VelocityPanGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  GestureVelocityDragUpdateCallback? onVelocityUpdate;

  @override
  void handleEvent(PointerEvent event) {
    super.handleEvent(event);

    final VelocityDragUpdateDetails? details = _buildDetailsFromEvent(event);
    if (details != null && onVelocityUpdate != null) {
      invokeCallback<void>(
        'onVelocityUpdate',
        () => onVelocityUpdate!(details),
      );
    }
  }

  VelocityDragUpdateDetails? _buildDetailsFromEvent(PointerEvent event) {
    return switch (event) {
      PointerMoveEvent() => _buildDetails(
        pointer: event.pointer,
        delta: event.localDelta,
        globalPosition: event.position,
        localPosition: event.localPosition,
        sourceTimeStamp: event.timeStamp,
      ),
      PointerPanZoomUpdateEvent() => _buildDetails(
        pointer: event.pointer,
        delta: event.localPanDelta,
        globalPosition: event.position + event.pan,
        localPosition: event.localPosition + event.localPan,
        sourceTimeStamp: event.timeStamp,
      ),
      _ => null,
    };
  }

  VelocityDragUpdateDetails? _buildDetails({
    required int pointer,
    required Offset delta,
    required Offset? globalPosition,
    required Offset? localPosition,
    required Duration? sourceTimeStamp,
  }) {
    if (delta == Offset.zero ||
        globalPosition == null ||
        localPosition == null) {
      return null;
    }

    final VelocityTracker tracker = velocityTrackers[pointer]!;
    final VelocityEstimate? estimate = tracker.getVelocityEstimate();

    return VelocityDragUpdateDetails(
      sourceTimeStamp: sourceTimeStamp,
      delta: delta,
      globalPosition: globalPosition,
      localPosition: localPosition,
      kind: getKindForPointer(pointer),
      velocity: Velocity(
        pixelsPerSecond: estimate?.pixelsPerSecond ?? Offset.zero,
      ),
    );
  }
}
