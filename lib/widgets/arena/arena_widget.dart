import 'package:counter_spell_new/business_logic/sub_blocs/game/sub_game_blocs/game_group.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/components/all.dart';
import 'package:flutter/material.dart';

class ArenaWidget extends StatefulWidget {

  const ArenaWidget({
    @required this.pageColors,
    @required this.gameState,
    @required this.selectedNames,
    @required this.isScrollingSomewhere,
    @required this.increment,
    @required this.routeAnimationValue,
    @required this.group,
    @required this.normalizedPlayerActions,
    this.initialNameOrder,
    this.onPositionNames,
  });

  static const Set<int> okNumbers = <int>{2,3,4,5,6};

  final GameState gameState;
  final Map<String,bool> selectedNames;
  final bool isScrollingSomewhere;
  final int increment;
  final CSGameGroup group;
  final Map<CSPage,Color> pageColors;
  final Map<String,PlayerAction> normalizedPlayerActions;
  final double routeAnimationValue;
  final Map<int, String> initialNameOrder;
  final void Function(Map<int,String>) onPositionNames;

  @override
  _ArenaWidgetState createState() => _ArenaWidgetState();

  static const double _buttonSize = 56.0;
  static const Size buttonSize = Size(_buttonSize,_buttonSize);

}

class _ArenaWidgetState extends State<ArenaWidget> {

  Map<int, String> indexToName;
  bool open = false;

  @override
  void initState() {
    super.initState();
    initNames(widget.initialNameOrder);
  }

  void initNames(Map<int,String> initialNameOrder){
    final int len = widget.gameState.names.length;
    this.indexToName = initialNameOrder ?? {
      for(int i=0; i<len; ++i)
        i: null,
    };
  }

  void preExit(){
    Stage.of(context).mainPagesController.goToPage(
      CSBloc.of(context).settings.lastPageBeforeArena.value,
    );
  }
  void exit(){
    preExit();
    Navigator.of(context).pop();
  }
  
  @override
  void didUpdateWidget(ArenaWidget oldWidget){
    super.didUpdateWidget(oldWidget);
    if(indexToName.values.any((name)
      => !widget.gameState.names.contains(name)
    ) || widget.gameState.names.any((name)
      => !indexToName.values.contains(name)
    )){
      initNames(null);
      this.open = false;
    }
  }

  double get _buttonSize => ArenaWidget._buttonSize;
  Size get buttonSize => ArenaWidget.buttonSize;

  String get firstUnpositionedName {
    for(final name in widget.gameState.names){
      if(!this.indexToName.values.contains(name)){
        return name;
      }
    }
    return null;
  }

  void positionName(String name, int position){
    this.setState((){
      this.indexToName[position] = name;
    });
    if(widget.onPositionNames != null)
      widget.onPositionNames(indexToName);
  }

  VoidCallback playerCallback(int index) => (){
    this.positionName(firstUnpositionedName, index);
  };


