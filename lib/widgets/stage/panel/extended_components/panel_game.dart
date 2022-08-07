import 'package:counter_spell_new/core.dart';
import 'game_components/all.dart';


class PanelGame extends StatelessWidget {
  const PanelGame({super.key});

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: ArenaTransformer(
            backgroundColor: Theme.of(context).canvasColor.withOpacity(0),
            builder: (_, opener) => SingleChildScrollView(
              physics: stage!.panelController.panelScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const PanelTitle("Enabled Screens", centered: false),
                  const SubSection([
                    Space.vertical(10),
                    PagePie(),
                    Space.vertical(7),
                  ]),
                  const Space.vertical(8),
                  const StartingLifeTile(),
                  const Divider(height: 7,),
                  const Space.vertical(8),
                  PanelGameExtras(
                    opener, 
                    compact: constraints.maxHeight < 610,
                  ),
                  const Space.vertical(15),
                ],
              )
            ),
            closedRadiusSize: 0.0,
          ),
        );
      }
    );
  }
}