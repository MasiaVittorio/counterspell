import 'dart:async';

import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/arena_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const Duration _kCarouselDuration = const Duration(milliseconds: 200);
const Color _kBarrier = Colors.black12;


class _ArenaRoute<T> extends PopupRoute<T> {
  _ArenaRoute({
    @required this.theme,
    @required this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final ThemeData theme;

  @override
  Duration get transitionDuration => _kCarouselDuration;

  @override
  bool get barrierDismissible => false;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => _kBarrier;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = AnimationController(
      vsync: navigator.overlay,
      debugLabel: 'simplecsdialog',
      duration: _kCarouselDuration,
    ); 
    return _animationController; 
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget page = _SimpleGroup(routeAnimationController: _animationController);
    if (theme != null){
      page = Theme(data: theme, child: page);
    }
    if (CSBloc.of(context).settings.arenaSettings.fullScreen.value){
      page = MediaQuery.removePadding(
        context: context, 
        removeTop: true, 
        removeBottom: true, 
        removeLeft: true,
        removeRight: true,
        child: page,
      );
    }
    return page;
  }
}

Future<T> showArena<T>({
  @required BuildContext context,
  @required CSBloc bloc,
}) {
  assert(context != null);

  final stage = Stage.of(context);
  if(!ArenaWidget.okNumbers.contains(bloc.game.gameState.gameState.value.players.length)){
    stage.showAlert(AlternativesAlert(
      twoLinesLabel: true,
      label: "You need to have a smaller playgroup to open Arena Mode",
      alternatives: [Alternative(
        title: "Got it",
        icon: Icons.check,
        action: () => stage.closePanel(), 
      )],
    ), size: AlternativesAlert.twoLinesheightCalc(1));
    return null;
  }
  
  bloc.settings.appSettings.lastPageBeforeArena.set(stage.mainPagesController.currentPage);
  stage.mainPagesController.goToPage(CSPage.life);
  bloc.game.gameAction.clearSelection();

  if(bloc.settings.arenaSettings.fullScreen.value){
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  return Navigator.push(context, _ArenaRoute<T>(
    theme: Theme.of(context, shadowThemeOnly: true),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  )).then<void>((_) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
  });
  
}

class _SimpleGroup extends StatelessWidget {

  _SimpleGroup({
    Key key,
    @required this.routeAnimationController,
  }): super(key: key);
  
  final AnimationController routeAnimationController;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final actionBloc = bloc.game.gameAction;
    final settings = bloc.settings;
    final stage = Stage.of(context);

    return BlocVar.build5(
      bloc.scroller.isScrolling,
      bloc.scroller.intValue,
      actionBloc.selected,
      bloc.game.gameState.gameState,
      stage.themeController.derived.mainPageToPrimaryColor,
      builder: (
        BuildContext context, 
        bool isScrolling, 
        int increment,
        Map<String,bool> selected, 
        GameState gameState,
        pageColors,
      ) {

        final normalizedPlayerActions = CSGameAction.normalizedAction(
          selectedValue: selected,
          gameState: gameState,
          scrollerValue: increment,

          pageValue: CSPage.life, // nulls are justified because 
          defender: null,         // it is always life page
          attacker: null,         //
          counter: null,          //

          //these two values are so rarely updated that all the actual
          //reactive variables make this rebuild so often that min and max
          //will basically always be correct. no need to add 2 streambuilders
          minValue: settings.gameSettings.minValue.value,
          maxValue: settings.gameSettings.maxValue.value,
        ).actions(gameState.names);

        return AnimatedBuilder(
          animation: routeAnimationController,
          builder: (context, _){
            return ArenaWidget(
              pageColors: pageColors,
              gameState: gameState,
              increment: increment,
              routeAnimationValue: routeAnimationController.value,
              selectedNames: selected,
              isScrollingSomewhere: isScrolling,
              normalizedPlayerActions: normalizedPlayerActions,
              // theme: theme,
              group: bloc.game.gameGroup,
              initialNameOrder: bloc.game.gameGroup.alternativeLayoutNameOrder.value,
              onPositionNames: bloc.game.gameGroup.alternativeLayoutNameOrder.set,
            );
          },
        );
      },
    );
  }
}

