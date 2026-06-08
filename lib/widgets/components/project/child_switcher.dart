import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sid_base/sid_base.dart';

class ChildSwitcher extends StatefulWidget {
  const ChildSwitcher({
    super.key,
    required this.child,
    required this.constraints,
    required this.duration,
    required this.curve,
    required this.opacityOverlap,
  });

  final Widget child;
  final BoxConstraints constraints;
  final Duration duration;
  final Curve curve;

  /// 0: the two children are never visible together (each reach 0 opacity at t = 0.5).
  /// 1: the two children immediately start changing their opacity at the start of the animation, so they will be seen together
  final double opacityOverlap;

  @override
  State<ChildSwitcher> createState() => _ChildSwitcherState();
}

enum _ChildAim { a, b }

class _ChildSwitcherState extends State<ChildSwitcher> {
  Widget? childA;
  BoxConstraints? childAConstraints;

  Widget? childB;
  BoxConstraints? childBConstraints;

  _ChildAim aim = _ChildAim.a;

  @override
  void initState() {
    super.initState();
    childA = widget.child;
    childAConstraints = widget.constraints;
  }

  @override
  void didUpdateWidget(covariant ChildSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child.key != oldWidget.child.key) {
      switch (aim) {
        case _ChildAim.a:
          childB = widget.child;
          childBConstraints = widget.constraints;
          aim = _ChildAim.b;
          return;
        case _ChildAim.b:
          childA = widget.child;
          childAConstraints = widget.constraints;
          aim = _ChildAim.a;
          return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fs = widget.opacityOverlap.rangeMap(to: (0.5, 0));
    final fe = widget.opacityOverlap.rangeMap(to: (0.5, 1));
    return GenericAnimatedBuilder(
      value: switch (aim) {
        _ChildAim.a => 0,
        _ChildAim.b => 1,
      },
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        return ClipRect(
          child: _AlertSwitcherRender(
            t: value,
            childA: Opacity(
              opacity: value.rangeMap(from: (0, fe), to: (1, 0)),
              child: childA,
            ),
            childB: Opacity(
              opacity: value.rangeMap(from: (fs, 1), to: (0, 1)),
              child: childB,
            ),
            constraintsA: childAConstraints ?? BoxConstraints.tight(Size.zero),
            constraintsB: childBConstraints ?? BoxConstraints.tight(Size.zero),
          ),
        );
      },
    );
  }
}

class _AlertSwitcherRender extends MultiChildRenderObjectWidget {
  _AlertSwitcherRender({
    required this.t, // interpolation parameter 0..1 (a..b)
    required Widget childA,
    required Widget childB,
    required this.constraintsA,
    required this.constraintsB,
  }) : assert(t >= 0 && t <= 1),
       super(children: [childA, childB]);

  final double t;
  final BoxConstraints constraintsA;
  final BoxConstraints constraintsB;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSAS(
      t: t,
      constraintsA: constraintsA,
      constraintsB: constraintsB,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderSAS renderObject,
  ) {
    renderObject.t = t;
    renderObject.constraintsA = constraintsA;
    renderObject.constraintsB = constraintsB;
  }
}

class _SASPD extends ContainerBoxParentData<RenderBox> {}

class _RenderSAS extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _SASPD>,
        RenderBoxContainerDefaultsMixin<RenderBox, _SASPD> {
  _RenderSAS({
    required double t,
    required BoxConstraints constraintsA,
    required BoxConstraints constraintsB,
  }) : _t = t,
       _constraintsA = constraintsA,
       _constraintsB = constraintsB;

  double get t => _t;
  double _t;
  set t(double value) {
    if (_t == value) return;
    assert(value >= 0 && value <= 1);
    _t = value;
    markNeedsLayout();
  }

  BoxConstraints get constraintsA => _constraintsA;
  BoxConstraints _constraintsA;
  set constraintsA(BoxConstraints value) {
    if (_constraintsA == value) return;
    _constraintsA = value;
    markNeedsLayout();
  }

  BoxConstraints get constraintsB => _constraintsB;
  BoxConstraints _constraintsB;
  set constraintsB(BoxConstraints value) {
    if (_constraintsB == value) return;
    _constraintsB = value;
    markNeedsLayout();
  }

  bool get applyParallax => false;

  @override
  void performLayout() {
    RenderBox? a = firstChild;
    RenderBox? b = (a != null) ? (a.parentData as _SASPD).nextSibling : null;

    Size sizeA = Size.zero;
    if (a != null) {
      a.layout(_constraintsA, parentUsesSize: true);
      sizeA = a.size;
    }
    Size sizeB = Size.zero;
    if (b != null) {
      b.layout(_constraintsB, parentUsesSize: true);
      sizeB = b.size;
    }

    // Interpolate dimensions between the two children using t
    double chosenWidth = _t.rangeMap(to: (sizeA.width, sizeB.width));
    double chosenHeight = _t.rangeMap(to: (sizeA.height, sizeB.height));

    size = constraints.constrain(Size(chosenWidth, chosenHeight));

    if (a != null) {
      final deltaY =
          switch (sizeB.height - sizeA.height) {
            > 0 => -1,
            < 0 => 1,
            _ => -1,
          } *
          0.3 *
          sizeA.height;
      final _SASPD apd = a.parentData as _SASPD;
      apd.offset =
          Alignment.topCenter.alongOffset(size - sizeA as Offset) +
          (applyParallax
              ? Offset(0, _t.rangeMap(from: (0, .5), to: (0, deltaY)))
              : Offset.zero);
    }
    if (b != null) {
      final _SASPD bpd = b.parentData as _SASPD;
      final deltaY =
          switch (sizeB.height - sizeA.height) {
            > 0 => 1,
            < 0 => -1,
            _ => 1,
          } *
          0.3 *
          sizeB.height;

      bpd.offset =
          Alignment.topCenter.alongOffset(size - sizeB as Offset) +
          (applyParallax
              ? Offset(0, _t.rangeMap(from: (.5, 1), to: (deltaY, 0)))
              : Offset.zero);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint children directly without clipping.
    RenderBox? child = firstChild;
    while (child != null) {
      final _SASPD pd = child.parentData as _SASPD;
      context.paintChild(child, offset + pd.offset);
      child = pd.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    // Only test inside the visible clipped region (size).
    if (position.dx < 0 ||
        position.dy < 0 ||
        position.dx > size.width ||
        position.dy > size.height) {
      return false;
    }
    RenderBox? child = firstChild;
    int index = 0;
    while (child != null) {
      final _SASPD pd = child.parentData as _SASPD;
      if (t.round() == index) {
        return result.addWithPaintOffset(
          offset: pd.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return child!.hitTest(result, position: transformed);
          },
        );
      }

      child = pd.nextSibling;
      index++;
    }
    return false;
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _SASPD) {
      child.parentData = _SASPD();
    }
  }
}
