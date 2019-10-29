import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/ui_model/ui_model.dart';
import 'package:counter_spell_new/widgets/resources/alerts/alerts.dart';
import 'package:counter_spell_new/widgets/stageboard/panel/collapsed_components/delayer.dart';
import 'package:counter_spell_new/widgets/simple_view/simple_group_route.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';

class CSPanelCollapsed extends StatelessWidget {
  const CSPanelCollapsed({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final gameStateBloc = bloc.game.gameState;
    final stage = Stage.of(context);

    return BlocVar.build2(
      stage.pagesController.page, 
      bloc.themer.theme, 
      builder: (context, currentPage, csTheme){
        final Widget backButton = gameStateBloc.gameState.build( (context, state)
          => _PanelButton(gameStateBloc.backable, Icons.undo, gameStateBloc.back, 1.3, iconSize: 20,),
        );
        final Widget forwardButton = gameStateBloc.futureActions.build( (context, futures)
          => _PanelButton(gameStateBloc.forwardable, Icons.redo, gameStateBloc.forward, 1.3, iconSize: 20,),
        );
        final simpleDisplayer = gameStateBloc.gameState.build( (context, state)
          => _PanelButton(
            [2,3,4].contains(state.players.length), 
            simpleViewIcon,
            ()=> showSimpleGroup(context: context, bloc: bloc), 
            1.0,
            iconSize: 23,
          ),
        );

        final rightButton = <CSPage,Widget>{
          CSPage.history : _PanelButton(
            true,
            McIcons.restart,
            () => stage.showAlert(
              RestarterAlert(),
              alertSize: RestarterAlert.height,
            ),
            1.0,
            iconSize: 24,
          ),
          CSPage.life: gameStateBloc.gameState.build( (context, state)
            => _PanelButton(
              true, 
              McIcons.account_multiple_outline, 
              () => stage.showAlert(
                PlayGroupEditor(bloc),
                alertSize: PlayGroupEditor.sizeCalc(bloc.game.gameGroup.names.value.length),
              ),
              1.0,
              iconSize: 25,
            ),
          ),
          CSPage.commanderCast: _PanelButton(
            true,
            Icons.info_outline,
            () => stage.showAlert(const CastInfo(), alertSize: CastInfo.height),
            1.0,
          ),
          CSPage.commanderDamage: _PanelButton(
            true,
            Icons.info_outline,
            () => stage.showAlert(const DamageInfo(), alertSize: DamageInfo.height),
            1.0,
          ),
          CSPage.counters: bloc.game.gameAction.counterSet.build((context, counter)
            => _PanelButton(
              true,
              counter.icon,
              () => stage.showAlert(
                const CounterSelector(), 
                alertSize: 56.0 * (bloc.game.gameAction.counterSet.list.length.clamp(2, 9)),
              ),
              1.0, 
            ),
          ),
        }[currentPage] ?? SizedBox(width: CSConstants.barSize,);

        final Widget row = Row(children: <Widget>[
          simpleDisplayer,
          const Spacer(),
          backButton, 
          forwardButton,
          const Spacer(),
          rightButton,
        ]);

        /// missing: restarter

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                height: CSConstants.barSize,
                child: row
              ),
              Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                height: CSConstants.barSize,
                child: _DelayerPanel(theme: csTheme, bloc: bloc,),
              ),
            ]
          )
        );
      },
    );
  }


}


class _DelayerPanel extends StatelessWidget {
  _DelayerPanel({
    @required this.theme,
    @required this.bloc,
  });
  final CSBloc bloc;
  final CSTheme theme;

  @override
  Widget build(BuildContext context) {
    final scroller = bloc.scroller;
    final themeData = Theme.of(context);
    final canvas = themeData.colorScheme.surface;
    final canvasContrast = themeData.colorScheme.onSurface;
    final stage = Stage.of(context);
    
    return BlocVar.build4(
      scroller.isScrolling,
      scroller.intValue,
      bloc.settings.confirmDelay,
      stage.themeController.primaryColor,
      distinct: true,
      builder: (
        BuildContext context, 
        bool scrolling,
        int increment,
        Duration confirmDelay,
        Color currentPrimaryColor,
      ){
        final accentColor = Color.alphaBlend(
          currentPrimaryColor,
          canvas,
        );
        return AnimatedOpacity(
          duration: MyDurations.veryFast,
          curve: Curves.decelerate,
          opacity: scrolling ? 1.0 : 0.0,
          child: IgnorePointer(
            ignoring: scrolling ? false : true,
            child: Delayer(
              half: false,
              message: increment >= 0 ? '+ $increment' : '- ${- increment}',

              delayerController: scroller.delayerController,
              animationListener: scroller.delayerAnimationListener,
              onManualCancel: scrolling ? scroller.cancel : null,
              onManualConfirm: scrolling ? scroller.forceComplete : null,

              primaryColor: canvas,
              onPrimaryColor: canvasContrast,
              accentColor: accentColor,
              onAccentColor: themeData.colorScheme.onPrimary,
              style: themeData.primaryTextTheme.body1,

              height: CSConstants.barSize,
              duration: confirmDelay,
              circleOffset: 44, //Floating Action Button
            ),
          ),
        );
      }
    );  
  }
}


class _PanelButton extends StatelessWidget {
  final bool active; 
  final IconData icon; 
  final VoidCallback action;
  final double factor;
  final double iconSize;
  const _PanelButton(this.active, this.icon, this.action, this.factor, {
    Key key,
    this.iconSize,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: MyDurations.fast,
      opacity: active ? 1.0 : 0.35,
      child: InkResponse(
        child: Container(
          height: CSConstants.barSize,
          width: CSConstants.barSize * factor,
          child: Icon(
            icon,
            size: iconSize ?? 24,
          ),
        ),
        onTap: active ? action : null,
      )
    );
  }
}