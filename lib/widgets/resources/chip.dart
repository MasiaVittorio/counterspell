import 'package:flutter/material.dart';


class SidChip extends StatelessWidget {

  final IconData icon;
  final String text;
  final String subText;
  final Color color;

  const SidChip({
    @required this.icon,
    @required this.subText,
    @required this.text,
    this.color,
  });

  static const double height = 35;
  static Color backgroundColor(ThemeData theme) => Color.alphaBlend(
    theme.colorScheme.onSurface.withOpacity(0.1), 
    theme.scaffoldBackgroundColor,
  );
  
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final Color color = this.color ?? theme.primaryColor;

    final brightness = ThemeData.estimateBrightnessForColor(color);
    final textColor = brightness == Brightness.dark
      ? Colors.white
      : Colors.black;
    
    final chip = Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: height,
            width: height,
            child: IconTheme(
              data: IconThemeData(
                opacity: 1.0,
                color: textColor,
                size: 18,
              ),
              child: Icon(icon),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 11.0),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      )
    );
 

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor(theme),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(height / 2),
          bottom: Radius.circular(height / 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          chip,
          Text(
            subText,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
