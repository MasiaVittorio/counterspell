import 'package:counter_spell_new/core.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialControls extends StatelessWidget {

  TutorialControls(this.controller);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      FlatButton(
        child: const Text("Back"),
        onPressed: () => controller.previousPage(
          duration: CSAnimations.fast, 
          curve: Curves.easeOut,
        ),
      ),
      Expanded(child: SmoothPageIndicator(
        controller: controller, 
        count: AdvancedTutorial.pages,
        effect: const ExpandingDotsEffect(),
      ),),
      SubSection(<Widget>[
        FlatButton(
          child: const Text("Next"),
          onPressed: () => controller.nextPage(
            duration: CSAnimations.fast, 
            curve: Curves.easeOut,
          ),
        ),
      ],),
    ],);
  }
}