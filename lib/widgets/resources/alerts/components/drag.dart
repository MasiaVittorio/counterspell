import 'package:flutter/material.dart';

class AlertDrag extends StatelessWidget {
  const AlertDrag();

  static const double height = 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50),
        ),
        height: 8.0,
        width: 34.0,
      ),
    );
   }
}