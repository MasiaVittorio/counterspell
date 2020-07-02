import 'package:counter_spell_new/core.dart';

class TutorialArena extends StatelessWidget {
  const TutorialArena();

  static const titles = [["Me", "Him"], ["You", "Her"]];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final CSBloc bloc = CSBloc.of(context);

    return Column(
      children: <Widget>[

        _Text("There is a streamlined, more traditional mode you can use."),

        Expanded(child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: Column(children: <Widget>[
                for(final n in [0,1]) 
                  Expanded(child: RotatedBox(
                    quarterTurns: n==0 ? 2 : 0,
                    child: Row(children: <Widget>[
                      for(final title in titles[n])
                        Expanded(child: SubSection(
                          <Widget>[
                            Expanded(child: Center(child: Text(title),)),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          margin: const EdgeInsets.all(8),
                        ),),
                    ],),
                  ),),
              ],),
            ),
            Center(child: FloatingActionButton(
              onPressed: (){},
              backgroundColor: theme.canvasColor,
              foregroundColor: theme.colorScheme.onSurface,
              child: Icon(CSIcons.counterSpell),
            ),),
          ],
        )),

        _Text("But most of the advanced capabilities are offered by the main mode."),

      ].separateWith(CSWidgets.height15),
    );
  }
}

class _Text extends StatelessWidget {

  const _Text(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
 
    return SubSection(<Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    ], margin: EdgeInsets.zero, crossAxisAlignment: CrossAxisAlignment.stretch);

    
  }
}