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

  bool get thereIsANext => (nextHint != null) ||
      (fullTutorial && (nextTutorial != null));


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
      size: _HintAlert.height(hint),
      replace: true,
    );
    parent.stage.panelController.onNextPanelClose(this._skipHint);
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
          onTap: _skipHint, 
          child: Icon(thereIsANext 
            ? Icons.keyboard_arrow_right
            : Icons.check
          ),
        ),
      ),
      rightAligned: false,
      duration: null,
      pagePersistent: true,
      onManualClose: quitTutorial,
    );
  }


  /// Skip =====================
  void _skipHint() async {
    print("skipping hint from tutorial Index: $currentTutorialIndex and hint Index: $currentHintIndex");

    if((currentTutorial == null) || (currentHintIndex == null)){
      quitTutorial();
      print("invlid current Tutorial or current hint index");
      return;
    }
    final int nextHintIndex = currentHintIndex + 1;
    print("next hint index would be: $nextHintIndex");
    // calculating this here becaaause quitHint would put it to null
    if(nextHint == null){
      print("next hint in this tutorial would be null, so");
      if((fullTutorial == false) || (nextTutorial == null)){
        print("because next tutorial would also be null, we quit");
        quitTutorial();
        return;
      } else {
        print("because there is a next tutorial, we quit the hint and start the new tutorial");
        await _quitCurrentHint();
        showTutorial(currentTutorialIndex + 1);
      }
    } else { // there is a next hint
      print("there is a next hint in this tutorial so we quit the current one");
      await _quitCurrentHint();
      print("now that the current is quit, we show the next ($nextHintIndex)");
      showHint(nextHintIndex);
    }
  }

  /// Quit =====================
  Future<void> quitTutorial() async {
    print("quitting current tutorial");
    fullTutorial = false;
    await _quitCurrentHint();
    currentTutorialIndex = null;
  }

  Future<void> _quitCurrentHint() async {
    print("quitting current hint");
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

  static double height(Hint hint) 
    => hint.needsCollapsed ? 450.0 : 600.0;
  
  double get size => height(this.hint);

  @override
  Widget build(BuildContext context) {

    final logic = CSBloc.of(context);
    final tutorialLogic = logic.tutorial;
    final bool next = tutorialLogic.thereIsANext;

    return HeaderedAlert(
      hint.text,
      alreadyScrollableChild: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: PanelTitle.height)
            + const EdgeInsets.all(16),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              removeTop: true,
              removeLeft: true,
              removeRight: true,
              child: Container(
                height: size - 162,
                color: Colors.yellow,
                child: hint.needsCollapsed 
                  ? HintAlertCollapsed(hint)
                  : hint.needsExtended 
                    ? HintAlertExtended(hint)
                    : Container(),
              ),
            ),
          ),
        ),
      ),
      bottom: SubSection(
        [Row(children: <Widget>[for(final child in [
          if(next)
          ...[CenteredTile(
            title: const Text("Quit tutorial"),
            subtitle: const Text("I'll figure it out"),
            leading: const Icon(Icons.close),
            onTap: tutorialLogic.quitTutorial,
          ),
          CenteredTile(
            title: const Text("Got it!"),
            subtitle: const Text("Next hint"),
            leading: const Icon(Icons.keyboard_arrow_right),
            onTap: Stage.of(context).closePanel,
          )]
          else CenteredTile(
            title: const Text("End of tutorial"),
            subtitle: const Text("Thank you!!"),
            leading: const Icon(Icons.check),
            onTap: Stage.of(context).closePanel,
          ),
        ]) Expanded(child: child)]
          .separateWith(CSWidgets.collapsedPanelDivider),
        )],
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}


