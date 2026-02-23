import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/tutorial/prompt.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CSSettingsApp {
  //====================================
  // Disposer
  void dispose() {
    wantVibrate.dispose();
    alwaysOnDisplay.dispose();
    lastPageBeforeArena.dispose();
    tutorialHinted.dispose();
    numberFontSizeFraction.dispose();
  }

  //====================================
  // Values
  final CSBloc parent;
  final PersistentVar<bool> wantVibrate;
  bool? canVibrate;
  final PersistentVar<bool> alwaysOnDisplay;
  final BlocVar<CSPage?> lastPageBeforeArena;
  final PersistentVar<bool> tutorialHinted;

  final PersistentVar<double> numberFontSizeFraction;

  //====================================
  // Constructor
  // Needs tutorial to hint
  CSSettingsApp(this.parent)
      : wantVibrate = PersistentVar<bool>(
          key: "bloc_settings_blocvar_wantvibrate",
          initVal: true,
          toJson: (b) => b,
          fromJson: (j) => j,
        ),
        numberFontSizeFraction = PersistentVar<double>(
          key: "bloc_settings_blocvar_numberFontSizeFraction",
          initVal: 0.27,
          toJson: (b) => b,
          fromJson: (j) => j,
        ),
        alwaysOnDisplay = PersistentVar<bool>(
          key: "bloc_settings_blocvar_alwaysOnDisplay",
          initVal: true,
          toJson: (b) => b,
          fromJson: (j) => j,
          onChanged: (bool b) => WakelockPlus.toggle(enable: b),
          readCallback: (bool b) => WakelockPlus.toggle(enable: b),
        ),
        tutorialHinted = PersistentVar<bool>(
            key: "bloc_settings_blocvar_tutorial_hinted",
            initVal: false,
            toJson: (b) => b,
            fromJson: (j) => j,
            readCallback: (alreadyShown) {
              if (!alreadyShown) {
                promptTutorial(parent);
              }
            }),
        lastPageBeforeArena = PersistentVar<CSPage?>(
          key: "bloc_settings_blocvar_lastPageBeforeSimpleScreen",
          initVal: CSPage.life,
          toJson: (page) => CSPages.nameOf(page),
          fromJson: (name) => CSPages.fromName(name),
        ) {
    Vibration.hasVibrator().then((hasIt) => canVibrate = hasIt);
  }

  static void hintAtTutorial(CSBloc parent, {int ms = 1700}) async {
    if (ms > 1) {
      await Future.delayed(Duration(milliseconds: ms));
    }
    await parent.stage.closePanelCompletely();
    parent.settings.appSettings.tutorialHinted.set(true);
    parent.stage.openPanel();
    await Future.delayed(const Duration(milliseconds: 500));
    parent.stage.panelPagesController!.goToPage(SettingsPage.info);
    await Future.delayed(const Duration(milliseconds: 500));
    parent.tutorial.tutorialHighlight.launch();
  }

  static void promptTutorial(CSBloc parent) async {
    await Future.delayed(const Duration(milliseconds: 1700));
    await parent.stage.closePanelCompletely();
    parent.settings.appSettings.tutorialHinted.set(true);
    parent.stage.showAlert(const TutorialPrompt(), size: TutorialPrompt.height);
  }
}
