import 'package:counter_spell/core.dart';

import 'highlights.dart';

class PlaygroupTutorial {
  static const tutorial = TutorialData(
    icon: Icons.people_alt_outlined,
    title: "Playgroup",
    hints: [
      groupBottom,
      groupMenu,
    ],
  );

  static const groupBottom = Hint(
    text: 'Edit the playgroup via the bottom panel',
    page: CSPage.life,
    autoHighlight: HintsHighlights.rightButton,
    repeatAuto: 1,
    icon: HintIcon(McIcons.account_multiple_outline),
  );
  static const groupMenu = Hint(
    text: 'Edit the playgroup from the menu',
    page: null,
    manualHighlight: HintsHighlights.playGroupExtended,
    icon: HintIcon(McIcons.gesture_swipe_up),
  );
}
