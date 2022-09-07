
import 'package:counter_spell_new/widgets/resources/highlightable/overlay.dart';
import 'package:counter_spell_new/widgets/resources/highlightable/overlay_painter.dart';
import 'package:flutter/material.dart';
import 'package:sid_utils/sid_utils.dart';
import 'controller.dart';
import 'highlight_painter.dart';
import 'animations.dart';

export 'controller.dart';


class Highlightable extends StatefulWidget {

  const Highlightable({
    required this.controller,
    required this.child,
    this.borderRadius = 0,
    this.brightness,
    this.overlayShape = const OverlayShape(
      type: OverlayShapeType.circle,

    ),
    this.showOverlay = false,
    super.key,
  });

  final HighlightController controller;
  final Widget child;
  final double borderRadius;
  final Brightness? brightness;
  final bool showOverlay;
  final OverlayShape overlayShape;

  @override
  State<Highlightable> createState() => _HighlightableState();
}

class _HighlightableState extends State<Highlightable> 
with SingleTickerProviderStateMixin {

  HighlightController get controller => widget.controller;

  late AnimationController animation;
  OverlayEntry? overlayEntry;

  // Lifecycle

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this);
    controller.attach(launch);
  }

  @override
  void didUpdateWidget(covariant Highlightable oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.attach(launch);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.attach(launch);
  }

  @override
  void dispose() {
    // controller.detatch();
    animation.dispose();
    overlayEntry?.dispose();
    super.dispose();
  }

  // Animation

  Future<void> launch() async {
    if(!mounted){
      debugPrint("///////////////// you tried to launch disposed highlightable!!");
      return;
    }
    animation.value = 0.0;

    if(widget.showOverlay){

      final overlay = Overlay.of(context);
      if(overlay == null) return;

      final box = context.findRenderObject() as RenderBox;
      final size = box.size;
      final w = size.width;
      final h = size.height;

      overlayEntry = OverlayEntry(
        maintainState: false,
        opaque: false,
        builder: (_) => HighlightOverlay(
          remove: (){
            if(overlayEntry?.mounted ?? false){
              overlayEntry?.remove();
            }
          },
          center: box.localToGlobal(Offset.zero) 
                  + Offset(w / 2, h / 2),
          shape: widget.overlayShape,
          circleRadius: widget.overlayShape.calcCircleRadius(size),
          childSize: size,
        ),
      );

      overlay.insert(overlayEntry!);
    }

    await animation.animateTo(1.0, duration: HighlightAnimations.duration);
    if(!mounted) return;

    animation.value = 0.0;

  }


  // Build

  @override
  Widget build(BuildContext context) {
    final brightness = widget.brightness ?? Theme.of(context).brightness;
    return Stack(
      clipBehavior: Clip.hardEdge,
      fit: StackFit.loose,
      children: [
        Positioned.fill(child: background(brightness.contrast)),
        child,
      ],
    );
  }

  Widget background(Color color) => AnimatedBuilder(
    animation: animation, 
    builder: (_, child){
      final t = animation.value;
      final b = HighlightAnimations.breath(t);
      final s = HighlightAnimations.slide(t);
      return Container(
        decoration: BoxDecoration(
          color: color.withOpacity(b.mapToRangeLoose(0, 0.10)),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: CustomPaint(
            painter: HighlightPainter(
              radius: widget.borderRadius,
              width: 2,
              color: color.withOpacity(0.4),
              fraction: s,
            ),
          ),
        ),
      );
    },
  );

  Widget get child => AnimatedBuilder(
    animation: animation, 
    child: widget.child,
    builder: (_,child){
      final t = animation.value;
      final b = HighlightAnimations.breath(t);
      return Transform.scale(
        scale: b.mapToRangeLoose(1.0, 0.95),
        child: Opacity(
          opacity: b.mapToRangeLoose(1.0, 0.6),
          child: child!,
        ),
      );
    },
  );

}






