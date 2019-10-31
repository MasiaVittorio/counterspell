import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';



String _theUnchecker(String s) => "";


class InsertAlert extends StatefulWidget {
  InsertAlert({
    @required this.onConfirm,
    this.hintText,
    this.labelText,
    this.inputType = TextInputType.text,
    this.checkErrors = _theUnchecker,
    this.maxLenght = 50,
    this.initialText,
    this.textCapitalization = TextCapitalization.words,
  });

  final String initialText;
  final String hintText;
  final String labelText;
  final void Function(String) onConfirm;
  final TextInputType inputType;
  final String Function(String) checkErrors;
  final int maxLenght;
  final TextCapitalization textCapitalization;

  static const double height = AlertTitle.height + _insert + _buttons;
  static const double _insert = 72.0;
  static const double _buttons = 56.0;

  @override
  _InsertAlertState createState() => _InsertAlertState();
}

class _InsertAlertState extends State<InsertAlert> {

  TextEditingController _controller;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    this._controller = TextEditingController(
      text: widget.initialText ?? "",
    );

  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String _errorString = _started == false 
      ? ""
      : this.widget.checkErrors(this._controller.text);
    
    final bool _valid = _errorString == "" || _errorString == null;
    final stage = Stage.of(context);

    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          AlertTitle(widget.labelText),

          Container(
            height: InsertAlert._insert,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              keyboardType: widget.inputType,
              autofocus: true,
              textAlign: TextAlign.center,
              maxLength: this.widget.maxLenght,
              controller: this._controller,
              textCapitalization: widget.textCapitalization ?? TextCapitalization.words,
              style: const TextStyle(inherit:true, fontSize: 18.0),
              onChanged: (String ts) => this.setState((){
                _started = true;
              }),
              decoration: InputDecoration(
                errorText: !_valid ? _errorString : null,
                hintText: this.widget.hintText,
              ),
            ),
          ),

          Container(
            height: InsertAlert._buttons,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text("Cancel"),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: stage.panelController.closePanel,
                  ),
                ),
                Expanded(
                  child: FlatButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Confirm"),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: _valid ? () {
                        this.widget.onConfirm(this._controller.text);
                        stage.panelController.closePanel();
                    } : null,
                  ),
                )
              ],
            )
          ),

        ],
      ),
    );
  }
}

