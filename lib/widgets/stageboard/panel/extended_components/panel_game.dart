import 'package:counter_spell_new/core.dart';
import 'game_components/all.dart';


class PanelGame extends StatelessWidget {
  const PanelGame();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          const Section([
            AlertTitle("Enabled Screens", centered: false),
            PagePie(),
          ]),
          const Section([
            SectionTitle("Game Settings"),
            StartingLifeTile(),
          ]),
          const Section([
            SectionTitle("Extras"),
            PanelGameExtras(),
          ]),
          const RestartTile(),
          const EditPlaygroupTile(),
        ],
      )
    );
  }
}