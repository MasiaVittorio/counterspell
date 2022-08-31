import 'package:counter_spell_new/core.dart';
import 'highlights.dart';

class GesturesTutorial {
  
  static const tutorial = TutorialData(
    icon: Icons.gesture,
    title: "Gestures",
    hints: [
      GesturesTutorial.swipe,
      GesturesTutorial.delay,
      GesturesTutorial.repeat,
      GesturesTutorial.multiple,
      GesturesTutorial.anti,
    ],
  );
  

  static const swipe = Hint(
    text: "Swipe horizontally to edit life with great precision",
    page: CSPage.life,
    autoHighlight: HintsHighlights.player,
    icon: HintIcon(McIcons.gesture_swipe_horizontal),
  );

  static const delay = Hint(
    text: "The change is confirmed after a short delay",
    page: CSPage.life,
    autoHighlight: HintsHighlights.emulateSwipe,
    repeatAuto: 1,
    icon: HintIcon(Icons.timelapse_rounded),
  );

  static const repeat = Hint(
    text: "You can swipe multiple times before a change is applied",
    page: CSPage.life,
    autoHighlight: HintsHighlights.player,
    icon: HintIcon(Icons.timelapse_rounded),
  );

  static const multiple = Hint(
    text: "Tap on multiple players before swiping to edit them together",
    page: CSPage.life,
    autoHighlight: HintsHighlights.bothPlayers,
    icon: HintIcon(McIcons.gesture_double_tap),
  );
  
  static const anti = Hint(
    text: "Long press on a small check-box to invert a player's increment compared to the others",
    page: CSPage.life,
    autoHighlight: HintsHighlights.checkbox,
    repeatAuto: 1,
    icon: HintIcon(McIcons.gesture_tap_hold),
  );

}
