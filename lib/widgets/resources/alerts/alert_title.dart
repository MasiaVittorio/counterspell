import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

class AlertTitle extends StatelessWidget {
  final String title;
  const AlertTitle(this.title);

  static const double _minHeight = 32.0;
  static const double _dragHeight = 16.0;
  static const double _padding = 8.0;
  static const bool _drag = true;
  static const double height = _drag ? _minHeight + _padding + _dragHeight : _minHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = DefaultTextStyle.of(context).style;

    final title = Container(
      height: _minHeight,
      alignment: Alignment.center,
      child:Text(
        this.title,
        style: style.copyWith(
          color: RightContrast(
            Theme.of(context), 
            fallbackOnTextTheme: true
          ).onCanvas,
          fontWeight: incrementFontWeight[style.fontWeight],
        ),
      ),
    );

    return Container(
      alignment: Alignment.center,
      height: height,
      child: _drag 
        ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: _dragHeight,
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                height: _dragHeight/2,
                width: 34.0,
              ),
            ),
            SizedBox(height: _padding,),
            title,
          ],
        )
        : title,
    );
  }
}