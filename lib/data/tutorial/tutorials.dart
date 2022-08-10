import 'package:counter_spell_new/core.dart';


class TutorialData {
  final IconData icon;
  final String title;
  final List<Hint> hints;

  const TutorialData({
    required this.icon,
    required this.title,
    required this.hints,
  });

  static const gestures = TutorialData(
    icon: Icons.gesture,
    title: "Gestures",
    hints: [
      Hints.swipe,
      Hints.delay,
      Hints.repeat,
      Hints.multiple,
      Hints.anti,
    ],
  );

  static const commanders = TutorialData(
    icon: CSIcons.damageOutlined,
    title: "Commanders",
    hints: [
      Hints.attacker,
      Hints.defender,
      Hints.split,
      Hints.changePartner,
      Hints.playerOptionsLongPress,
      Hints.playerOptionsCircle,
    ],
  );

  static const history = TutorialData(
    icon: CSIcons.historyFilled,
    title: "History",
    hints: [
      Hints.past,
      Hints.restartBottom,
      Hints.restartMenu,
    ],
  );

  static const counters = TutorialData(
    icon: CSIcons.counterOutlined,
    title: "Counters",
    hints: [
      Hints.pickCounter,
    ],
  );

  static const playgroup = TutorialData(
    icon: Icons.people_alt_outlined,
    title: "Playgroup",
    hints: [
      Hints.groupBottom,
      Hints.groupMenu,
    ],
  );

  static const arena = TutorialData(
    icon: CSIcons.counterSpell,
    title: "Arena mode",
    hints: [
      Hints.arenaBottom,
      Hints.arenaMenu,
    ],
  );

  static const List<TutorialData> values = <TutorialData>[
    gestures,
    commanders,
    history,
    counters,
    playgroup,
    arena,
 ];
}


class Hints {

  /// Gestures

  static const swipe = Hint(
    text: "Swipe horizontally to edit life with great precision",
    page: CSPage.life,
    autoHighlight: _player,
    icon: HintIcon(McIcons.gesture_swipe_horizontal),
  );
  static const delay = Hint(
    text: "The change is confirmed after a short delay",
    page: CSPage.life,
    autoHighlight: _emulateSwipe,
    repeatAuto: 1,
    icon: HintIcon(Icons.timelapse_rounded),
  );
  static const repeat = Hint(
    text: "You can swipe multiple times before a change is applied",
    page: CSPage.life,
    autoHighlight: _player,
    icon: HintIcon(Icons.timelapse_rounded),
  );
  static const multiple = Hint(
    text: "Tap on multiple players before swiping to edit them together",
    page: CSPage.life,
    autoHighlight: _bothPlayers,
    icon: HintIcon(McIcons.gesture_double_tap),
  );
  static const anti = Hint(
    text: "Long press on a small check-box to invert a player's increment compared to the others",
    page: CSPage.life,
    autoHighlight: _checkbox,
    icon: HintIcon(McIcons.gesture_tap_hold),
  );


  /// Commanders

  static const attacker = Hint(
    text: "Start by selecting the attacking player",
    page: CSPage.commanderDamage,
    autoHighlight: _player,
    icon: HintIcon(McIcons.gesture_tap),
  );
  static const defender = Hint(
    text: "Swipe right on the defending player to deal damage",
    page: CSPage.commanderDamage,
    getCustomColor: _defenceColor,
    autoHighlight: _secondPlayer,
    icon: HintIcon(McIcons.gesture_swipe_right),
  );
  static Color _defenceColor(CSBloc logic) => logic.themer.defenceColor.value;
  static const split = Hint(
    text: 'Long-press on "person" icon to split in partners',
    page: CSPage.commanderCast,
    autoHighlight: _checkbox,
    icon: HintIcon(McIcons.gesture_tap_hold),
  );
  static const changePartner = Hint(
    text: 'Tap on "double-person" icon to select partner A or B',
    page: CSPage.commanderCast,
    autoHighlight: _checkbox,
    icon: HintIcon(McIcons.gesture_tap),
  );
  static const playerOptionsLongPress = Hint(
    text: "Long press on a player to open their settings",
    page: null,
    autoHighlight: _player,
    icon: HintIcon(McIcons.gesture_tap_hold),
  );
  static const playerOptionsCircle = Hint(
    text: "(Also tapping on the number circle will do!)",
    page: null,
    autoHighlight: _circleNumber,
    icon: HintIcon(McIcons.gesture_tap),
  );


