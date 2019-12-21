import 'package:flutter/material.dart';

class SubSection extends StatelessWidget {
  final List<Widget> children;
  final bool stretch;
  final EdgeInsets margin;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  const SubSection(this.children, {
    this.stretch = false, 
    this.margin = const EdgeInsets.symmetric(horizontal:10),
    this.onTap,
    this.borderRadius = borderRadiusDefault,
  }): assert(stretch != null),
      assert(margin != null);

  static const borderRadiusDefault = BorderRadius.all(Radius.circular(10.0));

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor.withOpacity(0.6);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: background,
        borderRadius: borderRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Column(
          crossAxisAlignment: stretch 
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: this.children,
        ),
      ),
    );
  }
}