import 'package:counter_spell_new/core.dart';
import 'components/all.dart'; 

class TutorialContent extends StatelessWidget {

  TutorialContent(this.pageController);

  final PageController? pageController;

  static const List<Widget> children = <Widget>[
    TutorialScroll(),
    TutorialSelection(),
    TutorialArena(),
    TutorialUI(),
    TutorialPages(),
    TutorialProFeatures(),
  ];
  static const List<String> titles = <String>[
    "Scroll gestures",
    "Multi-select",
    "Arena mode",
    "App UI",
    "Pages",
    "Pro features",
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: children.length,
      controller: pageController,
      onPageChanged: (i) => Stage.of(context)!.panelController.alertController.savedStates[AdvancedTutorial.stateKey] = i,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, page)
        => Padding(
          padding: const EdgeInsets.all(8.0),
          child: children[page],
        ),
    );
  }
}