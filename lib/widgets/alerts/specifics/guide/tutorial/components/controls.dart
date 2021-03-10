import 'package:counter_spell_new/core.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'page_reactor.dart';

class TutorialControls extends StatelessWidget {

  TutorialControls(this.controller);

  final PageController controller;

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PageReactor(
            controller: controller,
            builder: (_, page) => TextButton(
              child: AnimatedText(page== 0 ? "" : "Back"),
              onPressed: page== 0 ? null : () => controller.previousPage(
                duration: CSAnimations.fast, 
                curve: Curves.easeOut,
              ),
            ),
          ),
          Expanded(child: Center(
            child: SmoothPageIndicator(
              controller: controller, 
              count: AdvancedTutorial.pages,
              effect: ExpandingDotsEffect(
                dotWidth: 12,
                dotHeight: 12,
                activeDotColor: theme.accentColor,
              ),
            ),
          ),),
          PageReactor(
            controller: controller,
            builder: (_, page) => TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty
                  .all<Color>(SubSection.getColor(theme)), 
              ),
              child: AnimatedText(page == AdvancedTutorial.pages -1 ? "Close" : "Next"),
              onPressed: () {
                if(page == AdvancedTutorial.pages - 1){
                  Stage.of(context).closePanel();
                } else {
                  controller.nextPage(
                    duration: CSAnimations.fast, 
                    curve: Curves.easeOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}