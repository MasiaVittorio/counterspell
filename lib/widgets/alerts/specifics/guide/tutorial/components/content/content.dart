import 'package:counter_spell_new/core.dart';
import 'components/all.dart'; 

class TutorialContent extends StatelessWidget {

  TutorialContent(this.pageController);

  final PageController pageController;

  static const List<Widget> children = <Widget>[
    TutorialScroll(),
    TutorialSelection(),
    // TutorialHistory(),
    // TutorialCommander(),
    TutorialUI(),
    TutorialProFeatures(),
  ];
  static const List<String> titles = <String>[
    "Scroll gestures",
    "Multi-select",
    // "Game history",
    // "Commander stats",
    "App UI",
    "Pro features",
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: children.length,
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, page)
        => Padding(
          padding: const EdgeInsets.all(8.0),
          child: children[page],
        ),
    );
  }
}