import 'package:counter_spell_new/core.dart';


class TutorialData {
  final IconData icon;
  final String title;
  final List<Hint> hints;

  const TutorialData({
    @required this.icon,
    @required this.title,
    @required this.hints,
  });

  static const List<TutorialData> values = <TutorialData>[
    // TutorialData(
    //   icon: ,
    //   title: ,
    //   hints: [
    //     Hint(
    //       text: ,
    //       page: CSPage.,
    //     ),
    //   ],
    // ),
    TutorialData(
      icon: Icons.gesture,
      title: "Gestures",
      hints: [
        Hint(
          text: "Swipe horizontally to edit life",
          page: CSPage.life,
        ),
        Hint(
          text: "The change is applied after a delay",
          page: CSPage.life,
        ),
        Hint(
          text: "You can swipe multiple times before a change is applied",
          page: CSPage.life,
        ),
        Hint(
          text: "Tap on multiple players before swiping to edit them together",
          page: CSPage.life,
        ),
        Hint(
          text: "Long press on a small check-box to anti-select a player",
          page: CSPage.life,
        ),
      ],
    ),
    TutorialData(
      icon: CSIcons.damageOutlined,
      title: "Commanders",
      hints: [
        Hint(
          text: "Tap on attacking player to start",
          page: CSPage.commanderDamage,
        ),
        Hint(
          text: "Scroll on defending player to deal damage",
          page: CSPage.commanderDamage,
        ),
        Hint(
          text: 'Long-press on "person" icon to split in partners',
          page: CSPage.commanderCast,
        ),
        Hint(
          text: 'Tap on "double-person" icon to select partner A or B',
          page: CSPage.commanderCast,
        ),
        Hint(
          text: "Long press on a player to open their settings",
          page: CSPage.life,
        ),
        Hint(
          text: "(Also tapping on the number circle will do!)",
          page: CSPage.life,
        ),
      ],
    ),
    TutorialData(
      icon: CSIcons.historyFilled,
      title: "History",
      hints: [
        Hint(
          text: 'The History page will show and manage any past edit',
          page: CSPage.history,
        ),
        Hint(
          text: 'Restarting the game',
          page: CSPage.history,
          collapsedIcon: McIcons.restart,
          collapsedRightSide: true,
        ),
        Hint(
          text: 'Restarting the game',
          page: null,
          panelPage: SettingsPage.game,
        ),
      ],
    ),
    TutorialData(
      icon: CSIcons.counterOutlined,
      title: "Counters",
      hints: [
        Hint(
          text: 'Picking counters',
          page: CSPage.counters,
          collapsedIcon: CSIcons.poison,
          collapsedRightSide: true,
        ),
      ],
    ),
    TutorialData(
      icon: Icons.people_alt_outlined,
      title: "Playgroup",
      hints: [
        Hint(
          text: 'Editing the playgroup',
          page: CSPage.life,
          collapsedIcon: Icons.people_alt_outlined,
          collapsedRightSide: true,
        ),
        Hint(
          text: 'Editing the playgroup',
          page: null,
          panelPage: SettingsPage.game,
        ),
      ],
    ),
    TutorialData(
      icon: CSIcons.counterSpell,
      title: "Arena mode",
      hints: [
        Hint(
          text: 'Opening full-screen "Arena" mode',
          page: null,
          collapsedIcon: CSIcons.counterSpell,
          collapsedRightSide: false,
        ),
        Hint(
          text: 'Opening full-screen "Arena" mode',
          page: null,
          panelPage: SettingsPage.game,
        ),
      ],
    ),
 ];
}

class Hint {
  final String text;
  final CSPage page;
  final SettingsPage panelPage;
  final bool collapsedRightSide; 
  final IconData collapsedIcon;

  const Hint({
    @required this.text,
    @required this.page,
    this.panelPage,
    this.collapsedIcon,
    this.collapsedRightSide,
  });

  bool get needsExtended => panelPage != null;
  bool get needsCollapsed => collapsedIcon != null;
  bool get needsAlert => needsCollapsed || needsExtended;
  bool get needsSnackBar => !needsAlert;

  String get shortPanelPageName => settingsThemes[panelPage]?.name ?? "";
  String get shortPageName => CSPages.shortTitleOf(page) ?? null;
}