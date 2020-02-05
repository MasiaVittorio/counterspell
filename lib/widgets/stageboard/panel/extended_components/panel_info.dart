
import 'package:counter_spell_new/core.dart';
import 'info_components/all.dart';

class PanelInfo extends StatelessWidget {

  const PanelInfo();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const AboutCounterSpell(),
          const CounterSpellActions(),
          const QuoteTile(),
        ],
      ),
    );
  }
}