  /// History 

  static const past = Hint(
    text: 'The History page will show and manage any past edit',
    page: CSPage.history,
    icon: HintIcon(CSIcons.historyFilled),
    autoHighlight: _backForth,
  );
  static const restartBottom = Hint(
    text: 'Restart the game via the bottom panel',
    page: CSPage.history,
    autoHighlight: _rightButton,
    icon: HintIcon(McIcons.restart),
  );
  static const restartMenu = Hint(
    text: 'Restart the game by sliding up the panel to open the menu',
    page: null,
    manualHighlight: _restartExtended,
    icon: HintIcon(McIcons.gesture_swipe_up),
  );


  /// Counters

  static const pickCounter = Hint(
    text: 'Choose which counter type to track via the bottom panel',
    page: CSPage.counters,
    autoHighlight: _rightButton,
    icon: HintIcon(CSIcons.poison),
  );


  /// Playgroup
  
  static const groupBottom = Hint(
    text: 'Edit the playgroup via the bottom panel',
    page: CSPage.life,
    autoHighlight: _rightButton,
    icon: HintIcon(McIcons.account_multiple_outline),
  );
  static const groupMenu = Hint(
    text: 'Edit the playgroup from the menu',
    page: null,
    manualHighlight: _playGroupExtended,
    icon: HintIcon(McIcons.gesture_swipe_up),
  );


  /// Playgroup

  static const arenaBottom = Hint(
    text: 'Open the full-screen "Arena" mode via the bottom panel',
    page: CSPage.life,
    autoHighlight: _leftButton,
    icon: HintIcon(CSIcons.counterSpell),
  );

  static const arenaMenu = Hint(
    text: 'Open Arena mode from the menu',
    page: null,
    manualHighlight: _arenaExtended,
    icon: HintIcon(McIcons.gesture_swipe_up),
  );

}


Future<void> _backForth(CSBloc bloc) async {
  bloc.tutorial.backForthHighlight.launch();
}
// Future<void> _collapsed(CSBloc bloc) async {
//   bloc.tutorial.entireCollapsedPanel.launch();
// }
Future<void> _emulateSwipe(CSBloc bloc) async {
  await Future.delayed(const Duration(milliseconds: 700));
  bloc.tutorial.entireCollapsedPanel.launch();
  await Future.delayed(const Duration(milliseconds: 800));
  bloc.scroller.editVal(6);
}
Future<void> _player(CSBloc bloc) async {
  await bloc.tutorial.playerHighlight.launch();
}
Future<void> _secondPlayer(CSBloc bloc) async {
  await bloc.tutorial.secondPlayerHighlight.launch();
}
Future<void> _bothPlayers(CSBloc bloc) async {
  bloc.tutorial.playerHighlight.launch();
  await Future.delayed(const Duration(milliseconds: 300));
  await bloc.tutorial.secondPlayerHighlight.launch();
}
Future<void> _checkbox(CSBloc bloc) async {
  await bloc.tutorial.checkboxHighlight.launch();
}
Future<void> _circleNumber(CSBloc bloc) async {
  await bloc.tutorial.numberCircleHighlight.launch();
}
Future<void> _rightButton(CSBloc bloc) async {
  await bloc.tutorial.collapsedRightButtonHighlight.launch();
}
Future<void> _leftButton(CSBloc bloc) async {
  await bloc.tutorial.collapsedLeftButtonHighlight.launch();
}
Future<void> _arenaExtended(CSBloc bloc) async {
  bloc.stage.openPanel();
  bloc.stage.panelPagesController!.goToPage(SettingsPage.game);
  await Future.delayed(const Duration(milliseconds: 500));
  await bloc.tutorial.panelArenaPlaygroupHighlight.launch();
}
Future<void> _playGroupExtended(CSBloc bloc) async {
  bloc.stage.openPanel();
  bloc.stage.panelPagesController!.goToPage(SettingsPage.game);
  await Future.delayed(const Duration(milliseconds: 500));
  await bloc.tutorial.panelEditPlaygroupHighlight.launch();
}
Future<void> _restartExtended(CSBloc bloc) async {
  bloc.stage.openPanel();
  bloc.stage.panelPagesController!.goToPage(SettingsPage.game);
  await Future.delayed(const Duration(milliseconds: 500));
  bloc.tutorial.panelRestartHighlight.launch();
}
