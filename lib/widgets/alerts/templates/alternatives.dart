import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';
import 'package:stage/stage.dart';

class Alternative {
  final Color color;
  final String title;
  final VoidCallback action;
  final IconData icon;
  final bool autoClose;
  final bool completelyAutoClose;
  const Alternative({
    @required this.title,
    @required this.icon,
    @required this.action,
    this.autoClose = false,
    this.completelyAutoClose = false,
    this.color,
  }): assert(action!=null),
      assert(title!=null),
      assert(icon!=null),
      assert(autoClose!=null),
      assert(completelyAutoClose!=null);
}

class AlternativesAlert extends StatelessWidget {

  final String label;

  final List<Alternative> alternatives;


  final bool twoLinesLabel;

  static const double tileSize = 56.0;
  static double heightCalc(int alts) => tileSize * alts + AlertTitle.height;
  static double twoLinesheightCalc(int alts) => tileSize * alts + AlertTitle.twoLinesHeight;

  AlternativesAlert({
    @required this.alternatives,
    @required this.label,
    this.twoLinesLabel = false,
  }):
    assert(label != null),
    assert(alternatives != null),
    assert(alternatives.isNotEmpty),
    assert(twoLinesLabel != null);

  @override
  Widget build(BuildContext context) {

    return IconTheme(
      data: IconThemeData(opacity: 1.0, color: Theme.of(context).colorScheme.onSurface),
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            AlertTitle(this.label, twoLines: this.twoLinesLabel ?? false,),

            for(final alt in this.alternatives)
              ListTile(
                onTap: (){
                  final stage = Stage.of(context);
                  if(alt.completelyAutoClose){
                    stage.panelController.closePanelCompletely();
                  } else if(alt.autoClose){
                    stage.panelController.closePanel();
                  }
                  alt.action();
                },
                leading: Icon(
                  alt.icon,
                  color: alt.color,
                ),
                title: Text(
                  alt.title,
                  style: TextStyle(color: alt.color),
                ),
              ),

          ],
        ),
      ),
    );
  }

}