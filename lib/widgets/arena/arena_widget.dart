import 'package:counter_spell_new/business_logic/sub_blocs/game/sub_game_blocs/game_group.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/components/all.dart';
import 'package:flutter/material.dart';

class ArenaWidget extends StatefulWidget {

  const ArenaWidget({
    @required this.logic,
  });

  static const Set<int> okNumbers = <int>{2,3,4,5,6};

  final CSBloc logic;

  @override
  _ArenaWidgetState createState() => _ArenaWidgetState();

  static const double buttonDim = 56.0;
  static const Size buttonSize = Size(buttonDim,buttonDim);

}

class _ArenaWidgetState extends State<ArenaWidget> {

  bool open = false;

  CSBloc get logic => widget.logic;
  CSSettings get settings => logic.settings;
  CSSettingsArena get arenaSettings => settings.arenaSettings;
  CSGame get gameLogic => logic.game;
  CSGameState get stateLogic => gameLogic.gameState;
  CSGameAction get actionLogic => gameLogic.gameAction;
  CSGameGroup get groupLogic => gameLogic.gameGroup;

  void exit(){
    Navigator.of(context).pop();
  }
  
  double get _buttonSize => ArenaWidget.buttonDim;
  Size get buttonSize => ArenaWidget.buttonSize;


  Widget buildBarrier(){
    return Positioned.fill(child: IgnorePointer(
      ignoring: !open,
      child: GestureDetector(
        onTap: () => this.setState((){
          this.open = false;
        }),
        child: AnimatedContainer(
          duration: CSAnimations.medium,
          color: Theme.of(context).scaffoldBackgroundColor
            .withOpacity(open ? 0.7 : 0.0),
        ),
      ),
    ),);
  }



  Widget finishLayout({
    @required Widget players, 
    EdgeInsets buttonPadding = EdgeInsets.zero, 
    @required bool rotate, 
    @required Widget menuButton,
  }){
    assert(players != null);
    return Stack(children: <Widget>[
      Positioned.fill(child: rotate 
        ? RotatedBox(child: players, quarterTurns: 1,)
        : players
      ),
      buildBarrier(),
      Positioned.fill(child: AnimatedPadding(
        duration: CSAnimations.medium,
        padding: open ? EdgeInsets.zero : buttonPadding ?? EdgeInsets.zero,
        child: Center(child: menuButton),
      )),
    ]);
  }

