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

  static const double _height = 35;
  
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final Color color = this.color ?? theme.primaryColor;

    final brightness = ThemeData.estimateBrightnessForColor(color);
    final textColor = brightness == Brightness.dark
      ? Colors.white
      : Colors.black;
    
    final chip = Container(
      height: _height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(_height),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: _height,
            width: _height,
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

    final littleDarker = theme
      .colorScheme
      .onSurface
      .withOpacity(0.1); 

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: littleDarker,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_height / 2),
            bottom: Radius.circular(_height / 2),
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
      ),
    );
  }
}
