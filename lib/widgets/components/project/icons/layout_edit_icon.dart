import 'package:flutter/material.dart';

class LayoutEditIcon extends StatelessWidget {
  const LayoutEditIcon({super.key, this.size, this.color, this.filled = false});

  final double? size;
  final Color? color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Icon(filled ? filledIcon : outlinedIcon, size: size, color: color);
  }

  static const IconData outlinedIcon = Icons.view_quilt_outlined;
  static const IconData filledIcon = Icons.view_quilt;
}
