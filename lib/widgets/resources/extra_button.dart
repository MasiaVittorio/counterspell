import 'package:flutter/material.dart';
import 'package:stage/stage.dart';

import 'package:auto_size_text/auto_size_text.dart';


class ExtraButtons extends StatelessWidget {

  const ExtraButtons({
    @required this.children,
    this.margin = defaultMargin,
    this.separate = true,
    this.flexes,
  });

  final List<Widget> children;
  final EdgeInsets margin;
  final bool separate;
  final List<int> flexes;

  static const defaultMargin = const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 6.0);
  static const Widget divider = _ExtraButtonDivider();

  @override
  Widget build(BuildContext context) {
    final expanded = <Widget>[
      for(int i=0; i<children.length; ++i)
        Expanded(
          child: children[i],
          flex: flexes.checkIndex(i) ? flexes[i] : 1,
        ),
    ];
    return Padding(
      padding: margin ?? defaultMargin,
      child: Row(
        children: (separate ?? true) 
          ? expanded.separateWith(divider)
          : expanded,
      ),
    );
  }
}

class _ExtraButtonDivider extends StatelessWidget {
  const _ExtraButtonDivider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 1.0,
        height: 44.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
        ),
      ),
    );
  }
}



class ExtraButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final double iconSize;
  final EdgeInsets iconPadding;
  // if the button should not be large as its text but bound to its context, we will use autosize text
  final bool forceExternalSize;
  final bool filled;
  final Widget customIcon;
  final Color customCircleColor;
  final bool twoLines;

  const ExtraButton({
    @required this.icon,
    @required this.text,
    @required this.onTap,
    this.forceExternalSize = false,
    this.iconPadding = EdgeInsets.zero,
    this.iconSize,
    this.customIcon,
    this.filled = false,
    this.customCircleColor,
    this.twoLines = false,
  });

  static const double _iconDimension = 38.0;

  @override
  Widget build(BuildContext context) {
    final defaultSize = DefaultTextStyle.of(context).style.fontSize;

    final theme = Theme.of(context);

    return SubSection(
      <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
          child: Container(
            alignment: Alignment.center,
            height: _iconDimension,
            width: _iconDimension,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(filled ? 10 : 50),
              color: (filled ?? false) 
                ? null 
                : customCircleColor ?? theme.colorScheme.onSurface.withOpacity(0.1),
            ),
            child: Padding(
              padding: this.iconPadding,
              child: this.customIcon ?? Icon(icon, size: iconSize),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 3.0),
          child: Container(
            alignment: Alignment.center,
            height: twoLines ? 36 : 24,
            child: this.forceExternalSize 
              ? AutoSizeText(
                text,
                maxLines: 1,
                maxFontSize: defaultSize,
                minFontSize: defaultSize / 2,
                textAlign: TextAlign.center,
              )
              : Text(text, textAlign: TextAlign.center),
          ),
        ),
      ], 
      crossAxisAlignment: CrossAxisAlignment.center,
      onTap: onTap,
      margin: EdgeInsets.zero,
      color: filled,
    );
  }
}