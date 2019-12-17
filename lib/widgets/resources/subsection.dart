import 'package:flutter/material.dart';

class SubSection extends StatelessWidget {
  final List<Widget> children;
  const SubSection(this.children);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor.withOpacity(0.6);

    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: this.children,
      ),
    );
  }
}