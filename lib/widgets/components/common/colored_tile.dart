import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ColoredTile extends StatelessWidget {
  const ColoredTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.seed,
    this.onTap,
    this.containTrailing = true,
    this.containLeading = true,
    this.lowLeading = false,
    this.outlineLeading = false,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color? seed;
  final VoidCallback? onTap;
  final bool containTrailing;
  final bool containLeading;
  final bool lowLeading;
  final bool outlineLeading;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final scheme = ColorScheme.fromSeed(
      seedColor: seed ?? theme.colorScheme.primary,
      brightness: theme.brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
      contrastLevel: 1,
    );

    final child = ListTile(
      minVerticalPadding: layout.margin.medium,
      onTap: onTap,
      leading: switch (leading) {
        null => null,
        Widget leading =>
          containLeading
              ? ColoredTile.leadingIcon(
                  context,
                  scheme,
                  leading,
                  low: lowLeading,
                  outline: outlineLeading,
                )
              : leading,
      },
      contentPadding: EdgeInsets.only(
        left: 16,
        right: trailing != null && containTrailing ? 12 : 22,
      ),
      trailing: switch (trailing) {
        null => null,
        Widget trailing =>
          containTrailing
              ? IconButton.filled(
                  onPressed: onTap,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      scheme.surfaceContainerHighest,
                    ),
                    foregroundColor: WidgetStatePropertyAll(scheme.primary),
                  ),
                  icon: trailing,
                )
              : trailing,
      },
      title: title,
      subtitle: subtitle,
    );

    if (seed == null) return child;

    return Theme(
      data: theme.copyWith(colorScheme: scheme),
      child: child,
    );
  }

  static Widget leadingIcon(
    BuildContext context,
    ColorScheme scheme,
    Widget icon, {
    bool outline = false,
    bool low = false,
  }) {
    final layout = context.theme.layout;
    return Material(
      color: low ? scheme.surfaceContainerLowest : scheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9999),
        side: outline
            ? BorderSide(color: scheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: SizedBox.square(
        dimension: layout.buttonSize.large,
        child: Center(
          child: IconTheme(
            data: IconTheme.of(context).copyWith(color: scheme.inversePrimary),
            child: icon,
          ),
        ),
      ),
    );
  }
}
