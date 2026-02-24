import 'package:flutter/material.dart';
import 'package:sid_ui/sid_ui.dart';

import 'animations.dart';
import 'overlay_painter.dart';

class HighlightOverlay extends StatefulWidget {
  const HighlightOverlay({
    required this.center,
    required this.shape,
    required this.remove,
    required this.circleRadius,
    required this.childSize,
    super.key,
  });

  final Offset center;
  final OverlayShape shape;
  final double circleRadius;
  final VoidCallback remove;
  final Size childSize;

  @override
  State<HighlightOverlay> createState() => _HighlightOverlayState();
}

class _HighlightOverlayState extends State<HighlightOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: HighlightAnimations.duration,
    );
    init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void init() async {
    await controller.animateTo(
      1,
      duration: HighlightAnimations.duration,
      curve: Curves.linear,
    );
    if (mounted) {
      widget.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).brightness.contrast;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        final t = controller.value;
        final s = HighlightAnimations.circleSize(t);
        final o = HighlightAnimations.circleOpacity(t);
        return GestureDetector(
          onTapDown: (_) => widget.remove(),
          child: CustomPaint(
            painter: OverlayPainter(
              color: c.withValues(alpha: 0.5 * o),
              center: widget.center,
              fraction: 1 - s,
              shape: widget.shape,
              circleRadius: widget.circleRadius,
              childSize: widget.childSize,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}
