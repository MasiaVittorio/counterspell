// import 'components/all.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/guide/tutorial/components/all.dart';


class AdvancedTutorial extends StatefulWidget {

  static int get pages => TutorialContent.children.length;

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
    return Column(children: <Widget>[
      const AlertTitle("Tutorial"),
      Expanded(child: TutorialContent(pageController)),
      CSWidgets.height5,
      CSWidgets.divider,
      CSWidgets.height5,
      TutorialControls(pageController,)
    ],);
  }
}