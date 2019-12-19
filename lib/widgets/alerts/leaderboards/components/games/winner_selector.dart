import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';

class WinnerSelector extends StatefulWidget {
  final Set<String> names;
  final String initialSelected;
  final void Function(String) onConfirm;

  const WinnerSelector(this.names, {this.initialSelected, @required this.onConfirm,});

  static double heightCalc(int lenght) => AlertTitle.height + 56.0 * (lenght + 1);

  @override
  _WinnerSelectorState createState() => _WinnerSelectorState();
}

class _WinnerSelectorState extends State<WinnerSelector> {

  String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return HeaderedAlert(
      "Who won this game?",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:<Widget>[
            for(final name in widget.names)
              SidRadioListTile<String>(
                value: name,
                groupValue: selected,
                onChanged: (name) => this.setState((){this.selected = name;}),
                title: Text(name),
              ),
          ],
        ),
      ),
      canvasBackground: true,
      bottom: Row(children: <Widget>[
        Expanded(child: ListTile(
          title: const Text("Cancel"),
          leading: const Icon(Icons.close),
          onTap: (){
            stage.panelController.closePanel();
          }
        )),
        Expanded(child: ListTile(
          title: const Text("Confirm"),
          leading: const Icon(Icons.check),
          onTap: (){
            widget.onConfirm(selected);
            stage.panelController.closePanel();
          }
        )),
      ],),
    );
  }
}