import 'dart:async';

import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/models/game/game_state.dart';
import 'package:counter_spell_new/models/game/player_state.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:division/division.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sidereus/bloc/bloc_var.dart';

const Duration _kCarouselDuration = const Duration(milliseconds: 200);
const Color _kBarrier = Colors.black12;




class _SimpleCSDialogRoute<T> extends PopupRoute<T> {
  _SimpleCSDialogRoute({
    @required this.theme,
    @required this.barrierLabel,
    @required this.backgroundColor,
    RouteSettings settings,
  }) : super(settings: settings);

  final ThemeData theme;
  final Color Function(int) backgroundColor;

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
    Widget carousel =_SimpleCSDialog(
      routeAnimationController: _animationController,
      backgroundColor: backgroundColor ?? (i) => _kBarrier,
    );
    if (theme != null)
      carousel = Theme(data: theme, child: carousel);
    return carousel;
  }
}

Future<T> showCSDialog<T>({
  @required BuildContext context,
  Color Function(int) backgroundColor,
}) {
  assert(context != null);

  return Navigator.push(context, _SimpleCSDialogRoute<T>(
    theme: Theme.of(context, shadowThemeOnly: true),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    backgroundColor: backgroundColor,
  )).then<void>((_) => SystemChrome.setPreferredOrientations(
    DeviceOrientation.values.toList()
  ));
  
}

const double _borderRadius = 16.0;
const double _margin = 8.0;

class _SimpleCSDialog extends StatelessWidget {

  _SimpleCSDialog({
    Key key,
    @required this.routeAnimationController,
    @required this.backgroundColor,
  }): super(key: key);
  
  final AnimationController routeAnimationController;
  final Color Function(int) backgroundColor;

  final StyleClass _styleClass = StyleClass()
    ..borderRadius(all: _borderRadius)
    ..boxShadow(blur: 7, offset: [0,0])
    ..margin(all: _margin)
    ..alignmentChild.center()
    ..maxHeight(double.infinity)
    ..maxWidth(double.infinity);