  Widget layout6Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
    @required CSPage pg,
    @required Map<int,String> indexes,
    @required bool scrolling,
    @required List<String> names,
  }) {
    final wid = constraints.maxWidth;
    final hei = constraints.maxHeight;
    final landscape = wid >= hei;
    final rotate = !landscape;
    double w;
    double h;
    if(rotate){
      w = hei;
      h = wid;
    } else {
      w = wid;
      h = hei;
    }
    if(squadLayout){
      //   =============================
      //   ||   3   ||   4   ||   5   ||
      //   ||       ||       ||       ||
      // h ||=========================||
      //   ||   2   ||   1   ||   0   ||
      //   ||       ||       ||       ||
      //   =============================
      final box = BoxConstraints(
        maxHeight: h/2,
        maxWidth: w/3,
      );
      final Widget players = Column(children: <Widget>[
        SizedBox(
          width: w,
          height: h/2,
          child: RotatedBox(
            quarterTurns: 2,
            child: Row(children: <Widget>[
              for(final i in [5,4,3])
                SizedBox(
                  width: box.maxWidth,
                  height: box.maxHeight,
                  child: buildPlayer(
                    i, box, i == 4 ? Alignment.topCenter : null,
                    pg, indexes, scrolling
                  ),
                ),
            ],),
          ),
        ),
        SizedBox(
          width: w,
          height: h/2,
          child: Row(children: <Widget>[
            for(final i in [2,1,0])
              SizedBox(
                width: box.maxWidth,
                height: box.maxHeight,
                child: buildPlayer(
                  i, box, i == 1 ? Alignment.topCenter : null,
                  pg, indexes, scrolling
                ),
              ),
          ],),
        ),
      ],);

      final undoAxis = landscape ? Axis.horizontal : Axis.vertical;
      final menuButton = buildButton(squadLayout, constraints, pg, undoAxis, indexes, scrolling, names);
      
      return finishLayout(
        players: players, 
        rotate: rotate, 
        menuButton: menuButton,
      );

    } else{
      //    (  x  ) (        2y       ) (  x  )   
      //   =====================================
      //   ||      ||   4    ||   5   ||      || 
      //   ||      ||        ||       ||      || h/2
      // h ||   3  ||=================||  0   || +
      //   ||      ||   2    ||   1   ||      || h/2
      //   ||      ||        ||       ||      ||
      //   =====================================
      // x * h = y * h/2
      // 2x = y
      // 2x + 2y = w
      // 6x = w
      final double x = w / 6;
      final double y = 2 * x;

      final BoxConstraints sideBox = BoxConstraints(
        maxHeight: x,
        maxWidth: h,
      );
      final BoxConstraints middleBox = BoxConstraints(
        maxHeight: h/2,
        maxWidth: y,
      );

      final Widget players = Row(children: <Widget>[
        SizedBox(
          width: x,
          height: h,
          child: RotatedBox(
            quarterTurns: 1,
            child: buildPlayer(
              3, sideBox, null,
              pg, indexes, scrolling
            ),
          ),
        ),
        SizedBox(
          width: y*2,
          height: h,
          child: Column(children: <Widget>[
            SizedBox(
              width: y*2,
              height: h/2,
              child: RotatedBox(
                quarterTurns: 2,
                child: Row(children: <Widget>[ //rotated
                  for(final i in [5,4])
                    buildPlayer(
                      i, middleBox, {5: Alignment.topRight, 4: Alignment.topLeft}[i],
                      pg, indexes, scrolling
                    ),
                ],),
              ),
            ),
            SizedBox(
              width: y*2,
              height: h/2,
              child: Row(children: <Widget>[ //rotated
                for(final i in [2,1])
                  buildPlayer(
                    i,  middleBox, {2: Alignment.topRight, 1: Alignment.topLeft}[i],
                    pg, indexes, scrolling
                  ),
              ],),
            ),
          ],),
        ),
        SizedBox(
          width: x,
          height: h,
          child: RotatedBox(
            quarterTurns: 3,
            child: buildPlayer(
              0, sideBox, null,
              pg, indexes, scrolling
            ),
          ),
        ),
      ],);


      final undoAxis = landscape ? Axis.horizontal : Axis.vertical;
      final menuButton = buildButton(squadLayout, constraints, pg, undoAxis, indexes, scrolling, names);

      return finishLayout(
        players:players, 
        rotate: rotate, 
        menuButton: menuButton,
      );
    }

  }

  Widget layout5Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
    @required CSPage pg,
    @required Map<int,String> indexes,
    @required bool scrolling,
    @required List<String> names,
  }) {
    final wid = constraints.maxWidth;
    final hei = constraints.maxHeight;
    final landscape = wid >= hei;
    final rotate = !landscape;
    double w;
    double h;
    if(rotate){
      w = hei;
      h = wid;
    } else {
      w = wid;
      h = hei;
    }

    if(squadLayout){
      //   (     w/2     )(     w/2     )   
      //   ==============================
      //   ||     3      ||     4      ||  h/2
      //   ||            ||            ||
      // h ||============()============||
      //   ||   2   ||   01   ||   0   ||  h/2
      //   ||       ||        ||       ||
      //   ==============================
      //    (  w/3  )(   --   )(  w/3  )
      final boxTop = BoxConstraints(
        maxHeight: h/2,
        maxWidth: w/2,
      );
      final boxBottom = BoxConstraints(
        maxHeight: h/2,
        maxWidth: w/3,
      );
      final Widget players = Column(children: <Widget>[
        SizedBox(
          width: w,
          height: h/2,
          child: RotatedBox(
            quarterTurns: 2,
            child: Row(children: <Widget>[
              for(final i in [4,3])
                SizedBox(
                  width: boxTop.maxWidth,
                  height: boxTop.maxHeight,
                  child: buildPlayer(
                    i, boxTop, <int,Alignment>{
                      4: Alignment.topRight,
                      3: Alignment.topLeft,
                    }[i],
                    pg, indexes, scrolling
                  ),
                ),
            ],),
          ),
        ),
        SizedBox(
          width: w,
          height: h/2,
          child: Row(children: <Widget>[
            for(final i in [2,1,0])
              SizedBox(
                width: boxBottom.maxWidth,
                height: boxBottom.maxHeight,
                child: buildPlayer(
                  i, boxBottom, i == 1 ? Alignment.topCenter : null,
                  pg, indexes, scrolling
                ),
              ),
          ],),
        ),
      ],);

      final undoAxis = landscape ? Axis.horizontal : Axis.vertical;
      final menuButton = buildButton(squadLayout, constraints, pg, undoAxis, indexes, scrolling, names);

      return finishLayout(
        players:players, 
        rotate: rotate, 
        menuButton: menuButton,
      );

    } else {
      //    (  x  ) (        y        )   
      //   =============================
      //   ||      ||   3    ||   4   ||  h/2
      //   ||      ||        ||       ||
      // h ||   2  ||========()=======||
      //   ||      ||   1    ||   0   ||  h/2
      //   ||      ||        ||       ||
      //   =============================
      
      // same areas
      // x * h = (y / 2) * (h / 2)
      // x = y / 4
      // x + y = w
      //   =>
      final double x = w / 5;
      final double y = w - x;

      final box0134 = BoxConstraints(
        maxHeight: h/2,
        maxWidth: y/2,
      );
      final box2 = BoxConstraints(
        maxHeight: x,
        maxWidth: h,
      );

      final EdgeInsets buttonPadding = rotate 
        ? EdgeInsets.only(top: x) 
        : EdgeInsets.only(left: x);

      final Widget players = Row(children: <Widget>[
        RotatedBox(
          quarterTurns: 1,
          child: SizedBox(
            width: h,
            height: x,
            child: buildPlayer(
              2, box2, Alignment.topRight,
              pg, indexes, scrolling
            ),
          ),
        ),
        Column(children: <Widget>[
          RotatedBox(
            quarterTurns: 2,
            child: SizedBox(
              width: y,
              height: h/2,
              child: Row(children: <Widget>[
                SizedBox(
                  width: y/2,
                  height: y/2,
                  child: buildPlayer(
                    4, box0134, Alignment.topRight,
                    pg, indexes, scrolling
                  ),
                ),
                SizedBox(
                  width: y/2,
                  height: h/2,
                  child: buildPlayer(
                    3, box0134, Alignment.topLeft,
                    pg, indexes, scrolling
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(
            width: y,
            height: h / 2,
            child: Row(children: <Widget>[
              SizedBox(
                width: y/2,
                height: h/2,
                child: buildPlayer(
                  1, box0134, Alignment.topRight,
                  pg, indexes, scrolling
                ),
              ),
              SizedBox(
                width: y/2,
                height: h/2,
                child: buildPlayer(
                  0, box0134, Alignment.topLeft,
                  pg, indexes, scrolling
                ),
              ),
            ]),
          ),
        ]),
      ]);

      final undoAxis = landscape ? Axis.horizontal : Axis.vertical;
      final menuButton = buildButton(squadLayout, constraints, pg, undoAxis, indexes, scrolling, names);

      return finishLayout(
        players:players, 
        buttonPadding: buttonPadding, 
        rotate: rotate, 
        menuButton: menuButton,
      );
    }

  }

  Widget layout4Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
    @required CSPage pg,
    @required Map<int,String> indexes,
    @required bool scrolling,
    @required List<String> names,
  }) {
    final wid = constraints.maxWidth;
    final hei = constraints.maxHeight;
    final landscape = wid >= hei;
    final rotate = landscape != squadLayout;
    double w;
    double h;
    if(rotate){
      w = hei;
      h = wid;
    } else {
      w = wid;
      h = hei;
    }

    Widget players;

    if(squadLayout){
      final box = BoxConstraints(
        maxHeight: h/2,
        maxWidth: w/2,
      );

      players = Column(children: <Widget>[
        RotatedBox(
          quarterTurns: 2,
          child: SizedBox(
            width: w,
            height: h/2,
            child: Row(children: <Widget>[
              buildPlayer(
                3, box, Alignment.topRight,
                pg, indexes, scrolling
              ),
              buildPlayer(
                2, box, Alignment.topLeft,
                pg, indexes, scrolling
              ),
            ])
          ),
        ),
        SizedBox(
          width: w,
          height: h/2,
          child: Row(children: <Widget>[
            buildPlayer(
              1, box,  Alignment.topRight,
              pg, indexes, scrolling
            ),
            buildPlayer(
              0, box, Alignment.topLeft,
              pg, indexes, scrolling
            ),
          ]),
        ),
      ]);

    } else {

      final extBox = BoxConstraints(
        maxHeight: h/4,
        maxWidth: w,
      );
      final intBox = BoxConstraints(
        maxHeight: w/2,
        maxWidth: h/2,
      );
      players = Column(children: <Widget>[
        RotatedBox(
          quarterTurns: 2,
          child: buildPlayer(
            2, extBox, null,
            pg, indexes, scrolling
          ),
        ),
        SizedBox(
          width: w,
          height: h/2,
          child: Row(children: <Widget>[
            RotatedBox(
              quarterTurns: 1,
              child: buildPlayer(
                1, intBox, Alignment.topCenter,
                pg, indexes, scrolling
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: buildPlayer(
                3, intBox, Alignment.topCenter,
                pg, indexes, scrolling
              ),
            ),
          ]),
        ),
        buildPlayer(
          0, extBox, null,
          pg, indexes, scrolling
        ),
      ]);
    }

    final undoAxis = landscape ? Axis.horizontal : Axis.vertical;
    final menuButton = buildButton(squadLayout, constraints, pg, undoAxis, indexes, scrolling, names);

    return finishLayout(
      players:players, 
      rotate: rotate,
      menuButton: menuButton,
    );
  }

  Widget layout3Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
    @required CSPage pg,
    @required Map<int,String> indexes,
    @required bool scrolling,
    @required List<String> names,
  }) {
    final wid = constraints.maxWidth;
    final hei = constraints.maxHeight;
    final landscape = wid >= hei;
    final rotate = landscape != squadLayout;
    double w;
    double h;
    if(rotate){
      w = hei;
      h = wid;
    } else {
      w = wid;
      h = hei;
    }
    Widget players;
    EdgeInsets buttonPadding;
    Axis undoAxis;
    if(squadLayout){
      final topBox = BoxConstraints(
        maxHeight: h/2,
        maxWidth: w,
      );
      final bottomBox = BoxConstraints(
        maxHeight: h/2,
        maxWidth: w/2,
      );
      buttonPadding = EdgeInsets.zero;

      players = Column(children: <Widget>[
        RotatedBox(
          quarterTurns: 2,
          child: buildPlayer(
            2, topBox, Alignment.topCenter,
            pg, indexes, scrolling
          ),
        ),
        Row(children: <Widget>[
          buildPlayer(
            1, bottomBox, Alignment.topRight,
            pg, indexes, scrolling
          ),
          buildPlayer(
            0, bottomBox, Alignment.topLeft,
            pg, indexes, scrolling
          ),
        ]),
      ]);

      undoAxis = landscape ? Axis.horizontal : Axis.vertical;

    } else {
      //area top = w * y
      //area bottom  half = (w / 2) * (h - y)
      //area top == area bottom
      // y * 2w == h * w - y * w
      // y * (2w + w) == h * w
      // y == h/3
      final y = h/3;
      final topBox = BoxConstraints(
        maxHeight: y,
        maxWidth: w,
      );
      final bottomBox = BoxConstraints(
        maxHeight: w/2,
        maxWidth: h - y,
      );
      if(rotate){
        buttonPadding = EdgeInsets.only(left: h - y * 2);
      } else {
        buttonPadding = EdgeInsets.only(bottom: h - y * 2);
      }
      players = ConstrainedBox(
        constraints: constraints,
        child: Column(children: <Widget>[
          RotatedBox(
            quarterTurns: 2,
            child: buildPlayer(
              2, topBox, Alignment.topCenter,
              pg, indexes, scrolling
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
                child: buildPlayer(
                  1, bottomBox, Alignment.topLeft,
                  pg, indexes, scrolling
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: buildPlayer(
                  0, bottomBox, Alignment.topRight,
                  pg, indexes, scrolling
                ),
              ),
            ],),
          ),
        ],),
      );

      undoAxis = landscape ? Axis.vertical : Axis.horizontal;
      ///contrary to most layouts

    }

    final menuButton = buildButton(squadLayout, constraints, pg, undoAxis, indexes, scrolling, names);

    return finishLayout(
      players:players, 
      rotate: rotate, 
      menuButton: menuButton,
      buttonPadding: buttonPadding,
    );
  }

  Widget layout2Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
    @required CSPage pg,
    @required Map<int,String> indexes,
    @required bool scrolling,
    @required List<String> names,
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final box = BoxConstraints(
      maxWidth: w,
      maxHeight: h/2,
    );
    final Widget players = Container(
      width: w,
      height: h,
      child: Column(children: <Widget>[
        RotatedBox(
          quarterTurns: 2,
          child: buildPlayer(
            1, box, Alignment.topCenter,
            pg, indexes, scrolling
          ),
        ),
        buildPlayer(
          0, box, Alignment.topCenter,
          pg, indexes, scrolling
        ),
      ]),
    );

    final menuButton = buildButton(squadLayout, constraints, pg, Axis.horizontal, indexes, scrolling, names);
    /// Always horizontal

    return finishLayout(
      players: players, 
      rotate: false, 
      menuButton: menuButton,
    );
  }

  Widget buildPlayer(int index, 
    BoxConstraints constraints,
    Alignment buttonAlignment,
    CSPage page,
    Map<int,String> indexToName,
    bool isScrollingSomewhere
  ) =>  SimplePlayerTile(
    index,
    logic: logic,
    buttonAlignment: buttonAlignment,
    constraints: constraints,
    indexToName: indexToName,
    isScrollingSomewhere: isScrollingSomewhere,
    page: page,
  );

  @override
  Widget build(BuildContext context) {
    final bloc = logic;
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        top: true,
        child: WillPopScope(
          onWillPop: () async {
            
            if (bloc.game.gameAction.actionPending) {
              bloc.scroller.cancel(true);
              stage.mainPagesController.goToPage(CSPage.life);
              return false;
            } 

            if(open){
              this.setState((){
                open = false;
              });
              return false;
            }

            return true;
          },
          /// main page is not a visible var from the stage, need its private builder separately
          child: StageBuild.offMainPage<CSPage>((_, pg) => BlocVar.build4
            <bool, bool, Map<int,String>, List<String>>(
            bloc.settings.arenaSettings.squadLayout,
            bloc.scroller.isScrolling,
            groupLogic.arenaNameOrder,
            groupLogic.names,
            builder: (_, 
              bool squadLayout,
              bool scrolling,
              Map<int,String> indexes,
              List<String> names,
            ) => LayoutBuilder(builder: (context, constraints){

              switch (names.length) {
                case 2:
                  return layout2Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    pg: pg, indexes: indexes, 
                    scrolling: scrolling, names: names,
                  );
                  break;
                case 3:
                  return layout3Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    pg: pg, indexes: indexes, 
                    scrolling: scrolling, names: names,
                  );
                  break;
                case 4:
                  return layout4Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    pg: pg, indexes: indexes, 
                    scrolling: scrolling, names: names,
                  );
                  break;
                case 5:
                  return layout5Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    pg: pg, indexes: indexes, 
                    scrolling: scrolling, names: names,
                  );
                  break;
                case 6:
                  return layout6Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    pg: pg, indexes: indexes, 
                    scrolling: scrolling, names: names,
                  );
                  break;
                default:
                  return Container();
              }
            }),
          ),),
        ),
      ),
    );
  }

  Widget buildButton(
    bool squadLayout, 
    BoxConstraints screenConstraints, 
    CSPage page, 
    Axis undoRedoAxis,
    Map<int,String> indexToName,
    bool isScrollingSomewhere,
    List<String> names,
  ){
    final Widget button = ArenaMenuButton(
      names: names,
      page: page,
      logic: logic, 
      indexToName: indexToName, 
      isScrollingSomewhere: isScrollingSomewhere,
      open: open, 
      openMenu: () {
        logic.stage.mainPagesController.goToPage(CSPage.life);
        logic.scroller.cancel(true);
        this.setState((){
          open = true;
        });
      }, 
      closeMenu: () => this.setState(() {
        open = false;
      }),
      buttonSize: _buttonSize, 
      exit: exit,
      squadLayout: squadLayout,
      reorderPlayers: () => this.setState((){
        open = false;
        groupLogic.arenaNameOrder.set(<int,String>{
          for(final key in groupLogic.arenaNameOrder.value.keys)
            key: null,
        });
      }),
      screenConstraints: screenConstraints,
    );


    final Widget delayer = logic.settings.scrollSettings.confirmDelay.build((context, delay) 
      => ArenaDelayer(
        onManualCancel: logic.scroller.cancel, 
        onManualConfirm: logic.scroller.forceComplete, 
        delayerController: logic.scroller.delayerController, 
        duration: delay, 
        color: Theme.of(context).colorScheme.onSurface,
        animationListener: logic.scroller.delayerAnimationListener,
      ),
    );

    final Widget undoRedo = ArenaUndo(undoRedoAxis, open);

    return Stack(children: <Widget>[
      Center(child: undoRedo),
      Center(child: delayer),
      Center(child: button),
    ],);
  }


}
