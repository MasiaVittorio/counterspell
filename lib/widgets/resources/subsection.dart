import 'package:flutter/material.dart';

class SubSection extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets margin;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final bool color;

  const SubSection(this.children, {
    this.crossAxisAlignment = CrossAxisAlignment.start, 
    this.margin = const EdgeInsets.symmetric(horizontal:10),
    this.onTap,
    this.borderRadius = borderRadiusDefault,
    this.color = true,
  }): assert(crossAxisAlignment != null),
      assert(margin != null);

  static const borderRadiusDefault = BorderRadius.all(Radius.circular(10.0));

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor.withOpacity(0.6);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ? background : null,
        borderRadius: borderRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Column(
          crossAxisAlignment: this.crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: this.children,
        ),
      ),
    );
  }
}