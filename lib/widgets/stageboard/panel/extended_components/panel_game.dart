import 'package:counter_spell_new/core.dart';
import 'game_components/all.dart';


class PanelGame extends StatelessWidget {
  const PanelGame();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return ArenaTransformer(
      builder: (_, opener) => SingleChildScrollView(
        physics: stage!.panelController.panelScrollPhysics(),
        child: Column(
          children: <Widget>[
            const Section([
              PanelTitle("Enabled Screens", centered: false),
              PagePie(),
            ]),
            const StartingLifeTile(),
            PanelGameExtras(opener),
          ],
        )
      ),
      closedRadiusSize: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}