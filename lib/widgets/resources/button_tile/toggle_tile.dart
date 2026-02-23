import 'package:counter_spell/core.dart';

class ToggleTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;
  final IconData? iconOff;
  final String text;
  final Color? colorOn;
  final Color? colorOff;
  final double? iconSize;
  final bool twoLines;
  final bool shrinkWrap;

  const ToggleTile({super.key, 
    required this.value,
    required this.onChanged,
    required this.icon,
    this.iconOff,
    required this.text,
    this.colorOn,
    this.colorOff,
    this.iconSize,
    this.twoLines = false,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorOff =
        this.colorOff ?? theme.colorScheme.onSurface.withValues(alpha: 0.1);
    final colorOn =
        this.colorOn ?? theme.colorScheme.secondary.withValues(alpha: 0.8);

    final iconColorOn = colorOn.contrast;
    final iconColorOff = theme.colorScheme.onSurface.withValues(alpha: 0.55);

    return IconTheme.merge(
      data: const IconThemeData(opacity: 1.0),
      child: AnimatedDouble(
        value: value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        builder: (_, val) {
          return ButtonTile(
            customIcon: Icon(
              value ? icon : iconOff ?? icon,
              size: iconSize,
              color: Color.lerp(iconColorOff, iconColorOn, val),
            ),
            icon: null,
            text: text,
            circleColor: Color.lerp(colorOff, colorOn, val),
            onTap: () => onChanged(!value),
            twoLines: twoLines,
            shrinkWrap: shrinkWrap,
            filled: false,
          );
        },
      ),
    );
  }
}
