import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CenteredStack extends StatelessWidget {
  const CenteredStack({
    super.key,
    required this.child1,
    required this.child2,
    required this.show1,
  });

  final Widget child1;
  final Widget child2;
  final bool show1;

  @override
  Widget build(BuildContext context) {
    return _CenteredStack(
      show1: show1,
      children: [
        Opacity(opacity: show1 ? 1 : 0, child: child1),
        Opacity(opacity: !show1 ? 1 : 0, child: child2),
      ],
    );
  }
}

class _CenteredStack extends MultiChildRenderObjectWidget {
  const _CenteredStack({required super.children, required this.show1});

  final bool show1;

  @override
  _RenderCenteredStack createRenderObject(BuildContext context) {
    return _RenderCenteredStack(show1);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderCenteredStack renderObject,
  ) {
    renderObject.show1 = show1;
  }
}

class _RenderCenteredStack extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _CenteredStackParentData> {
  _RenderCenteredStack(bool show1) : _show1 = show1;

  bool get show1 => _show1;
  bool _show1;
  set show1(bool value) {
    if (_show1 == value) return;
    _show1 = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _CenteredStackParentData) {
      child.parentData = _CenteredStackParentData();
    }
  }

  @override
  void performLayout() {
    final child1 = firstChild;
    final child2 = childAfter(child1!)!;

    child1.layout(constraints.loosen(), parentUsesSize: true);
    child2.layout(constraints.loosen(), parentUsesSize: true);

    final size1 = child1.size;
    final size2 = child2.size;

    size = constraints.constrain(show1 ? size1 : size2);

    _positionChild(child1, size1);
    _positionChild(child2, size2);
  }

  void _positionChild(RenderBox child, Size childSize) {
    final childParentData = child.parentData as _CenteredStackParentData;

    final offsetX = (size.width - childSize.width) / 2;
    final offsetY = (size.height - childSize.height) / 2;

    childParentData.offset = Offset(offsetX, offsetY);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as _CenteredStackParentData;
      context.paintChild(child, offset + childParentData.offset);
      child = childAfter(child);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return false;
  }
}

class _CenteredStackParentData extends ContainerBoxParentData<RenderBox> {}
