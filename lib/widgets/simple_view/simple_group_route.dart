import 'dart:async';

import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/game/sub_game_blocs/game_action.dart';
import 'package:counter_spell_new/game_model/game_state.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/simple_view/simple_group_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sidereus/bloc/bloc_var.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';

const Duration _kCarouselDuration = const Duration(milliseconds: 200);
const Color _kBarrier = Colors.black12;


class _SimpleGroupRoute<T> extends PopupRoute<T> {
  _SimpleGroupRoute({
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
    Widget page =_SimpleGroup(
      routeAnimationController: _animationController,
    );
    if (theme != null)
      page = Theme(data: theme, child: page);
    return page;
  }
}

Future<T> showSimpleGroup<T>({
  @required BuildContext context,
  @required CSBloc bloc,
}) {
  assert(context != null);
  
  final stage = Stage.of(context);
  stage.pagesController.pageSet(CSPage.life);
  bloc.game.gameAction.clearSelection();

  return Navigator.push(context, _SimpleGroupRoute<T>(
    theme: Theme.of(context, shadowThemeOnly: true),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  )).then<void>((_) => SystemChrome.setPreferredOrientations(
    DeviceOrientation.values.toList()
  ));
  
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
    final stage = Stage.of<CSPage,SettingsPage>(context);

    return BlocVar.build6(
      bloc.scroller.isScrolling,
      bloc.scroller.intValue,
      actionBloc.selected,
      bloc.game.gameState.gameState,
      bloc.game.gameGroup.usingPartnerB,
      stage.themeController.primaryColorsMap,
      builder: (
        BuildContext context, 
        bool isScrolling, 
        int increment,
        Map<String,bool> selected, 
        GameState gameState,
        Map<String,bool> usingPartnerB,
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

          usingPartnerB: usingPartnerB,
          applyDamageToLife: true,
          //these two values are so rarely updated that all the actual
          //reactive variables make this rebuild so often that min and max
          //will basically always be correct. no need to add 2 streambuilders
          minValue: settings.minValue.value,
          maxValue: settings.maxValue.value,
        ).actions(gameState.names);

        return AnimatedBuilder(
          animation: routeAnimationController,
          builder: (context, _){
            return SimpleGroupWidget(
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

