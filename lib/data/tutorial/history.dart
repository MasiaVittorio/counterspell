import 'package:counter_spell_new/core.dart';
import 'highlights.dart';

class HistoryTutorial {
  
  static const tutorial = TutorialData(
    icon: CSIcons.historyFilled,
    title: "History",
    hints: [
      past,
      restartBottom,
      restartMenu,
    ],
  );


  static const past = Hint(
    text: 'The History page will show and manage any past edit',
    page: CSPage.history,
    icon: HintIcon(CSIcons.historyFilled),
    autoHighlight: HintsHighlights.backForth,
    repeatAuto: 1,
  );

  static const restartBottom = Hint(
    text: 'Restart the game via the bottom panel',
    page: CSPage.history,
    autoHighlight: HintsHighlights.rightButton,
    repeatAuto: 1,
    icon: HintIcon(McIcons.restart),
  );

  static const restartMenu = Hint(
    text: 'Restart the game by sliding up the panel to open the menu',
    page: null,
    manualHighlight: HintsHighlights.restartExtended,
    icon: HintIcon(McIcons.gesture_swipe_up),
  );

}
