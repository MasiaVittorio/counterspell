import 'package:flutter/material.dart';

class SmallProgressIndicator extends StatelessWidget {
  const SmallProgressIndicator({super.key, this.strokeWidth = 2});
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 24,
      child: CircularProgressIndicator(strokeWidth: strokeWidth),
    );
  }
}
