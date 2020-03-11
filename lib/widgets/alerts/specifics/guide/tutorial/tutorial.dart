// import 'components/all.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/guide/tutorial/components/page_reactor.dart';
import 'components/all.dart';


class AdvancedTutorial extends StatefulWidget {

  static int get pages => TutorialContent.children.length;

  static const double height = double.infinity;

  const AdvancedTutorial();

  @override
  _AdvancedTutorialState createState() => _AdvancedTutorialState();
}

class _AdvancedTutorialState extends State<AdvancedTutorial> {

  PageController pageController;

  @override
  void initState() {
    super.initState();
    this.pageController = PageController(
      viewportFraction: 0.9,
    );
  }

  @override
  void dispose() {
    this.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned.fill(
        top: AlertTitle.height,
        bottom: _bottomHeight,
        child: TutorialContent(pageController),
      ),
      Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: PageReactor(controller: pageController, builder: (_,page)
          => AlertTitle(TutorialContent.titles[page], animated: true),
        ),
      ),
      Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        height: _bottomHeight,
        child: Center(child: TutorialControls(pageController)),
      ),
    ],);
  }

  static const double _bottomHeight = 70;
}