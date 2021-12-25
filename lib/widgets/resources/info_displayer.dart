import 'package:flutter/material.dart';
import 'package:sid_ui/sid_ui.dart';
import 'package:sid_utils/sid_utils.dart';


class InfoDisplayer extends StatelessWidget {

  final Widget title;
  final Widget background;
  final Widget value;
  final Widget? detail;
  final Color? color;
  final bool fill;
  final BorderRadius? radius;

  static String getString(double val){
    final ret = val.toStringAsFixed(1);
    List split = ret.split("");
    if(split.last == "0"){
      split.removeLast();
      split.removeLast();
      return split.join();
    }

    return ret;
  }

  const InfoDisplayer({
    required this.title,
    required this.background,
    required this.value,
    this.detail,
    this.color,
    this.radius,
    this.fill = false,
  });


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color? textColor 
      = (color?.brightness ?? theme.brightness) == (theme.brightness) 
        ? theme.brightness.contrast
        : color;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: fill ? BoxDecoration(
          borderRadius: radius ?? BorderRadius.circular(10),
          color: color?.withOpacity(
            color?.brightness == theme.brightness
              ? 0.5
              : 0.12
          ) ?? theme.colorScheme.onSurface.withOpacity(0.10),
        ) : null,
        child: SizedBox(height: 80, child: Stack(
          alignment: Alignment.center, 
          children: [

            Positioned.fill(child: Center(child: IconTheme.merge(
              data: (fill)
                ? IconThemeData(
                  color: theme.canvasColor,
                  opacity: 1.0,
                  size: 60,)
                : IconThemeData(
                  color: color,
                  opacity: color?.brightness == theme.brightness
                    ? 0.65
                    : 0.12,
                  size: 60,), 
              child: background,
            ),),),

            Positioned.fill(child: Center(child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: 30,
                color: textColor,
              ),
              child: value,
            ),),),

            Positioned(
              top: 0.0,
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: title,
                ),
              ),
            ),

            if(detail != null)
            Positioned(
              bottom: 0.0,
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: detail,
                ),
              ),
            ),

          ],
        ),),
      ),
    );
  }
}