import 'package:flutter/material.dart';


class SidChip extends StatelessWidget {

  final IconData? icon;
  final String text;
  final String? subText;
  final Color? color;
  final DecorationImage? image;
  final Color? forceTextColor;

  const SidChip({
    this.icon,
    this.subText,
    required this.text,
    this.color,
    this.image,
    this.forceTextColor,
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
    final textColor = forceTextColor ?? ((brightness == Brightness.dark)
      ? Colors.white
      : Colors.black);
    
    final chip = Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        image: image,
        borderRadius: BorderRadius.circular(height),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if(icon != null)
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
            padding: EdgeInsets.only(
              left: icon != null ? 4.0 : 11.0, 
              right: 11.0
            ),
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

    if(subText == null){
      return chip;
    }
 

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              subText!,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
