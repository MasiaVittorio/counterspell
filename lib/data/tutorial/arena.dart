import 'package:counter_spell/core.dart';

import 'highlights.dart';

class ArenaTutorial {
  static const tutorial = TutorialData(
    icon: CSIcons.counterSpell,
    title: "Arena mode",
    hints: [
      arenaBottom,
      arenaMenu,
    ],
  );

  static const arenaBottom = Hint(
    text: 'Open the full-screen "Arena" mode via the bottom panel',
    page: CSPage.life,
    autoHighlight: HintsHighlights.leftButton,
    repeatAuto: 1,
    icon: HintIcon(CSIcons.counterSpell),
  );

  static const arenaMenu = Hint(
    text: 'Open Arena mode from the menu',
    page: null,
    manualHighlight: HintsHighlights.arenaExtended,
    icon: HintIcon(McIcons.gesture_swipe_up),
  );
}
