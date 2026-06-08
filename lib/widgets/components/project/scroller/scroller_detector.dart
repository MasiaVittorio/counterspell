import 'package:counter_spell/models/interaction/velocity_drag_update_details.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'velocity_drag_recognizer.dart';

class ScrollerDetector extends StatelessWidget {
  const ScrollerDetector({
    super.key,
    required this.onDragEnd,
    required this.onDragUpdate,
    required this.onDragStart,
    required this.child,
  });

  final Widget child;
  final VoidCallback? onDragEnd;
  final void Function(DragStartDetails details)? onDragStart;
  final void Function(VelocityDragUpdateDetails details)? onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        VelocityPanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VelocityPanGestureRecognizer>(
              () => VelocityPanGestureRecognizer(debugOwner: this),
              (VelocityPanGestureRecognizer recognizer) {
                recognizer
                  ..dragStartBehavior = DragStartBehavior.down
                  ..onVelocityUpdate = onDragUpdate
                  ..onCancel = onDragEnd
                  ..onStart = onDragStart
                  ..onEnd = onDragEnd == null ? null : (_) => onDragEnd?.call();
              },
            ),
      },
      child: child,
    );
  }
}
