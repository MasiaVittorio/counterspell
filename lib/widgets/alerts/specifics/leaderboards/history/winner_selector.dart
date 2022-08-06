import 'package:counter_spell_new/core.dart';

class WinnerSelector extends StatefulWidget {
  final Set<String> names;
  final String? initialSelected;
  final void Function(String?) onConfirm;
  final VoidCallback? onDontSave;
  final bool closeCompletely;

  const WinnerSelector(this.names, {
    this.initialSelected, 
    required this.onConfirm, 
    this.onDontSave,
    this.closeCompletely = false,
  });

  static const double _bottomPadding = 10.0;
  static double heightCalc(int lenght, [bool promptDontSave = false]) => PanelTitle.height + 56.0 * (lenght + 1 + ((promptDontSave) ? 1 : 0)) + _bottomPadding;

  @override
  State createState() => _WinnerSelectorState();
}

class _WinnerSelectorState extends State<WinnerSelector> {

  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bool autoSavingPrompt = widget.onDontSave != null;

    final Widget row = Row(children: <Widget>[
      Expanded(child: ListTile(
        title: Text(autoSavingPrompt ? "Don't choose" : "Cancel"),
        leading: const Icon(Icons.close),
        onTap: (){
          if(widget.closeCompletely){
            stage!.closePanelCompletely();
          } else {
            stage!.closePanel();
          }
        }
      )),
      Expanded(child: ListTile(
        title: const Text("Confirm"),
        leading: const Icon(Icons.check),
        onTap: (){
          widget.onConfirm(selected);
          if(widget.closeCompletely){
            stage!.closePanelCompletely();
          } else {
            stage!.closePanel();
          }
        },
      )),
    ],);

    return HeaderedAlert(
      "Who won this game?",
      canvasBackground: true,
      bottom: autoSavingPrompt 
        ? Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            row,
            ListTile(
              leading: CSWidgets.deleteIcon,
              title: const Text("Don't save"),
              onTap: (){
                widget.onDontSave!();
                if(widget.closeCompletely){
                  stage!.closePanelCompletely();
                } else {
                  stage!.closePanel();
                }
              },
            ),
          ],
        )
        : row,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:<Widget>[
            for(final name in widget.names)
              SidRadioListTile<String?>(
                value: name,
                groupValue: selected,
                onChanged: (name) => setState((){
                  if(selected == name) {
                    selected = null;
                  } else {
                    selected = name;
                  }
                }),
                title: Text(name),
              ),
            const SizedBox(height: WinnerSelector._bottomPadding,)
          ],
        ),
      ),
    );
  }
}