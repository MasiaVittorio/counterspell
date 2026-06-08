import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class MyChip extends StatelessWidget {
  const MyChip({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.onDelete,
    this.selected,
    this.overrideDeleteIcon,
    this.rounded = false,
  });

  final String label;
  final IconData? icon;
  final IconData? overrideDeleteIcon;
  final VoidCallback? onPressed;
  final VoidCallback? onDelete;
  final bool? selected;
  final bool rounded;

  static const double height = 32.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final Color foreground = switch (selected) {
      false => theme.colorScheme.onSurfaceVariant,
      true => theme.colorScheme.onPrimaryContainer,
      null => theme.colorScheme.onSurface,
    };

    return Material(
      borderRadius: BorderRadius.circular(
        rounded ? height / 2 : layout.radius.smaller,
      ),
      color: switch (selected) {
        false => theme.colorScheme.surfaceContainerLowest,
        true => theme.colorScheme.primaryContainer,
        null => theme.colorScheme.surfaceContainerHigh,
      },
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: height,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon case final IconData icon) ...[
                SizedBox.square(
                  dimension: height,
                  child: Center(child: Icon(icon, size: 18, color: foreground)),
                ),
              ] else
                Space.horizontal(layout.padding.medium),
              Text(
                label,
                style: theme.textTheme.bodyMedium!.copyWith(color: foreground),
              ),
              if (onDelete case final VoidCallback onDelete) ...[
                SizedBox.square(
                  dimension: height,
                  child: InkResponse(
                    onTap: onDelete,
                    child: Center(
                      child: Icon(
                        overrideDeleteIcon ?? Icons.delete_forever,
                        color: theme.colorScheme.error,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ] else
                Space.horizontal(layout.padding.medium),
            ],
          ),
        ),
      ),
    );
  }
}
