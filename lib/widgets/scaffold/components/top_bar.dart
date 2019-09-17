import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/blocs/sub_blocs/themer.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/sidereus_app/sidereus_app.dart';
import 'package:sidereus/sidereus.dart';

//position, size, dragUpdate, dragEnd, menuButton
class CSTopBar extends StatelessWidget {
  CSTopBar({
    Key key,
    @required this.position,
    @required this.size,
    @required this.dragEnd,
    @required this.dragUpdate,
    @required this.menuButton,
    @required this.dimensions,
  }) : super(key: key);

  final double position;
  final double size;
  final void Function(DragUpdateDetails) dragUpdate;
  final void Function(DragEndDetails) dragEnd;
  final Widget menuButton;
  final SidDimensions dimensions;

  @override
  Widget build(BuildContext context) {

    final bloc = CSBloc.of(context);

    return bloc.scaffold.reactiveBuild((context, theme, index, open, casting, counter){

      final page = bloc.scaffold.indexToPage[index]; 
      final themeData = theme.data;
      
      String text = "";
      if(open){
        text = "CounterSpell";
      }
      if(page == CSPage.counters){
        text = counter.longName;
      }
      else if(page == CSPage.commander){
        text = casting ? "Commander Cast" : "Commander Damage";
      }
      else text = CSPAGE_TITLES_LONG[page];

      Color color = CSThemer.getScreenColor(
        casting: casting,
        theme: theme,
        open: open,
        page: page,
      );

      return Division(
        style: StyleClass()
          ..background.color(color)
          ..boxShadow(
            color: const Color(0x59000000), 
            blur: 12,
            offset: [0,0]
          )
          ..animate(MyDurations.fast.inMilliseconds),
        child: Material(
          type: MaterialType.transparency,
          child: GestureDetector(
            onVerticalDragUpdate: this.dragUpdate,
            onVerticalDragEnd: this.dragEnd,
            child: Container(
              color: Colors.transparent,
              height: this.size,
              width: dimensions.globalWidth,
              alignment: Alignment.bottomCenter,
              child: Container(
                height: dimensions.barSize,
                width: dimensions.globalWidth,
                child: Stack(children: <Widget>[
                  Center( child: AnimatedText(
                    duration: MyDurations.fast,
                    text: text,
                    style: Theme.of(context).primaryTextTheme.title,
                  )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconTheme(
                      data: themeData.primaryIconTheme,
                      child: menuButton,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
    });
  }

}


