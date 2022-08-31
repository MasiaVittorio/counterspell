import 'package:counter_spell_new/core.dart';
import 'highlights.dart';

class CountersTutorial {
  
  static const tutorial = TutorialData(
    icon: CSIcons.counterOutlined,
    title: "Counters",
    hints: [
      pickCounter,
    ],
  );
  
  static const pickCounter = Hint(
    text: 'Choose which counter type to track via the bottom panel',
    page: CSPage.counters,
    autoHighlight: HintsHighlights.rightButton,
    repeatAuto: 1,
    icon: HintIcon(CSIcons.poison),
  );

}
