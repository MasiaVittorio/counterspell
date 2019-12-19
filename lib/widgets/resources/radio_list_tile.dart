import 'package:flutter/material.dart';


class SidRadioListTile<T> extends StatelessWidget {

  final T value;

  final T groupValue;

  final ValueChanged<T> onChanged;

  final Color activeColor;

  final Widget title;
  final Widget subtitle;

  final Widget secondary;

  SidRadioListTile({
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    this.title,
    this.subtitle,
    this.secondary,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final canvas = theme.canvasColor;
    final selectedBkg = theme.scaffoldBackgroundColor.withOpacity(0.6);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: value == groupValue ? selectedBkg : canvas,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: RadioListTile<T>(
          value: value,
          groupValue: groupValue,
          onChanged: this.onChanged,
          title: title,
          subtitle: subtitle,
          secondary: secondary,
          activeColor: activeColor,
        ),
      ),
    );
  }
}