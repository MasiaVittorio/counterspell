
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/resources/highlightable/example_alert.dart';
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
        HighlightExample(),
      ],
    );
  }
}

class HighlightExample extends StatelessWidget {

  const HighlightExample({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Highlight"),
      onTap: () => Stage.of(context)!.showAlert(
        const HighlightAlert(),
        size: HighlightAlert.height,
      )
    );
  }
}