  Widget buildPlayer(String name, PlayerState playerState, int qTurns) {
    //0 qTurns => vertical listview with non turned children
    //1 qTurns => horizontal reversed listview (right gestures)
    //         => turned to -1 (or 3) to be "vertical" in respect to the player rectangle
    //         => so by default its children are turned by +1 
    //           ==> and contained in a sized box of width = width of the expanded
    //2 qTurns => vertical listview reversed (right gestures)
    //         => no turns should be needed on the list or on the children
    //3 qTurns => horizontal listview NON REV (right gestures)
    //         => turned to +1 
    //         => children turned to -1 and contained in a sized box of w = w expanded

    int extTurns = 0;
    int intTurns = 0;
    Axis axis = Axis.vertical;
    bool reversed = false;
    if([0, 4, -4, 8, -8].contains(qTurns)){
      extTurns = 0;
      intTurns = 0;
      axis = Axis.vertical;
      reversed = false;
    }
    else if([1, 5, -3, 9, -7].contains(qTurns)){
      extTurns = 3;
      intTurns = 1;
      axis = Axis.horizontal;
      reversed = true;
    }
    else if([2, 6, -2, 10, -6].contains(qTurns)){
      extTurns = 2;
      intTurns = 2;
      axis = Axis.vertical;
      reversed = true;
    }
    else if([3, 7, -1, 11, -5].contains(qTurns)){
      extTurns = 1;
      intTurns = 3;
      axis = Axis.horizontal;
      reversed = false;
    }


    // final List<AnnotationData> annotations = playerState.annotations(myTheme, bTypes, cTypes);
    return Division(
      style: StyleClass()..add(_styleClass)
        ..alignmentChild.center()
        ..padding(all: 8.0, horizontal: 8.0)
        // ..background.color(
        //   myTheme.materialBody
        // ),,
        , ////////////////////////////////////////////////
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(children: <Widget>[
            Container(
              height: 16,
              alignment: Alignment.center,
              child: Text(name),
            ),
            Expanded(child: LayoutBuilder(builder:(context, constraints)
              => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                constraints: BoxConstraints(minWidth: 140),
                child: Division(
                  style: StyleClass()
                    ..overflow.hidden(),
                  child: Text(
                    playerState.life.toString(),
                    style: TextStyle(
                      fontSize: constraints.maxHeight * (14 / 20),
                    ),
                  ),
                )
              ),
            )),
          ],),
          // if(annotations.length > 0)
          //   Expanded(
          //     child: LayoutBuilder(builder: (cntxt,constr) 
          //       => Division(
          //         style: StyleClass()
          //           ..borderRadius(all: _borderRadius)
          //           // ..background.color(myTheme.background)
          //           ..height(double.infinity)
          //           ..overflow.hidden()
          //           ..alignmentChild.topCenter(),
          //         child: Material(
          //           type: MaterialType.transparency,
          //           child: RotatedBox(
          //             quarterTurns: extTurns,
          //             child: ListView(
          //               shrinkWrap: true,
          //               reverse: reversed,
          //               scrollDirection: axis,
          //               children: <Widget>[
          //                 for(final x in annotations)
          //                   RotatedBox(
          //                     quarterTurns: intTurns,
          //                     child: ConstrainedBox(
          //                       constraints: constr,
          //                       child: GriddableListTile(
          //                         onTap: (){},
          //                         title: Text(x.name, style: myTheme.smallTextOverBackground),
          //                         trailing: Text(x.value, style: myTheme.smallTextOverBackground),
          //                         leading: Icon(x.iconData, color: myTheme.getSmartContrast(x.color)),
          //                       ),
          //                     ),
          //                   ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ]
      ),
    );
  }

  Widget get nonValidNumber => Division(
    style: StyleClass()..add(_styleClass)
      ..alignmentChild.center()
      ..background.color(Color(0xFFB71C1C)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.error, size: 100, color: Colors.white),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 250,
            ),
            child: Text(
              "You can use this simplified display only with 2, 3, or 4 players!",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );

  Widget layout4Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required Map<String,PlayerState> states, 
    @required List<String> names
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final landscape = w >= h;
    if(landscape)
      return Column(children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: w,
            maxHeight: h/2,
          ),
          child: Row(children: <Widget>[
            RotatedBox(
              quarterTurns: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: w/2,
                  maxWidth: h/2,
                ),
                child: buildPlayer(names[0], states[names[0]], 1),
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: w/2,
                  maxWidth: h/2,
                ),
                child: buildPlayer(names[1], states[names[1]], 3),
              ),
            ),
          ],),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: w,
            maxHeight: h/2,
          ),
          child: Row(children: <Widget>[
            RotatedBox(
              quarterTurns: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: w/2,
                  maxWidth: h/2,
                ),
                child: buildPlayer(names[1], states[names[1]], 1),
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: w/2,
                  maxWidth: h/2,
                ),
                child: buildPlayer(names[2], states[names[2]], 3),
              ),
            ),
          ],),
        ),
      ],);
    else
      return Column(children: <Widget>[
        RotatedBox(
          quarterTurns: 2,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: h/4,
              maxWidth: w,
            ),
            child: buildPlayer(names[0], states[names[0]], 2),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: h/2,
            maxWidth: w,
          ),
          child: Row(children: <Widget>[
            RotatedBox(
              quarterTurns: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: h/2,
                  maxHeight: w/2,
                ),
                child: buildPlayer(names[3], states[names[3]], 1),
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: h/2,
                  maxHeight: w/2,
                ),
                child: buildPlayer(names[1], states[names[1]], 3),
              ),
            )
          ],),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: h/4,
            maxWidth: w,
          ),
          child: buildPlayer(names[2], states[names[2]], 0),
        ),
      ],);
  }

  Widget layout3Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required Map<String,PlayerState> states, 
    @required List<String> names
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final landscape = w >= h;

    if(landscape){
      return Column(children: <Widget>[
        RotatedBox(
            quarterTurns: 2,
            child: SizedBox(
              height: h/2,
              width: w,
              child: buildPlayer(names[0], states[names[0]], 2),
            ),
        ),
        Row(children: <Widget>[
          SizedBox(
            height: h/2,
            width: w/2,
            child: buildPlayer(names[1], states[names[1]], 0),
          ),
          SizedBox(
            height: h/2,
            width: w/2,
            child: buildPlayer(names[2], states[names[2]], 0),
          ),
        ],),
      ],);
    }
    else {
      //area top = w * y
      //area bottom  half = (w / 2) * (h - y)
      //area top == area bottom
      // y * 2w == h * w - y * w
      // y * (2w + w) == h * w
      // y == h/3
      final y = h/3;
      return ConstrainedBox(
        constraints: constraints,
        child: Column(children: <Widget>[
          RotatedBox(
            quarterTurns: 2,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: y,
                maxWidth: w,
              ),
              child: buildPlayer(names[0], states[names[0]], 2),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: h - y,
              maxWidth: w,
            ),
            child: Row(children: <Widget>[
              RotatedBox(
                quarterTurns: 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: w/2,
                    maxWidth: h - y,
                  ),
                  child: buildPlayer(names[2], states[names[2]], 1),
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: w/2,
                    maxWidth: h - y,
                  ),
                  child: buildPlayer(names[1], states[names[1]], 3),
                ),
              ),
            ],),
          ),
        ],),
      );
    }
  }

  Widget layout2Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required Map<String,PlayerState> states, 
    @required List<String> names
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    return Container(
      width: w,
      height: h,
      child: Column(children: <Widget>[
        RotatedBox(
          quarterTurns: 2,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: h/2,
              maxWidth: w,
            ),
            child: this.buildPlayer(names[0], states[names[0]], 2),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: h/2,
            maxWidth: w,
          ),
          child: this.buildPlayer(names[1], states[names[1]], 0),
        ),
      ]),
    );

  }




  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final actionBloc = bloc.game.gameAction;

    return BlocVar.build4(
      bloc.scroller.isScrolling,
      bloc.scroller.intValue,
      actionBloc.selected,
      bloc.game.gameState.gameState,
      builder: (
        BuildContext context, 
        bool isScrolling, 
        int increment,
        Map<String,bool> selected, 
        GameState gameState,
      ) {

        final int howManyPlayers = gameState.players.length;
        final states = {
          for(final entry in gameState.players.entries)
            entry.key: entry.value.states.last,  
        };
        return LayoutBuilder(builder: (context, constraints){
          if(howManyPlayers == 2)
            return layout2Players(context, 
              constraints: constraints,
              states: states,
              names: gameState.names.toList(), //order
            );
          if(howManyPlayers == 3)
            return layout3Players(context, 
              constraints: constraints,
              states: states,
              names: gameState.names.toList(), //order
            );
          if(howManyPlayers == 4)
            return layout4Players(context, 
              constraints: constraints,
              states: states,
              names: gameState.names.toList(), //order
            );
          return this.nonValidNumber;

        });
      }
    );
  }
}