  Widget buildBarrier(){
    return Positioned.fill(child: IgnorePointer(
      ignoring: open ? false : true,
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
        ? RotatedBox(child:players, quarterTurns: 1,)
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
    @required Widget menuButton,
    @required String atk,
    @required String def,
    @required Color defC,
    @required CSPage pg,
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
                    atk, def, defC, pg,
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
                  atk, def, defC, pg,
                ),
              ),
          ],),
        ),
      ],);

      return finishLayout(
        players:players, 
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
              atk, def, defC, pg,
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
                      atk, def, defC, pg,
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
                    atk, def, defC, pg,
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
              atk, def, defC, pg,
            ),
          ),
        ),
      ],);


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
    @required Widget menuButton,
    @required String atk,
    @required String def,
    @required Color defC,
    @required CSPage pg,
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
                    atk, def, defC, pg,
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
                  atk, def, defC, pg,
                ),
              ),
          ],),
        ),
      ],);

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
              atk, def, defC, pg,
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
                    atk, def, defC, pg,
                  ),
                ),
                SizedBox(
                  width: y/2,
                  height: h/2,
                  child: buildPlayer(
                    3, box0134, Alignment.topLeft,
                    atk, def, defC, pg,
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
                  atk, def, defC, pg,
                ),
              ),
              SizedBox(
                width: y/2,
                height: h/2,
                child: buildPlayer(
                  0, box0134, Alignment.topLeft,
                  atk, def, defC, pg,
                ),
              ),
            ]),
          ),
        ]),
      ]);

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
    @required Widget menuButton,
    @required String atk,
    @required String def,
    @required Color defC,
    @required CSPage pg,
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
                atk, def, defC, pg,
              ),
              buildPlayer(
                2, box, Alignment.topLeft,
                atk, def, defC, pg,
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
              atk, def, defC, pg,
            ),
            buildPlayer(
              0, box, Alignment.topLeft,
              atk, def, defC, pg,
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
            atk, def, defC, pg,
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
                atk, def, defC, pg,
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: buildPlayer(
                3, intBox, Alignment.topCenter,
                atk, def, defC, pg,
              ),
            ),
          ]),
        ),
        buildPlayer(
          0, extBox, null,
          atk, def, defC, pg,
        ),
      ]);
    }

      return finishLayout(
        players:players, 
        rotate: rotate,
        menuButton: menuButton,
      );
  }

  Widget layout3Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
    @required Widget menuButton,
    @required String atk,
    @required String def,
    @required Color defC,
    @required CSPage pg,
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
            atk, def, defC, pg,
          ),
        ),
        Row(children: <Widget>[
          buildPlayer(
            1, bottomBox, Alignment.topRight,
            atk, def, defC, pg,
          ),
          buildPlayer(
            0, bottomBox, Alignment.topLeft,
            atk, def, defC, pg,
          ),
        ]),
      ]);
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
              atk, def, defC, pg,
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
                  atk, def, defC, pg,
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: buildPlayer(
                  0, bottomBox, Alignment.topRight,
                  atk, def, defC, pg,
                ),
              ),
            ],),
          ),
        ],),
      );
    }

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
    @required Widget menuButton,
    @required String atk,
    @required String def,
    @required Color defC,
    @required CSPage pg,
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
            atk, def, defC, pg,
          ),
        ),
        buildPlayer(
          0, box, Alignment.topCenter,
          atk, def, defC, pg,
        ),
      ]),
    );

    return finishLayout(
      players:players, 
      rotate: false, 
      menuButton: menuButton,
    );
  }

  Widget buildPlayer(int index, 
    BoxConstraints constraints,
    Alignment buttonAlignment,
    String attacker,
    String defender,
    Color defenceColor,
    CSPage page,
  ) => SimplePlayerTile(
    index,
    onPosition: playerCallback(index),
    buttonAlignment: buttonAlignment,
    constraints: constraints,
    routeAnimationValue: widget.routeAnimationValue,

    indexToName: indexToName,

    increment: widget.increment,
    group: widget.group,
    isScrollingSomewhere: widget.isScrollingSomewhere,
    gameState: widget.gameState,
    // theme: widget.theme,
    pageColors: widget.pageColors,
    selectedNames: widget.selectedNames,
    normalizedPlayerActions: widget.normalizedPlayerActions,

    firstUnpositionedName: firstUnpositionedName,
    whoIsAttacking: attacker,
    whoIsDefending: defender,
    defenceColor: defenceColor,
    page: page,
  );

  @override
  Widget build(BuildContext context) {
    final bloc = widget.group.parent.parent;
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor
        .withOpacity(widget.routeAnimationValue),
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

            preExit();
            return true;
          },
          /// main page is not a visible var from the stage, need its private builder separately
          child: StageBuild.offMainPage((_, pg) => BlocVar.build4<bool, Color, String, String>(
            bloc.settings.arenaSquadLayout,
            bloc.themer.defenceColor,
            bloc.game.gameAction.defendingPlayer,
            bloc.game.gameAction.attackingPlayer,
            builder: (_, 
              bool squadLayout,
              Color defC,
              String def,
              String atk,
            ) => LayoutBuilder(builder: (context, constraints){
              final Widget menuButton = buildButton(squadLayout, constraints);

              switch (widget.gameState.players.length) {
                case 2:
                  return layout2Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    menuButton: menuButton,
                    atk: atk, def: def, pg: pg, defC: defC,
                  );
                  break;
                case 3:
                  return layout3Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    menuButton: menuButton,
                    atk: atk, def: def, pg: pg, defC: defC,
                  );
                  break;
                case 4:
                  return layout4Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    menuButton: menuButton,
                    atk: atk, def: def, pg: pg, defC: defC,
                  );
                  break;
                case 5:
                  return layout5Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    menuButton: menuButton,
                    atk: atk, def: def, pg: pg, defC: defC,
                  );
                  break;
                case 6:
                  return layout6Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                    menuButton: menuButton,
                    atk: atk, def: def, pg: pg, defC: defC,
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

  Widget buildButton(bool squadLayout, BoxConstraints screenConstraints){
    return ArenaMenuButton(
      bloc: widget.group.parent.parent, 
      indexToName: this.indexToName, 
      isScrollingSomewhere: widget.isScrollingSomewhere,
      open: open, 
      toggleOpen: ()=> this.setState((){
        open = !open;
      }), 
      routeAnimationValue: widget.routeAnimationValue, 
      buttonSize: _buttonSize, 
      exit: exit,
      squadLayout: squadLayout,
      gameState: widget.gameState,
      reorderPlayers:   () => this.setState((){
        this.initNames(null);
        open = false;
        this.widget.onPositionNames(this.indexToName);
      }),
      screenConstraints: screenConstraints,
    );
  }


}
