
import 'package:counter_spell_new/core.dart';
import 'info_components/all.dart';

class PanelInfo extends StatelessWidget {

  const PanelInfo();

  static const double quoteSize = 70;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;

    return ModalBottomList(
      bottom: const QuoteTile(), 
      bottomHeight: quoteSize,
      physics: stage.panelController.panelScrollPhysics(),
      children: const <Widget>[
        Useful(),
        Divider(height: 25,),
        Development(),
        // const AboutCounterSpell(),
        // const CounterSpellActions(),
      ],
    );
  }
}
