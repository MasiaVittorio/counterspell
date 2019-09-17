import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/blocs/sub_blocs/themer.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:counter_spell_new/widgets/constants.dart';
import 'package:counter_spell_new/widgets/scaffold/components/panel/delayer.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

class CSPanelCollapsed extends StatelessWidget {
  const CSPanelCollapsed({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final gameStateBloc = bloc.game.gameState;
    return bloc.themer.themeSet.build((context, theme){
      

      final Widget backButton = gameStateBloc.gameState.build( (context, state)
        => _panelButton(gameStateBloc.backable, Icons.undo, gameStateBloc.back),
      );

      final Widget forwardButton = gameStateBloc.futureActions.build( (context, futures)
        => _panelButton(gameStateBloc.forwardable, Icons.redo, gameStateBloc.forward),
      );

      /// missing: simple displayer

      final Widget backForward = Row(children: <Widget>[
        const Spacer(),
        backButton, 
        forwardButton,
        const Spacer(),
      ]);

      /// missing: restarter

      return Material(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              left: 0.0,
              top: 0.0,
              right: 0.0,
              height: CSConstants.barSize,
              child: backForward
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              right: 0.0,
              height: CSConstants.barSize * 2,
              child: _DelayerPanel(theme: theme, bloc: bloc,),
            ),
          ]
        )
      );
    });
  }

  static Widget _panelButton(bool active, IconData icon, VoidCallback action)
    => AnimatedOpacity(
      duration: MyDurations.fast,
      opacity: active ? 1.0 : 0.35,
      child: InkResponse(
        child: Container(
          height: CSConstants.barSize,
          width: CSConstants.barSize * 1.6,
          child: Icon(
            icon,
            size: 20.0,
          ),
        ),
        onTap: active ? action : null,
      )
    );
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
    final actionBloc = bloc.game.gameAction;
    final scroller = bloc.scroller;
    final themeData = theme.data;
    final canvas = themeData.colorScheme.surface;
    final canvasContrast = themeData.colorScheme.onSurface;

    return BlocVar.build5(
      scroller.isScrolling,
      scroller.intValue,
      bloc.scaffold.mainIndex,
      bloc.settings.confirmDelay,
      actionBloc.isCasting,
      distinct: true,
      builder: (
        BuildContext context, 
        bool scrolling,
        int increment,
        int mainIndex,
        Duration confirmDelay,
        bool casting,
      ){
        final page = bloc.scaffold.currentPage;
        final accentColor = Color.alphaBlend(
          CSThemer.getScreenColor(
            theme: theme,
            page: page,
            casting: casting,
            open: false,
          ).withOpacity(0.8), 
          canvas,
        );
        return AnimatedOpacity(
          duration: MyDurations.veryFast,
          curve: Curves.decelerate,
          opacity: scrolling ? 1.0 : 0.0,
          child: IgnorePointer(
            ignoring: scrolling ? false : true,
            child: Delayer(
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

              height: CSConstants.barSize * 2,
              duration: confirmDelay,
              circleOffset: 44, //Floating Action Button
            ),
          ),
        );
      }
    );  
  }
}
