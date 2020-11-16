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
      ],
    ),
    TutorialData(
      icon: Icons.check_box,
      title: "Multi-select",
      hints: [
        Hint(
          text: "Tap on different players before swiping to edit them together",
          page: CSPage.life,
        ),
        Hint(
          text: "Long press on a player to anti-select them",
          page: CSPage.life,
        ),
      ],
    ),
    TutorialData(
      icon: CSIcons.damageIconOutlined,
      title: "Commanders",
      hints: [
      ],
    ),
    TutorialData(
      icon: CSIcons.attackIconTwo,
      title: "Damage",
      hints: [
      ],
    ),
    TutorialData(
      icon: CSIcons.castIconOutlined,
      title: "Casts",
      hints: [
      ],
    ),
    TutorialData(
      icon: CSIcons.historyIconFilled,
      title: "History",
      hints: [
      ],
    ),
    TutorialData(
      icon: CSIcons.counterIconOutlined,
      title: "Counters",
      hints: [
      ],
    ),
    TutorialData(
      icon: Icons.people_alt_outlined,
      title: "Playgroup",
      hints: [
      ],
    ),
 ];
}

class Hint {
  final String text;
  final CSPage page;

  const Hint({
    @required this.text,
    @required this.page,
  });
}