import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Positions its child so that the child's center lies exactly at [offset]
/// within the parent's coordinate space. The child may overflow the parent's
/// bounds (unlike [Align], which always keeps the child inside).
class OffsetAlignment extends SingleChildRenderObjectWidget {
  const OffsetAlignment({super.key, super.child, required this.offset});

  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderOffsetAlignment(offset: offset);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    if (renderObject is _RenderOffsetAlignment) renderObject.offset = offset;
  }
}

class _RenderOffsetAlignment extends RenderShiftedBox {
  _RenderOffsetAlignment({required Offset offset})
    : _offset = offset,
      super(null);

  Offset _offset;

  Offset get offset => _offset;
  set offset(Offset value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    if (child == null) return;

    child!.layout(constraints.loosen(), parentUsesSize: true);

    final childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = Offset(
      _offset.dx - child!.size.width / 2,
      _offset.dy - child!.size.height / 2,
    );
  }
}
