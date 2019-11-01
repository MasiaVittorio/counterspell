import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';
import 'package:stage/stage.dart';

const IconData _kCancelIcon = McIcons.close_circle_outline;
const IconData _kConfirmIcon = Icons.check;

class ConfirmStageAlert extends StatelessWidget {

  final String warningText;

  final VoidCallback action;

  final String confirmText;
  final IconData confirmIcon;
  final Color confirmColor;

  final String cancelText;
  final IconData cancelIcon;
  final Color cancelColor;

  final double bottomPadding;

  final bool autoCloseAfterConfirm;

  final bool completelyCloseAfterConfirm;

  static const double height = 56*2+AlertTitle.height;

  ConfirmStageAlert({
    @required this.action,
    String warningText,
    String confirmText,
    IconData confirmIcon,
    this.confirmColor, //defaults to the text color provided by the context
    String cancelText,
    IconData cancelIcon,
    this.cancelColor, //defaults to the text color provided by the context
    this.bottomPadding = 0,
    this.autoCloseAfterConfirm = true,
    this.completelyCloseAfterConfirm = false,
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

    return IconTheme(
      data: IconThemeData(opacity: 1.0),
      child: Material(
        child: Padding(
          padding: EdgeInsets.only(bottom: this.bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              AlertTitle(this.warningText),

              ListTile(
                onTap: (){
                  final stage = Stage.of(context);
                  if(this.completelyCloseAfterConfirm){
                    stage.panelController.closePanelCompletely();
                  } else if(this.autoCloseAfterConfirm){
                    stage.panelController.closePanel();
                  }
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
                onTap: () => Stage.of(context).panelController.closePanel(),
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
      ),
    );
  }

}