// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/gestures.dart';

enum _DragState {
  ready,
  possible,
  accepted,
}

class CSDragUpdateDetails {
  CSDragUpdateDetails({
    this.sourceTimeStamp,
    this.delta = Offset.zero,
    this.primaryDelta,
    @required this.globalPosition,
    @required this.velocity,
    Offset localPosition,
  }) : assert(delta != null),
       assert(primaryDelta == null
           || (primaryDelta == delta.dx && delta.dy == 0.0)
           || (primaryDelta == delta.dy && delta.dx == 0.0)),
       localPosition = localPosition ?? globalPosition;

  final Duration sourceTimeStamp;

  final Offset delta;

  final double primaryDelta;

  final Offset globalPosition;

  final Offset localPosition;

  final Velocity velocity;

  @override
  String toString() => '$runtimeType($delta)';
}


typedef CSGestureDragEndCallback = void Function(DragEndDetails details);

typedef CSGestureDragCancelCallback = void Function();
typedef CSGestureDragUpdateCallback = void Function(CSDragUpdateDetails details);


abstract class CSDragGestureRecognizer extends OneSequenceGestureRecognizer {

  CSDragGestureRecognizer({
    Object debugOwner,
    PointerDeviceKind kind,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : assert(dragStartBehavior != null),
       super(debugOwner: debugOwner, kind: kind);


  DragStartBehavior dragStartBehavior;

  GestureDragDownCallback onDown;

  GestureDragStartCallback onStart;

  CSGestureDragUpdateCallback onUpdate;

  CSGestureDragEndCallback onEnd;

  CSGestureDragCancelCallback onCancel;

  double minFlingDistance;

  double minFlingVelocity;

  double maxFlingVelocity;

  _DragState _state = _DragState.ready;
  OffsetPair _initialPosition;
  OffsetPair _pendingDragOffset;
  Duration _lastPendingEventTimestamp;
  // The buttons sent by `PointerDownEvent`. If a `PointerMoveEvent` comes with a
  // different set of buttons, the gesture is canceled.
  int _initialButtons;
  Matrix4 _lastTransform;

  /// Distance moved in the global coordinate space of the screen in drag direction.
  ///
  /// If drag is only allowed along a defined axis, this value may be negative to
  /// differentiate the direction of the drag.
  double _globalDistanceMoved;

  bool _isFlingGesture(VelocityEstimate estimate);
  Offset _getDeltaForDetails(Offset delta);
  double _getPrimaryValueFromOffset(Offset value);
  bool get _hasSufficientGlobalDistanceToAccept;

  final Map<int, VelocityTracker> _velocityTrackers = <int, VelocityTracker>{};

  @override
  bool isPointerAllowed(PointerEvent event) {
    if (_initialButtons == null) {
      switch (event.buttons) {
        case kPrimaryButton:
          if (onDown == null &&
              onStart == null &&
              onUpdate == null &&
              onEnd == null &&
              onCancel == null)
            return false;
          break;
        default:
          return false;
      }
    } else {
      // There can be multiple drags simultaneously. Their effects are combined.
      if (event.buttons != _initialButtons) {
        return false;
      }
    }
    return super.isPointerAllowed(event);
  }

  @override
  void addAllowedPointer(PointerEvent event) {
    startTrackingPointer(event.pointer, event.transform);
    _velocityTrackers[event.pointer] = VelocityTracker();
    if (_state == _DragState.ready) {
      _state = _DragState.possible;
      _initialPosition = OffsetPair(global: event.position, local: event.localPosition);
      _initialButtons = event.buttons;
      _pendingDragOffset = OffsetPair.zero;
      _globalDistanceMoved = 0.0;
      _lastPendingEventTimestamp = event.timeStamp;
      _lastTransform = event.transform;
      _checkDown();
    } else if (_state == _DragState.accepted) {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    assert(_state != _DragState.ready);
    if (!event.synthesized
        && (event is PointerDownEvent || event is PointerMoveEvent)) {
      final VelocityTracker tracker = _velocityTrackers[event.pointer];
      assert(tracker != null);
      tracker.addPosition(event.timeStamp, event.localPosition);
    }

    if (event is PointerMoveEvent) {
      if (event.buttons != _initialButtons) {
        resolve(GestureDisposition.rejected);
        stopTrackingPointer(event.pointer);
        return;
      }
      if (_state == _DragState.accepted) {
        _checkUpdate(
          pointer: event.pointer,
          sourceTimeStamp: event.timeStamp,
          delta: _getDeltaForDetails(event.localDelta),
          primaryDelta: _getPrimaryValueFromOffset(event.localDelta),
          globalPosition: event.position,
          localPosition: event.localPosition,
        );
      } else {
        _pendingDragOffset += OffsetPair(local: event.localDelta, global: event.delta);
        _lastPendingEventTimestamp = event.timeStamp;
        _lastTransform = event.transform;
        final Offset movedLocally = _getDeltaForDetails(event.localDelta);
        final Matrix4 localToGlobalTransform = event.transform == null ? null : Matrix4.tryInvert(event.transform);
        _globalDistanceMoved += PointerEvent.transformDeltaViaPositions(
          transform: localToGlobalTransform,
          untransformedDelta: movedLocally,
          untransformedEndPosition: event.localPosition,
        ).distance * (_getPrimaryValueFromOffset(movedLocally) ?? 1).sign;
        if (_hasSufficientGlobalDistanceToAccept)
          resolve(GestureDisposition.accepted);
      }
    }
    stopTrackingIfPointerNoLongerDown(event);
  }

  @override
  void acceptGesture(int pointer) {
    if (_state != _DragState.accepted) {
      _state = _DragState.accepted;
      final OffsetPair delta = _pendingDragOffset;
      final Duration timestamp = _lastPendingEventTimestamp;
      final Matrix4 transform = _lastTransform;
      Offset localUpdateDelta;
      switch (dragStartBehavior) {
        case DragStartBehavior.start:
          _initialPosition = _initialPosition + delta;
          localUpdateDelta = Offset.zero;
          break;
        case DragStartBehavior.down:
          localUpdateDelta = _getDeltaForDetails(delta.local);
          break;
      }
      _pendingDragOffset = OffsetPair.zero;
      _lastPendingEventTimestamp = null;
      _lastTransform = null;
      _checkStart(timestamp);
      if (localUpdateDelta != Offset.zero && onUpdate != null) {
        final Matrix4 localToGlobal = transform != null ? Matrix4.tryInvert(transform) : null;
        final Offset correctedLocalPosition = _initialPosition.local + localUpdateDelta;
        final Offset globalUpdateDelta = PointerEvent.transformDeltaViaPositions(
          untransformedEndPosition: correctedLocalPosition,
          untransformedDelta: localUpdateDelta,
          transform: localToGlobal,
        );
        final OffsetPair updateDelta = OffsetPair(local: localUpdateDelta, global: globalUpdateDelta);
        final OffsetPair correctedPosition = _initialPosition + updateDelta; // Only adds delta for down behaviour
        _checkUpdate(
          pointer: pointer,
          sourceTimeStamp: timestamp,
          delta: localUpdateDelta,
          primaryDelta: _getPrimaryValueFromOffset(localUpdateDelta),
          globalPosition: correctedPosition.global,
          localPosition: correctedPosition.local,
        );
      }
    }
  }

  @override
  void rejectGesture(int pointer) {
    stopTrackingPointer(pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    assert(_state != _DragState.ready);
    switch(_state) {
      case _DragState.ready:
        break;

      case _DragState.possible:
        resolve(GestureDisposition.rejected);
        _checkCancel();
        break;

      case _DragState.accepted:
        _checkEnd(pointer);
        break;
    }
    _velocityTrackers.clear();
    _initialButtons = null;
    _state = _DragState.ready;
  }

  void _checkDown() {
    assert(_initialButtons == kPrimaryButton);
    final DragDownDetails details = DragDownDetails(
      globalPosition: _initialPosition.global,
      localPosition: _initialPosition.local,
    );
    if (onDown != null)
      invokeCallback<void>('onDown', () => onDown(details));
  }

  void _checkStart(Duration timestamp) {
    assert(_initialButtons == kPrimaryButton);
    final DragStartDetails details = DragStartDetails(
      sourceTimeStamp: timestamp,
      globalPosition: _initialPosition.global,
      localPosition: _initialPosition.local,
    );
    if (onStart != null)
      invokeCallback<void>('onStart', () => onStart(details));
  }

  void _checkUpdate({
    @required int pointer,
    Duration sourceTimeStamp,
    Offset delta,
    double primaryDelta,
    Offset globalPosition,
    Offset localPosition,
  }) {
    final VelocityTracker tracker = _velocityTrackers[pointer];
    assert(tracker != null);
    assert(_initialButtons == kPrimaryButton);
    final VelocityEstimate estimate = tracker.getVelocityEstimate();

    if (onUpdate == null) return;

    CSDragUpdateDetails details;

    if (estimate != null && _isFlingGesture(estimate)) {

      final Velocity velocity = Velocity(pixelsPerSecond: estimate.pixelsPerSecond)
        .clampMagnitude(minFlingVelocity ?? kMinFlingVelocity, maxFlingVelocity ?? kMaxFlingVelocity);
      details = CSDragUpdateDetails(
        sourceTimeStamp: sourceTimeStamp,
        delta: delta,
        primaryDelta: primaryDelta,
        globalPosition: globalPosition,
        localPosition: localPosition,
        velocity: velocity,
      );

    } else {

      details = CSDragUpdateDetails(
        sourceTimeStamp: sourceTimeStamp,
        delta: delta,
        primaryDelta: primaryDelta,
        globalPosition: globalPosition,
        localPosition: localPosition,
        velocity: Velocity.zero,
      );

    }

    invokeCallback<void>('onUpdate', () => onUpdate(details));
  }

  void _checkEnd(int pointer) {
    assert(_initialButtons == kPrimaryButton);
    if (onEnd == null)
      return;

    final VelocityTracker tracker = _velocityTrackers[pointer];
    assert(tracker != null);

    DragEndDetails details;
    void Function() debugReport;

    final VelocityEstimate estimate = tracker.getVelocityEstimate();
    if (estimate != null && _isFlingGesture(estimate)) {
      final Velocity velocity = Velocity(pixelsPerSecond: estimate.pixelsPerSecond)
        .clampMagnitude(minFlingVelocity ?? kMinFlingVelocity, maxFlingVelocity ?? kMaxFlingVelocity);
      details = DragEndDetails(
        velocity: velocity,
        primaryVelocity: _getPrimaryValueFromOffset(velocity.pixelsPerSecond),
      );
      debugReport = () {
        return '$estimate; fling at $velocity.';
      };
    } else {
      details = DragEndDetails(
        velocity: Velocity.zero,
        primaryVelocity: 0.0,
      );
      debugReport = () {
        if (estimate == null)
          return 'Could not estimate velocity.';
        return '$estimate; judged to not be a fling.';
      };
    }
    invokeCallback<void>('onEnd', () => onEnd(details), debugReport: debugReport);
  }

  void _checkCancel() {
    assert(_initialButtons == kPrimaryButton);
    if (onCancel != null)
      invokeCallback<void>('onCancel', onCancel);
  }

  @override
  void dispose() {
    _velocityTrackers.clear();
    super.dispose();
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<DragStartBehavior>('start behavior', dragStartBehavior));
  }
}



class CSHorizontalDragGestureRecognizer extends CSDragGestureRecognizer {
  /// Create a gesture recognizer for interactions in the horizontal axis.
  ///
  /// {@macro flutter.gestures.gestureRecognizer.kind}
  CSHorizontalDragGestureRecognizer({
    Object debugOwner,
    PointerDeviceKind kind,
  }) : super(debugOwner: debugOwner, kind: kind);

  @override
  bool _isFlingGesture(VelocityEstimate estimate) {
    final double minVelocity = minFlingVelocity ?? kMinFlingVelocity;
    final double minDistance = minFlingDistance ?? kTouchSlop;
    return estimate.pixelsPerSecond.dx.abs() > minVelocity && estimate.offset.dx.abs() > minDistance;
  }

  @override
  bool get _hasSufficientGlobalDistanceToAccept => _globalDistanceMoved.abs() > kTouchSlop;

  @override
  Offset _getDeltaForDetails(Offset delta) => Offset(delta.dx, 0.0);

  @override
  double _getPrimaryValueFromOffset(Offset value) => value.dx;

  @override
  String get debugDescription => 'horizontal drag';
}


class CSPanGestureRecognizer extends CSDragGestureRecognizer {
  /// Create a gesture recognizer for tracking movement on a plane.
  CSPanGestureRecognizer({ Object debugOwner }) : super(debugOwner: debugOwner);

  @override
  bool _isFlingGesture(VelocityEstimate estimate) {
    final double minVelocity = minFlingVelocity ?? kMinFlingVelocity;
    final double minDistance = minFlingDistance ?? kTouchSlop;
    return estimate.pixelsPerSecond.distanceSquared > minVelocity * minVelocity
        && estimate.offset.distanceSquared > minDistance * minDistance;
  }

  @override
  bool get _hasSufficientGlobalDistanceToAccept {
    return _globalDistanceMoved.abs() > kPanSlop;
  }

  @override
  Offset _getDeltaForDetails(Offset delta) => delta;

  @override
  double _getPrimaryValueFromOffset(Offset value) => null;

  @override
  String get debugDescription => 'pan';
}
