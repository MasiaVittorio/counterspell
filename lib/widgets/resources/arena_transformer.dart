import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/arena_widget.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';

/// Transform the collapsed panel in the arena, fuck it
class ArenaTransformer extends StatelessWidget {

  const ArenaTransformer({
    required this.builder,
    required this.closedRadiusSize,
    this.backgroundColor,
  });

  final double closedRadiusSize;
  final Color? backgroundColor;

  final Widget Function(BuildContext context, VoidCallback opener) builder;

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final StageData<CSPage, SettingsPage> stage = Stage.of(context)!;
    final theme = Theme.of(context);

    return OpenContainer(
      closedColor: backgroundColor ?? theme.canvasColor,
      openColor: theme.scaffoldBackgroundColor,
      middleColor: theme.canvasColor,
      // intermediateColor: theme.canvasColor,
      openBuilder: (context, exitArena){
        final Widget child = ArenaWidget(logic: logic); 

        if (logic.settings.arenaSettings.fullScreen.value){
          return  MediaQuery.removePadding(
            context: context, 
            removeTop: true, 
            removeBottom: true, 
            removeLeft: true,
            removeRight: true,
            child: child,
          );
        } else {
          return child;
        }
      },
      closedElevation: 0.0,
      openElevation: 0.0,
      closedBuilder: (context, openArena) => builder(context, (){

        if(!ArenaWidget.okNumbers.contains(logic.game.gameState.gameState.value.players.length)){
          stage.showAlert(
            AlternativesAlert(
              twoLinesLabel: true,
              label: "You need to have a smaller playgroup to open Arena Mode",
              alternatives: [Alternative(
                title: "Got it",
                icon: Icons.check,
                action: () => stage.closePanel(), 
              )],
            ), 
            size: AlternativesAlert.twoLinesheightCalc(1),
          );
          return;
        }
        
        logic.settings.appSettings.lastPageBeforeArena.set(stage.mainPagesController.currentPage);
        stage.mainPagesController.goToPage(CSPage.life);
        logic.game.gameAction.clearSelection();
        
        if(logic.themer.flatDesign.value){
          stage.showAlert(
            ArenaWidget(logic: logic, ),
            size: double.infinity,
          );
          stage.panelController.onNextPanelClose(
            () => logic.tutorial.reactToArenaAlertFromBottom(),
          );
        } else {
          if(logic.settings.arenaSettings.fullScreen.value){
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
          }

          openArena();
        }

      }),
      tappable: false,
      onClosed: (dynamic _) {
        stage.mainPagesController.goToPage(
          logic.settings.appSettings.lastPageBeforeArena.value,
        );
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual, 
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
        );
      },
      transitionType: ContainerTransitionType.fadeThrough,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(closedRadiusSize)
        ),
      ),
    );
  }
}
