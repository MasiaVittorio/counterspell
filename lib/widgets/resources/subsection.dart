import 'package:flutter/material.dart';

class SubSection extends StatelessWidget {
  final List<Widget> children;
  final bool stretch;
  final double margin;
  final VoidCallback onTap;
  const SubSection(this.children, {
    this.stretch = false, 
    this.margin = 10,
    this.onTap,
  }): assert(stretch != null),
      assert(margin != null);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor.withOpacity(0.6);

    return Container(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
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