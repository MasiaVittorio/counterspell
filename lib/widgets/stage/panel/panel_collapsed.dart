import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/arena_widget.dart';
import 'package:counter_spell_new/widgets/resources/highlightable/highlightable.dart';
import 'package:counter_spell_new/widgets/resources/highlightable/overlay_painter.dart';
import 'package:counter_spell_new/widgets/stage/panel/collapsed_components/delayer.dart';

import 'collapsed_components/circle_button.dart';

class CSPanelCollapsed extends StatelessWidget {
  const CSPanelCollapsed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final gameStateBloc = bloc.game.gameState;
    final StageData<CSPage, SettingsPage> stage = Stage.of(context) as StageData<CSPage, SettingsPage>;

    final Widget backButton = gameStateBloc.gameState.build(
      (context, state) => _PanelButton(
        gameStateBloc.backable,
        Icons.undo,
        gameStateBloc.back,
        1.3,
        iconSize: 20,
      ),
    );

    final Widget forwardButton = gameStateBloc.futureActions.build(
      (context, futures) => _PanelButton(
        gameStateBloc.forwardable,
        Icons.redo,
        gameStateBloc.forward,
        1.3,
        iconSize: 20,
      ),
    );

    return ArenaTransformer(
      backgroundColor: Theme.of(context).canvasColor.withOpacity(0),
      closedRadiusSize: stage.dimensionsController.dimensions.value.barSize/2,
      builder: (_, open) => StageBuild.offMainPage<CSPage>((_, currentPage) 
        => StageBuild.offMainColors((_, __, colors){

          final arenaDisplayer = gameStateBloc.gameState.build(
            (context, state) => _PanelButton(
              ArenaWidget.okNumbers.contains(state.players.length),
              CSIcons.counterSpell,
              open,
              1.0,
              // iconSize: 20,
            ),
          );

          final rightButton =  bloc.scroller.isScrolling.build(
            (context, scrolling) => CircleButton(
              externalCircles: 3,
              sizeIncrement: scrolling ? 0.0 : 0.5,
              color: colors![currentPage]!
                  .withOpacity(0.07),
              size: CSSizes.barSize,
              child: <CSPage,Widget>{
                CSPage.history: const Icon(McIcons.restart),
                CSPage.life: const Icon(McIcons.account_multiple_outline),
                CSPage.counters: bloc.game.gameAction.counterSet.build(
                  (context, counter) => Icon(counter.icon),
                ),
                CSPage.commanderCast: const Icon(Icons.info_outline),
                CSPage.commanderDamage: const Icon(Icons.info_outline),
              }[currentPage] ?? const SizedBox(width: CSSizes.barSize),
              onTap: () {
                if(currentPage == CSPage.history){
                  stage.showSnackBar(
                    const SnackRestart(),
                    rightAligned: true,
                  );
                  bloc.tutorial.reactToRestartSnackbarShown();
                } else if(currentPage == CSPage.life){
                  stage.showAlert(
                    PlayGroupEditor(
                      bloc,
                      fromClosedPanel: true,
                    ),
                    size: PlayGroupEditor.sizeCalc(
                      bloc.game.gameGroup.orderedNames.value.length
                    ),
                  );
                  stage.panelController.onNextPanelClose(
                    () => bloc.tutorial.reactToPlaygroupEditedFromBottom(),
                  );
                } else if (currentPage == CSPage.commanderCast){
                  stage.showAlert(const CastInfo(), size: CastInfo.height);
                } else if (currentPage == CSPage.commanderDamage){
                  stage.showAlert(const DamageInfo(), size: DamageInfo.height);
                } else if (currentPage == CSPage.counters){
                  stage.showSnackBar(
                    const SnackCounterSelector(),
                    rightAligned: true,
                    duration: null,
                  );
                } 
              }, 
            ),
          );

          final Widget leftButton = currentPage == CSPage.history
              ? _PanelButton(
                true,
                Icons.timeline,
                () => stage.showAlert(
                  const AnimatedLifeChart(),
                  size: AnimatedLifeChart.height,
                ),
                1.0,
              )
              : arenaDisplayer;

          final backAndForward = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              backButton,
              forwardButton,
            ],
          );
          
          final Widget row = Row(children: <Widget>[
            Highlightable(
              controller: bloc.tutorial.collapsedLeftButtonHighlight,
              showOverlay: true,
              borderRadius: 500,
              child: leftButton,
            ),
            const Spacer(),
            Highlightable(
              showOverlay: true,
              overlayShape: const OverlayShape(
                type: OverlayShapeType.rrect,
                radius: Radius.circular(500)
              ),
              controller: bloc.tutorial.backForthHighlight,
              borderRadius: 500,
              child: backAndForward,
            ),
            const Spacer(),
            Highlightable(
              controller: bloc.tutorial.collapsedRightButtonHighlight,
              showOverlay: true,
              borderRadius: 500,
              child: rightButton,
            ),
          ],);

          return Material(
            type: MaterialType.transparency,
            child: Highlightable(
              controller: bloc.tutorial.entireCollapsedPanel,
              borderRadius: 500,
              child: Stack(
                fit: StackFit.expand, 
                children: <Widget>[
                  Positioned(
                    left: 0.0,
                    top: 0.0,
                    right: 0.0,
                    height: CSSizes.barSize,
                    child: row,
                  ),
                  Positioned(
                    left: 0.0,
                    top: 0.0,
                    right: 0.0,
                    height: CSSizes.barSize,
                    child: _DelayerPanel(bloc: bloc),
                  ),
                ],
              ),
          )
          );
        },),
      ),
    );
  }
}

