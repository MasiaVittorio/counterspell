import 'package:counter_spell_new/core.dart';

class CSTutorial {

  void dispose(){
    // TODO: dispose
  }

  final CSBloc parent;

  CSTutorial(this.parent); // Needs stage only to show, not to initialize

  ///=============================================
  /// Values =================================
  bool fullTutorial = false;
  int currentTutorialIndex;
  int currentHintIndex;


  ///=============================================
  /// Getters =================================
  TutorialData getTutorial(int index) => (
    TutorialData.values.checkIndex(index)
  )
    ? TutorialData.values[index]
    : null;

  TutorialData get currentTutorial => getTutorial(currentTutorialIndex);
  TutorialData get nextTutorial => getTutorial(currentTutorialIndex + 1);

  Hint getHint(int index) => (
    currentTutorial?.hints?.checkIndex(index)
    ?? false
  )
    ? currentTutorial.hints[index]
    : null;

  Hint get currentHint => getHint(currentHintIndex);
  Hint get nextHint => getHint(currentHintIndex + 1);

  ///=============================================
  /// Methods =================================

  /// Show =====================
  void showTutorial(int index, {bool full}) async {
    print("showing tutorial index: $index");
    await parent.stage.closePanelCompletely();
    fullTutorial = full ?? fullTutorial;
    print("full tutorial: $fullTutorial");
    currentTutorialIndex = index;
    if(currentTutorial?.hints?.isNotEmpty ?? false){
      showHint(0);
    } else {
      print("tutorial was empty!");
    }
  }

  void showHint(int index){
    print("showing hint index: $index");
    if(getHint(index) == null){
      quitTutorial();
      print("invalid hint index to be shown");
      return;
    }
    currentHintIndex = index;
    if(currentHint.needsAlert){
      showAlertHint(currentHint);
    } else if(currentHint.needsSnackBar){
      showSnackBarHint(currentHint);
    }
  }

  void showAlertHint(Hint hint) async {
    assert(hint.needsAlert);
    if(hint.page != null){
      parent.stage.mainPagesController.goToPage(hint.page);
    }
    parent.stage.showAlert(
      _HintAlert(hint),
      size: hint.needsCollapsed 
        ? 380
        : 450,
      replace: true,
    );
  }

  void showSnackBarHint(Hint hint){
    assert(hint.needsSnackBar);
    assert(hint.page != null);
    print("showing snackBar hint: ${hint.text}");
    print("(full tutorial: $fullTutorial)");
    parent.stage.mainPagesController.goToPage(hint.page);
    parent.stage.showSnackBar(
      StageSnackBar(
        title: StageBuild.offMainPage<CSPage>((_, page) 
          => AnimatedText(page == hint.page 
            ? hint.text
            : "Go to page ${CSPages.shortTitleOf(hint.page)} page",
            textAlign: TextAlign.center,
          ),
        ),
        secondary: StageSnackButton(
          onTap: skipHint, 
          child: Icon(Icons.keyboard_arrow_right),
        ),
      ),
      rightAligned: false,
      duration: null,
      pagePersistent: true,
      onManualClose: quitTutorial,
    );
  }


  /// Skip =====================
  void skipHint() async {
    print("skipping hint");
    if((currentTutorial == null) || (currentHintIndex == null)){
      quitTutorial();
      print("invlid current Tutorial or current hint index");
      return;
    }
    final int nextHintIndex = currentHintIndex + 1;
    print("next hint index would be: $nextHintIndex");
    // calculating this here becaaause quitHint would put it to null
    if(nextHint == null){
      if((fullTutorial == false) || (nextTutorial == null)){
        quitTutorial();
        return;
      } else {
        await quitCurrentHint();
        showTutorial(currentTutorialIndex + 1);
      }
    } else { // there is a next hint
      await quitCurrentHint();
      showHint(nextHintIndex);
    }
  }

  /// Quit =====================
  Future<void> quitTutorial() async {
    fullTutorial = false;
    await quitCurrentHint();
    currentTutorialIndex = null;
  }

  Future<void> quitCurrentHint() async {
    if(currentHint?.needsAlert ?? true){
      await parent.stage.closePanelCompletely();
    } 
    if(currentHint?.needsSnackBar ?? true){
      await parent.stage.closeSnackBar();
    }
    currentHintIndex = null;
  }

}


class _HintAlert extends StatelessWidget {

  const _HintAlert(this.hint);
  final Hint hint;

  @override
  Widget build(BuildContext context) {

    final logic = CSBloc.of(context);
    final tutorialLogic = logic.tutorial;

    return HeaderedAlert(
      hint.text,
      child: hint.needsCollapsed 
        ? _HintAlertCollapsed(hint)
        : hint.needsExtended 
          ? _HintAlertExtended(hint)
          : Container(),
      bottom: SubSection(
        [Row(children: <Widget>[for(final child in [
          CenteredTile(
            title: const Text("Quit tutorial"),
            subtitle: const Text("I'll figure it out"),
            leading: const Icon(Icons.close),
            onTap: tutorialLogic.quitTutorial,
          ),
          CenteredTile(
            title: const Text("Got it!"),
            subtitle: const Text("Next hint"),
            leading: const Icon(Icons.keyboard_arrow_right),
            onTap: tutorialLogic.skipHint,
          ),
        ]) Expanded(child: child)]
          .separateWith(CSWidgets.collapsedPanelDivider),
        )],
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}


class _HintAlertCollapsed extends StatelessWidget {
  
  final Hint hint;
  const _HintAlertCollapsed(this.hint);

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: collapsed panel hint
    );
  }
}



class _HintAlertExtended extends StatelessWidget {
  
  final Hint hint;
  const _HintAlertExtended(this.hint);

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: extended panel hint
    );
  }
}
