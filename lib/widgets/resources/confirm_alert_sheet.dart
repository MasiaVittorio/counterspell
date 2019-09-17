import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:flutter/material.dart';

const IconData _kCancelIcon = McIcons.close_circle_outline;
const IconData _kConfirmIcon = Icons.check;

class ConfirmSheet extends StatelessWidget {

  final String warningText;

  final VoidCallback action;

  final String confirmText;
  final IconData confirmIcon;
  final Color confirmColor;

  final String cancelText;
  final IconData cancelIcon;
  final Color cancelColor;

  final double bottomPadding;

  final bool autoPop;

  ConfirmSheet({
    @required this.action,
    String warningText,
    String confirmText,
    IconData confirmIcon,
    this.confirmColor, //defaults to the text color provided by the context
    String cancelText,
    IconData cancelIcon,
    this.cancelColor, //defaults to the text color provided by the context
    this.bottomPadding = 0,
    this.autoPop = true,
  }):
    this.cancelText = cancelText ?? "Cancel",
    this.confirmText = confirmText ?? "Confirm",
    this.confirmIcon = confirmIcon ??  _kConfirmIcon,
    this.cancelIcon = cancelIcon ??  _kCancelIcon,
    this.warningText = warningText ?? "Are you sure? This action may not be reversible.";

  @override
  Widget build(BuildContext context) {

    final Color _confirmColor = this.confirmColor 
      ?? Theme.of(context)?.textTheme?.body1?.color;
    final Color _cancelColor = this.cancelColor 
      ?? Theme.of(context)?.textTheme?.body1?.color;

    return Material(
      child: Padding(
        padding: EdgeInsets.only(bottom: this.bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Text(this.warningText),
            ),

            ListTile(
              onTap: (){
                if(this.autoPop)
                  Navigator.pop(context);
                this.action();
              },
              leading: Icon(
                this.confirmIcon ?? _kConfirmIcon,
                color: _confirmColor,
              ),
              title: Text(
                this.confirmText,
                style: TextStyle(color: _confirmColor),
              ),
            ),

            ListTile(
              onTap: () => Navigator.pop(context),
              leading: Icon(
                this.cancelIcon ?? _kCancelIcon,
                color: _cancelColor,
              ),
              title: Text(
                this.cancelText,
                style: TextStyle(color: _cancelColor),
              ),
            ),

          ],
        ),
      ),
    );
  }

}