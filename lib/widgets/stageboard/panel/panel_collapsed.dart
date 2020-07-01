import 'package:animations/animations.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/arena_widget.dart';
import 'package:counter_spell_new/widgets/stageboard/panel/collapsed_components/delayer.dart';
import 'package:flutter/services.dart';
import 'package:stage/stage.dart';

class CSPanelCollapsed extends StatelessWidget {
  const CSPanelCollapsed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final gameStateBloc = bloc.game.gameState;
    final StageData<CSPage, SettingsPage> stage = Stage.of(context);

    return  ArenaTransformer(
      closedRadiusSize: stage.dimensionsController.dimensions.value.barSize/2,
      builder: (_, opener) => StageBuild.offMainPage<CSPage>((_, currentPage) {

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

        final arenaDisplayer = gameStateBloc.gameState.build(
          (context, state) => _PanelButton(
            ArenaWidget.okNumbers.contains(state.players.length),
            CSIcons.simpleViewIcon,
            opener,
            1.0,
            iconSize: 20,
          ),
        );

        final rightButton = <CSPage, Widget>{
          CSPage.history: _PanelButton(
            true,
            McIcons.restart,
            () => stage.showSnackBar(
              const SnackRestart(),
              rightAligned: true,
            ),
            1.0,
            iconSize: 24,
          ),
          CSPage.life: gameStateBloc.gameState.build(
            (context, state) => _PanelButton(
              true,
              McIcons.account_multiple_outline,
              () => stage.showAlert(
                PlayGroupEditor(
                  bloc,
                  fromClosedPanel: true,
                ),
                size: PlayGroupEditor.sizeCalc(
                    bloc.game.gameGroup.names.value.length),
              ),
              1.0,
              iconSize: 25,
            ),
          ),
          CSPage.commanderCast: _PanelButton(
            true,
            Icons.info_outline,
            () => stage.showAlert(const CastInfo(), size: CastInfo.height),
            1.0,
          ),
          CSPage.commanderDamage: _PanelButton(
            true,
            Icons.info_outline,
            () => stage.showAlert(const DamageInfo(),
                size: DamageInfo.height),
            1.0,
          ),
          CSPage.counters: bloc.game.gameAction.counterSet.build(
            (context, counter) => _PanelButton(
              true,
              counter.icon,
              () => stage.showSnackBar(
                const SnackCounterSelector(),
                rightAligned: true,
                duration: null,
              ),
              1.0,
            ),
          ),
        }[currentPage] ?? const SizedBox(width: CSSizes.barSize);

        final Widget row = Row(children: <Widget>[
          currentPage == CSPage.history
            ? _PanelButton(
                true,
                Icons.timeline,
                () => stage.showAlert(
                  const AnimatedLifeChart(),
                  size: AnimatedLifeChart.height,
                ),
                1.0,
              )
            : arenaDisplayer,
          const Spacer(),
          backButton,
          forwardButton,
          const Spacer(),
          rightButton,
        ],);

        return Material(
          type: MaterialType.transparency,
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
        );
      },),
    );
  }
}

class _DelayerPanel extends StatelessWidget {

  _DelayerPanel({@required this.bloc});

  final CSBloc bloc;

  @override
  Widget build(BuildContext context) {
    final scroller = bloc.scroller;
    final themeData = Theme.of(context);
    final canvas = themeData.canvasColor;
    final canvasContrast = themeData.colorScheme.onSurface;
    final stage = Stage.of(context);

    return BlocVar.build4(
        scroller.isScrolling,
        scroller.intValue,
        bloc.settings.scrollSettings.confirmDelay,
        stage.themeController.derived.currentPrimaryColor,
        distinct: true, builder: (
      BuildContext context,
      bool scrolling,
      int increment,
      Duration confirmDelay,
      Color currentPrimaryColor,
    ) {
      final accentColor = Color.alphaBlend(
        currentPrimaryColor,
        canvas,
      );
      return AnimatedOpacity(
        duration: CSAnimations.veryFast,
        curve: Curves.decelerate,
        opacity: scrolling ? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: scrolling ? false : true,
          child: Delayer(
            half: false,
            message: increment >= 0 ? '+ $increment' : '- ${-increment}',

            delayerController: scroller.delayerController,
            animationListener: scroller.delayerAnimationListener,
            onManualCancel: scrolling ? scroller.cancel : null,
            onManualConfirm: scrolling ? scroller.forceComplete : null,

            primaryColor: canvas,
            onPrimaryColor: canvasContrast,
            accentColor: accentColor,
            onAccentColor: themeData.colorScheme.onPrimary,
            style: themeData.primaryTextTheme.bodyText2,

            height: CSSizes.barSize,
            duration: confirmDelay,
            circleOffset: 44, //Floating Action Button
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
  final double iconSize;
  const _PanelButton(
    this.active,
    this.icon,
    this.action,
    this.factor, {
    Key key,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        duration: CSAnimations.fast,
        opacity: active ? 1.0 : 0.35,
        child: InkResponse(
          child: Container(
            height: CSSizes.barSize,
            width: CSSizes.barSize * factor,
            child: Icon(
              icon,
              size: iconSize ?? 24,
            ),
          ),
          onTap: active ? action : null,
        ));
  }
}

/// Transform the collapsed panel in the arena, fuck it
class ArenaTransformer extends StatelessWidget {

  const ArenaTransformer({
    @required this.builder,
    @required this.closedRadiusSize,
    this.backgroundColor,
  });

  final double closedRadiusSize;
  final Color backgroundColor;

  final Widget Function(BuildContext context, VoidCallback opener) builder;

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final StageData<CSPage, SettingsPage> stage = Stage.of(context);
    final theme = Theme.of(context);

    return OpenContainer(
      closedColor: backgroundColor ?? theme.canvasColor,
      openColor: theme.scaffoldBackgroundColor,
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
          return null;
        }
        
        logic.settings.appSettings.lastPageBeforeArena.set(stage.mainPagesController.currentPage);
        stage.mainPagesController.goToPage(CSPage.life);
        logic.game.gameAction.clearSelection();

        if(logic.settings.arenaSettings.fullScreen.value){
          SystemChrome.setEnabledSystemUIOverlays([]);
        }

        openArena();
      }),
      tappable: false,
      onClosed: (_) {
        stage.mainPagesController.goToPage(
          logic.settings.appSettings.lastPageBeforeArena.value,
        );
        SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]
        );
      },
      transitionType: ContainerTransitionType.fade,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(this.closedRadiusSize)
        ),
      ),
    );
  }
}
