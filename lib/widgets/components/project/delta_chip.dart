import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class DeltaChip extends StatelessWidget {
  const DeltaChip({
    super.key,
    required this.icon,
    this.increment,
    required this.result,
    this.note,
  }) : boolean = false;
  const DeltaChip.result({
    super.key,
    required this.icon,
    required this.result,
    this.boolean = false,
    this.note,
  }) : increment = null;

  final IconData icon;
  final int? increment;
  final int result;
  final String? note;
  final bool boolean;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final colorScheme = theme.colorScheme;
    final background = increment == null
        ? colorScheme.primaryContainer
        : colorScheme.secondaryContainer;
    final foreground = increment == null
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSecondaryContainer;

    final mainChip = Material(
      borderRadius: BorderRadius.circular(layout.radius.small),
      color: background,
      child: Pad(
        vertical: layout.padding.tiny,
        horizontal: increment == null
            ? layout.padding.smaller
            : layout.padding.small,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: increment == null ? 18 : 20, color: foreground),
            if (increment case int increment)
              Pad(
                left: layout.spacing.tiny,
                child: Text(
                  '${increment > 0 ? '+' : ''}$increment',
                  style: theme.textTheme.labelLarge!.copyWith(
                    fontSize: theme.textTheme.bodyLarge!.fontSize,
                    color: foreground,
                  ),
                ),
              ),
            if ((!boolean) || increment != null)
              Pad(
                left: increment == null
                    ? layout.spacing.tiny
                    : layout.spacing.small,
                child: Text(
                  increment == null ? '$result' : '= $result',
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: foreground.withValues(
                      alpha: increment == null ? 1 : 0.65,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    final note = this.note;
    if (note == null) return mainChip;

    final noteBackground = colorScheme.surfaceContainerHigh;
    final noteForeground = colorScheme.onSurfaceVariant;

    return Material(
      borderRadius: BorderRadius.circular(layout.radius.small),
      color: noteBackground,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mainChip,
            Pad(
              horizontal: increment == null
                  ? layout.padding.tiny
                  : layout.padding.smaller,
              bottom: layout.spacing.tiny,
              child: Text(
                note,
                style: increment == null
                    ? theme.textTheme.bodySmall!.copyWith(color: noteForeground)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
