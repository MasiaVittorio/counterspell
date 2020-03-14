import 'package:auto_size_text/auto_size_text.dart';

import 'subsection.dart';
import 'package:flutter/material.dart';

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

  ExtraButton({
    @required this.icon,
    @required this.text,
    @required this.onTap,
    this.forceExternalSize = false,
    this.iconPadding = EdgeInsets.zero,
    this.iconSize,
    this.customIcon,
    this.filled = false,
  });

  static const double _iconDimension = 38.0;

  @override
  Widget build(BuildContext context) {
    final defaultSize = DefaultTextStyle.of(context).style.fontSize;

    return SubSection(
      [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
          child: Container(
            alignment: Alignment.center,
            height: _iconDimension,
            width: _iconDimension,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: (filled ?? false) ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              // border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.051)),
              // color: Theme.of(context).canvasColor.withOpacity(0.5),
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
            height: 24,
            child: this.forceExternalSize 
              ? AutoSizeText(
                text,
                maxLines: 1,
                maxFontSize: defaultSize,
                minFontSize: defaultSize / 2,
              )
              : Text(text),
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