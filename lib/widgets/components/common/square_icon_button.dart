import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.dimension,
    required this.icon,
    this.onPressed,
  });

  final double dimension;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: dimension, maxHeight: dimension),
      child: InkResponse(
        onTap: onPressed,
        child: Center(
          child: IconTheme(
            data: IconTheme.of(context).copyWith(
              color: colorScheme.onSurfaceVariant.withValues(
                alpha: onPressed == null ? 0.38 : 1,
              ),
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
