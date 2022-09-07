import 'package:counter_spell_new/core.dart';
import 'highlights.dart';

class CommanderTutorial {
  
  static const tutorial = TutorialData(
    icon: CSIcons.damageOutlined,
    title: "Commanders",
    hints: [
      attacker,
      defender,
      split,
      changePartner,
      playerOptionsLongPress,
      playerOptionsCircle,
    ],
  );


  static const attacker = Hint(
    text: "Start by selecting the attacking player",
    page: CSPage.commanderDamage,
    autoHighlight: HintsHighlights.player,
    icon: HintIcon(McIcons.gesture_tap),
  );

  static const defender = Hint(
    text: "Swipe right on the defending player to deal damage",
    page: CSPage.commanderDamage,
    getCustomColor: _defenceColor,
    autoHighlight: HintsHighlights.secondPlayer,
    icon: HintIcon(McIcons.gesture_swipe_right),
  );
  static Color _defenceColor(CSBloc logic) => logic.themer.resolveDefenceColor;

  static const split = Hint(
    text: 'Long-press on "person" icon to split in partners',
    page: CSPage.commanderCast,
    autoHighlight: HintsHighlights.checkbox,
    repeatAuto: 1,
    icon: HintIcon(McIcons.gesture_tap_hold),
  );

  static const changePartner = Hint(
    text: 'Tap on "double-person" icon to select partner A or B',
    page: CSPage.commanderCast,
    autoHighlight: HintsHighlights.checkbox,
    repeatAuto: 1,
    icon: HintIcon(McIcons.gesture_tap),
  );
  
  static const playerOptionsLongPress = Hint(
    text: "Long press on a player to open their settings",
    page: null,
    autoHighlight: HintsHighlights.player,
    icon: HintIcon(McIcons.gesture_tap_hold),
  );
  
  static const playerOptionsCircle = Hint(
    text: "(Also tapping on the number circle will do!)",
    page: null,
    autoHighlight: HintsHighlights.circleNumber,
    repeatAuto: 1,
    icon: HintIcon(McIcons.gesture_tap),
  );

}