class _DelayerPanel extends StatelessWidget {

  const _DelayerPanel({
    required this.bloc,
  });

  final CSBloc bloc;

  @override
  Widget build(BuildContext context) {
    final scroller = bloc.scroller;
    final themeData = Theme.of(context);
    final canvas = themeData.canvasColor;
    final canvasContrast = themeData.colorScheme.onSurface;
    final stage = Stage.of(context)!;

    return BlocVar.build5<bool,int,Duration,Color,bool>(
        scroller.isScrolling,
        scroller.intValue,
        bloc.settings.scrollSettings.confirmDelay,
        stage.themeController.derived.currentPrimaryColor,
        bloc.themer.flatDesign,
        distinct: true, builder: (
      BuildContext context,
      bool scrolling,
      int increment,
      Duration confirmDelay,
      Color currentPrimaryColor,
      bool flat,
    ) {
      final accentColor = Color.alphaBlend(
        currentPrimaryColor.withOpacity(0.85),
        canvas,
      );
      return AnimatedOpacity(
        duration: CSAnimations.veryFast,
        curve: Curves.decelerate,
        opacity: scrolling? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: scrolling ? false : true,
          child: Delayer(
            half: false,
            message: increment>= 0 ? '+ $increment' : '- ${-increment}',

            delayerController: scroller.delayerController,
            animationListener: scroller.delayerAnimationListener,
            onManualCancel: scrolling ? scroller.cancel : null,
            onManualConfirm: scrolling ? scroller.forceComplete : null,

            primaryColor: flat
              ? bloc.themer.computePanelColor(0.0, themeData)
              : canvas,
            onPrimaryColor: canvasContrast,
            accentColor: accentColor,
            onAccentColor: themeData.colorScheme.onPrimary,
            style: themeData.primaryTextTheme.bodyMedium,

            height: CSSizes.barSize,
            duration: confirmDelay,
            circleOffset: CSSizes.barSize / 2, 
          ),
        ),
      );
    });
  }
}

class _PanelButton extends StatelessWidget {
  final bool active;
  final IconData icon;
  final VoidCallback action;
  final double factor;
  final double? iconSize;
  const _PanelButton(
    this.active,
    this.icon,
    this.action,
    this.factor, {
    Key? key,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: CSAnimations.fast,
      opacity: active ? 1.0 : 0.35,
      child: InkResponse(
        onTap: active ? action : null,
        child: SizedBox(
          height: CSSizes.barSize,
          width: CSSizes.barSize * factor,
          child: Icon(
            icon,
            size: iconSize ?? 24,
          ),
        ),
      ));
  }
}
