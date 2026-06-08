import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ExtraNote extends StatelessWidget {
  const ExtraNote({
    super.key,
    required this.note,
    this.overrideTopPadding,
    this.skipIcon = false,
  });

  final String note;

  final double? overrideTopPadding;

  final bool skipIcon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    var foregroundColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.8,
    );
    return Pad(
      horizontal: layout.margin.large,
      top: overrideTopPadding ?? layout.margin.medium,
      bottom: layout.margin.small,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!skipIcon)
            Al.centerLeft(
              child: Icon(Icons.info_outline, color: foregroundColor),
            ),
          Text(
            note,
            style: theme.textTheme.bodyMedium!.copyWith(color: foregroundColor),
          ),
        ].separateWith(Space.vertical(layout.spacing.large)),
      ),
    );
  }
}
