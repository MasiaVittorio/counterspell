import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:counter_spell_new/widgets/constants.dart';
import 'package:counter_spell_new/widgets/resources/alerts/confirm_alert_sheet.dart';
import 'package:counter_spell_new/widgets/resources/alerts/playgroup_editor/playgroup_editor.dart';
import 'package:counter_spell_new/widgets/stageboard/components/panel/delayer.dart';
import 'package:counter_spell_new/widgets/simple_view/simple_group_route.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage_board/stage_board.dart';

class CSPanelCollapsed extends StatelessWidget {
  const CSPanelCollapsed({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final gameStateBloc = bloc.game.gameState;
    final stageBoard = StageBoard.of(context);

    return bloc.themer.theme.build((context, theme){
      final Widget backButton = gameStateBloc.gameState.build( (context, state)
        => _PanelButton(gameStateBloc.backable, Icons.undo, gameStateBloc.back, 1.3, iconSize: 20,),
      );
      final Widget forwardButton = gameStateBloc.futureActions.build( (context, futures)
        => _PanelButton(gameStateBloc.forwardable, Icons.redo, gameStateBloc.forward, 1.3, iconSize: 20,),
      );
      final simpleDisplayer = gameStateBloc.gameState.build( (context, state)
        => _PanelButton(
          [2,3,4].contains(state.players.length), 
          McIcons.view_dashboard_outline,
          ()=> showSimpleGroup(context: context, bloc: bloc), 
          1.0,
          iconSize: 23,
        ),
      );

      final rightButton = <CSPage,Widget>{
        CSPage.life: gameStateBloc.gameState.build( (context, state)
          => _PanelButton(
            true, 
            McIcons.account_multiple_outline, 
            () => stageBoard.showAlert(
              PlayGroupEditor(bloc),
              alertSize: PlayGroupEditor.sizeCalc(bloc.game.gameGroup.names.value.length),
            ),
            1.0,
            iconSize: 25,
          ),
        ),
        CSPage.history : _PanelButton(
          true,
          McIcons.restart,
          () => stageBoard.showAlert(
            ConfirmStageAlert(
              action: bloc.game.gameState.restart,
              warningText: "This action cannot be undone.",
              confirmText: "Restart the game",
              confirmIcon: McIcons.restart,
              cancelColor: DELETE_COLOR,
            ),
            alertSize: 56*2+32.0,
          ),
          1.0,
          iconSize: 24,
        ),
      }[stageBoard.pagesController.page] ?? SizedBox(width: CSConstants.barSize,);

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
              child: _DelayerPanel(theme: theme, bloc: bloc,),
            ),
          ]
        )
      );
    });
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
    final stageBoard = StageBoard.of(context);
    
    return BlocVar.build3(
      scroller.isScrolling,
      scroller.intValue,
      bloc.settings.confirmDelay,
      distinct: true,
      builder: (
        BuildContext context, 
        bool scrolling,
        int increment,
        Duration confirmDelay,
      ){
        final accentColor = Color.alphaBlend(
          stageBoard.currentPrimaryColor,
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