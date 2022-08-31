import 'package:counter_spell_new/core.dart';
import 'highlights.dart';

class AppTutorial {
  
  static const tutorial = TutorialData(
    icon: McIcons.material_design,
    title: "App structure",
    hints: [
      panel,
      menuIcon,
      dialogs,
    ],
  );


  static const panel = Hint(
    text: 'Scroll the bottom panel up to open the settings',
    page: null,
    autoHighlight: _showPanel,
    repeatAuto: 1,
    icon: HintIcon(McIcons.gesture_swipe_up),
  );
  static Future<void> _showPanel(CSBloc bloc) async {
    bloc.stage.panelController.onNextPanelClose(() {
      if(bloc.tutorial.currentHint == panel){
        bloc.tutorial.nextHint();
      }
    });
    await HintsHighlights.collapsed(bloc);
    await Future.delayed(const Duration(milliseconds: 800));
    await HintsHighlights.collapsed(bloc);
  }

  static const menuIcon = Hint(
    text: 'You can also use the button on the top-left corner of course!',
    page: null,
    autoHighlight: _skipOnNextClose,
    icon: HintIcon(Icons.menu),
  );
  static Future<void> _skipOnNextClose(CSBloc bloc) async {
    bloc.stage.panelController.onNextPanelClose(() {
      if(bloc.tutorial.currentHint == menuIcon){
        bloc.tutorial.nextHint();
      }
    });
  }

  static const dialogs = Hint(
    text: 'Dialogs can be scrolled down to close them',
    page: null,
    manualHighlight: HintsHighlights.swipeDownExample,
    icon: HintIcon(McIcons.gesture_swipe_down),
  );

}
