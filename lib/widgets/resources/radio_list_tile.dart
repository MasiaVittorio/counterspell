import 'package:flutter/material.dart';

class SidRadioListTile<T> extends StatelessWidget {
  final T value;

  final Color? activeColor;

  final Widget? title;
  final Widget? subtitle;

  final Widget? secondary;

  const SidRadioListTile({
    super.key,
    required this.value,
    this.title,
    this.subtitle,
    this.secondary,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final canvas = theme.canvasColor;
    final selectedBkg = theme.scaffoldBackgroundColor.withValues(alpha: 0.6);

    final radioGroup = RadioGroup.maybeOf<T>(context);
    final bool isSelected = radioGroup?.groupValue == value;

    void toggle() {
      if (isSelected) {
        // radioGroup?.onChanged.call(null);
      } else {
        radioGroup?.onChanged.call(value);
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected ? selectedBkg : canvas,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          leading: Radio<T>(
            value: value,
            activeColor: activeColor,
          ),
          onTap: toggle,
          title: title,
          subtitle: subtitle,
          trailing: secondary,
        ),
      ),
    );
  }
}
