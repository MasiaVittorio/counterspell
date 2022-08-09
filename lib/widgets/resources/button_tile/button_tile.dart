import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stage/stage.dart';
import 'package:auto_size_text/auto_size_text.dart';


class ButtonTile extends StatelessWidget {

  const ButtonTile({
    required this.icon,
    required this.text,
    required this.onTap,
    this.onLongPress,
    this.shrinkWrap = false,
    this.iconPadding = EdgeInsets.zero,
    this.iconSize,
    this.customIcon,
    this.filled = false,
    this.circleColor,
    this.twoLines = false,
    this.iconOverflow = false,
  });

  const ButtonTile.transparent({
    required this.icon,
    required this.text,
    required this.onTap,
    this.onLongPress,
    this.shrinkWrap = false,
    this.iconPadding = EdgeInsets.zero,
    this.iconSize,
    this.customIcon,
    this.twoLines = false,
    this.iconOverflow = false,
  }): circleColor = Colors.transparent,
      filled = false;

  final Widget? customIcon;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsets iconPadding;

  final String text;
  final bool twoLines;

  final bool filled;
  final Color? circleColor;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// if the button should be large as its 
  /// text and not bound to its context (so no autosize text)
  final bool shrinkWrap;

  final bool iconOverflow;

  static const double _iconDimension = 38.0;

  @override
  Widget build(BuildContext context) {
    final defaultSize = DefaultTextStyle.of(context).style.fontSize ?? 16;
    final theme = Theme.of(context);

    final group = shrinkWrap 
      ? null 
      : context.dependOnInheritedWidgetOfExactType<_AutoSizeInherited>()?.group; 
    
    return SubSection(
      <Widget>[
        buildIcon(theme),
        buildLabel(defaultSize, group),
      ], 
      crossAxisAlignment: CrossAxisAlignment.center,
      onTap: onTap,
      onLongPress: onLongPress,
      margin: EdgeInsets.zero,
      color: filled,
    );
  }

  Padding buildLabel(double defaultSize, AutoSizeGroup? group) => Padding(
    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 3.0),
    child: Container(
      alignment: Alignment.center,
      height: twoLines ? 36 : 24,
      child: shrinkWrap 
        ? Text(text, textAlign: TextAlign.center)
        : AutoSizeText(
          text,
          maxLines: twoLines ? 2 : 1,
          maxFontSize: defaultSize,
          minFontSize: defaultSize / 2,
          textAlign: TextAlign.center,
          group: group,
        ),
    ),
  );

  Padding buildIcon(ThemeData theme) => Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
    child: Container(
      alignment: Alignment.center,
      height: max(_iconDimension, iconSize ?? 0),
      width: max(_iconDimension, iconSize ?? 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(filled ? 10 : 50),
        color: (filled) 
          ? null 
          : circleColor ?? theme.colorScheme.onSurface.withOpacity(0.1),
      ),
      child: Padding(
        padding: iconPadding,
        child: customIcon == null 
          ? Icon(icon, size: iconSize)
          : iconOverflow 
            ? Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  left: -_iconDimension,
                  top: -_iconDimension,
                  bottom: -_iconDimension,
                  right: -_iconDimension,
                  child: Center(child: customIcon),
                )
              ],)
            : customIcon,
      ),
    ),
  );
}



class ButtonTilesRow extends StatefulWidget {

  const ButtonTilesRow({
    required this.children,
    this.margin = defaultMargin,
    this.separate = true,
    this.flexes,
    this.sameAutoSizeGroup = true,
  });

  final List<Widget> children;
  final EdgeInsets margin;
  final bool separate;
  final List<int>? flexes;
  final bool sameAutoSizeGroup;

  static const defaultMargin = EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 6.0);
  static const Widget divider = ExtraButtonDivider();

  @override
  State<ButtonTilesRow> createState() => _ButtonTilesRowState();
  
}

class _ButtonTilesRowState extends State<ButtonTilesRow> {

  late AutoSizeGroup group;

  @override
  void initState() {
    super.initState();
    group = AutoSizeGroup();
  }
  
  @override
  Widget build(BuildContext context) {
    final expanded = <Widget>[
      for(int i=0; i<widget.children.length; ++i)
        Expanded(
          flex: (widget.flexes?.checkIndex(i) ?? false) ? widget.flexes![i] : 1,
          child: widget.children[i],
        ),
    ];

    final child = Padding(
      padding: widget.margin,
      child: Row(
        children: (widget.separate) 
          ? expanded.separateWith(ButtonTilesRow.divider)
          : expanded,
      ),
    );

    if(widget.sameAutoSizeGroup){
      return _AutoSizeInherited(
        group: group,
        child: child,
      );
    }
    return child;
  }
}

class ExtraButtonDivider extends StatelessWidget {
  
  const ExtraButtonDivider();

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





class _AutoSizeInherited extends InheritedWidget {
  const _AutoSizeInherited({
    required super.child,
    required this.group,
  });

  final AutoSizeGroup group;

  @override
  bool updateShouldNotify(_AutoSizeInherited oldWidget) => false;
}

