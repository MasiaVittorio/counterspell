


import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/data/tutorial/app.dart';

class HintsHighlights {

  static const beforeOverlay = Duration(milliseconds: 500);
  static Future<void> backForth(CSBloc bloc) async {
    await Future.delayed(beforeOverlay);
    await bloc.tutorial.backForthHighlight.launch();
  }

  static Future<void> collapsed(CSBloc bloc) async {
    await bloc.tutorial.entireCollapsedPanel.launch();
  }

  static Future<void> emulateSwipe(CSBloc bloc) async {
    await Future.delayed(const Duration(milliseconds: 700));
    bloc.tutorial.entireCollapsedPanel.launch();
    await Future.delayed(const Duration(milliseconds: 800));
    bloc.scroller.editVal(6);
  }

  static Future<void> player(CSBloc bloc) async {
    await bloc.tutorial.playerHighlight.launch();
  }

  static Future<void> secondPlayer(CSBloc bloc) async {
    await bloc.tutorial.secondPlayerHighlight.launch();
  }

  static Future<void> bothPlayers(CSBloc bloc) async {
    bloc.tutorial.playerHighlight.launch();
    await Future.delayed(const Duration(milliseconds: 300));
    await bloc.tutorial.secondPlayerHighlight.launch();
  }

  static Future<void> checkbox(CSBloc bloc) async {
    await bloc.tutorial.checkboxHighlight.launch();
  }

  static Future<void> circleNumber(CSBloc bloc) async {
    await Future.delayed(beforeOverlay);
    await bloc.tutorial.numberCircleHighlight.launch();
  }

  static Future<void> rightButton(CSBloc bloc) async {
    await Future.delayed(beforeOverlay);
    await bloc.tutorial.collapsedRightButtonHighlight.launch();
  }

  static Future<void> leftButton(CSBloc bloc) async {
    await Future.delayed(beforeOverlay);
    await bloc.tutorial.collapsedLeftButtonHighlight.launch();
  }

  static Future<void> arenaExtended(CSBloc bloc) async {
    bloc.stage.openPanel();
    bloc.stage.panelController.onNextPanelClose(
      () => bloc.tutorial.reactToArenaMenuShown(),
    );
    bloc.stage.panelPagesController!.goToPage(SettingsPage.game);
    await Future.delayed(const Duration(milliseconds: 500));
    await bloc.tutorial.panelArenaPlaygroupHighlight.launch();
  }

  static Future<void> playGroupExtended(CSBloc bloc) async {
    bloc.stage.openPanel();
    bloc.stage.panelController.onNextPanelClose(
      () => bloc.tutorial.reactToPlaygroupMenuShown(),
    );
    bloc.stage.panelPagesController!.goToPage(SettingsPage.game);
    await Future.delayed(const Duration(milliseconds: 500));
    await bloc.tutorial.panelEditPlaygroupHighlight.launch();
  }

  static Future<void> restartExtended(CSBloc bloc) async {
    bloc.stage.openPanel();
    bloc.stage.panelController.onNextPanelClose(
      () => bloc.tutorial.reactToRestartMenuShown(),
    );
    bloc.stage.panelPagesController!.goToPage(SettingsPage.game);
    await Future.delayed(const Duration(milliseconds: 500));
    bloc.tutorial.panelRestartHighlight.launch();
  }

  static Future<void> swipeDownExample(CSBloc bloc) async {
    bloc.stage.showAlert(const _SwipeDownExampleAlert(), size: 400);
    bloc.stage.panelController.onNextPanelClose(() {
      if(bloc.tutorial.currentHint == AppTutorial.dialogs){
        bloc.tutorial.nextHint();
      }
    });
  }

}

class _SwipeDownExampleAlert extends StatelessWidget {

  const _SwipeDownExampleAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Dialog example",
      alreadyScrollableChild: true, 
      customBackground: (theme) => theme.canvasColor,
      child: Column(children: const <Widget>[
        Space.vertical(PanelTitle.height + 10),
        SubSection([ListTile(title: Text(
          "Dialogs are shown in the same panel that you can otherwise scroll up to open the settings.",
        ),),]),
        Expanded(child: Center(
          child: ListTile(
            leading: Icon(McIcons.gesture_swipe_down),
            title: Text(
              "Try scrolling down to close this dialog!",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),),
      ],),
    );
  }

}