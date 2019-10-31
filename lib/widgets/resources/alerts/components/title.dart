import 'package:counter_spell_new/widgets/resources/alerts/components/components.dart';
import 'package:counter_spell_new/widgets/resources/alerts/components/drag.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

class AlertTitle extends StatelessWidget {
  final String title;
  const AlertTitle(this.title);

  static const double _minHeight = 30.0;

  static const double height = AlertComponents.drag ? _minHeight + AlertDrag.height : _minHeight;

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
            theme, 
            fallbackOnTextTheme: true
          ).onCanvas,
          fontWeight: incrementFontWeight[style.fontWeight],
        ),
      ),
    );

    return Container(
      alignment: Alignment.center,
      height: height,
      child: AlertComponents.drag 
        ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const AlertDrag(),
            title,
          ],
        )
        : title,
    );
  }
}