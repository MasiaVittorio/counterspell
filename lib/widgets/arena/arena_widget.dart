import 'package:counter_spell_new/business_logic/sub_blocs/game/sub_game_blocs/game_group.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/components/all.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';

class ArenaWidget extends StatefulWidget {

  static const Set<int> okNumbers = <int>{2,3,4,5};
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

  @override
  _ArenaWidgetState createState() => _ArenaWidgetState();
}

class _ArenaWidgetState extends State<ArenaWidget> {

  Map<int, String> indexToName;
  bool open = false;

  @override
  void initState() {
    super.initState();
    initNames();
  }

  void initNames(){
    final len = widget.gameState.names.length;
    this.indexToName = widget.initialNameOrder ?? {
      for(int i=0; i<len; ++i)
        i: null,
    };
  }

  void resetNames(){
    final len = widget.gameState.names.length;
    this.indexToName = {
      for(int i=0; i<len; ++i)
        i: null,
    };
    this.open = false;
  }

  void preExit(){
    Stage.of(context).pagesController.pageSet(
      CSBloc.of(context).settings.lastPageBeforeSimpleScreen.value,
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
      initNames();
    }
  }

  static const double _buttonSize = 56.0;
  Size get buttonSize {
    return Size(_buttonSize,_buttonSize);
  }

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

  Widget buildButton(){
    final bloc = widget.group.parent.parent;
    VoidCallback centerTap;
    bool buttonCross;

    if(indexToName.values.any((v) => v == null)){
      buttonCross = true;
      centerTap = exit;
    } else if(widget.isScrollingSomewhere){
      buttonCross = true;
      centerTap = bloc.scroller.cancel;
    } else {
      buttonCross = open;
      centerTap = ()=> this.setState((){
        open = !open;
      });
    }
    assert(buttonCross != null);
    assert(centerTap != null);

    return Opacity(
      opacity: widget.routeAnimationValue,
      child: Material(
        animationDuration: CSAnimations.fast,
        elevation: open ? 10 : 4,
        borderRadius: BorderRadius.circular(_buttonSize/2),
        child: InkWell(
          onTap: centerTap,
          onLongPress: exit,
          borderRadius: BorderRadius.circular(_buttonSize/2),
          child: Container(
            alignment: Alignment.center,
            width: _buttonSize,
            height: _buttonSize,
            child: AnimatedSwitcher(
              duration: CSAnimations.fast,
              child: ImplicitlyAnimatedIcon(
                key: ValueKey("simplegroup_button_animated_icon"),
                state: buttonCross,
                icon: AnimatedIcons.menu_close,
                duration: CSAnimations.fast,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBarrier(){
    return Positioned.fill(child: IgnorePointer(
      ignoring: open ? false : true,
      child: GestureDetector(
        onTap: () => this.setState((){
          this.open = false;
        }),
        child: AnimatedContainer(
          duration: CSAnimations.fast,
          color: Theme.of(context).scaffoldBackgroundColor
            .withOpacity(open ? 0.7 : 0.0),
        ),
      ),
    ),);
  }

  Widget buildButtons(bool squadLayout, CSSettings settings, bool landscape){
    return Positioned(
      // duration: CSAnimations.fast,
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: AnimatedListed(
        duration: const Duration(milliseconds: 200),
        overlapSizeAndOpacity: 1.0,
        listed: open,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),//to show shadows
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              boxShadow: [BoxShadow(
                color: const Color(0x59000000), 
                blurRadius: 12,
              )],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if(widget.gameState.players.length != 2)
                    RadioSlider(
                      selectedIndex: squadLayout ? 0 : 1,
                      onTap: (i) => settings.arenaSquadLayout.set(i==0),
                      title: Text("Layout"),
                      items: [
                        RadioSliderItem(
                          icon: Icon(McIcons.account_multiple_outline),
                          title: Text("Squad"),
                        ),
                        RadioSliderItem(
                          icon: Icon(McIcons.account_outline),
                          title: Text("Free for all"),
                        ),
                      ],
                    ),
                  ...(){
                    final list = [
                      ListTile(
                        leading: Icon(Icons.arrow_back),
                        title: Text("Back to full power"),
                        onTap: exit,
                      ),
                      ListTile(
                        leading: Icon(McIcons.account_group_outline),
                        title: Text("Reorder players"),
                        onTap: () => this.setState((){
                          this.resetNames();
                          this.widget.onPositionNames(this.indexToName);
                        }),
                      ),
                    ];
                    if(landscape) return [Row(children: <Widget>[for(final child in list) Expanded(child: child,)],)];
                    else return list;
                  }(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget finishLayout(Widget players, Widget positionedButton, bool rotate, bool squadLayout, bool landscape){
    assert(positionedButton != null);
    assert(players != null);
    return Stack(children: <Widget>[
      Positioned.fill(child: rotate 
        ? RotatedBox(child:players, quarterTurns: 1,)
        : players
      ),
      buildBarrier(),
      positionedButton,
      buildButtons(squadLayout, this.widget.group.parent.parent.settings, landscape),
    ]);
  }

  Widget layout6Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
  }) {
    // final wid = constraints.maxWidth;
    // final hei = constraints.maxHeight;
    // final landscape = wid >= hei;
    // final rotate = !landscape;
    // double w;
    // double h;
    // if(rotate){
    //   w = hei;
    //   h = wid;
    // } else {
    //   w = wid;
    //   h = hei;
    // }

    //    (  x  ) (        y        ) (  x  )   
    //   =====================================
    //   ||      ||   4    ||   5   ||      || 
    //   ||      ||        ||       ||      || h/2
    // h ||   3  ||=================||  0   || +
    //   ||      ||   2    ||   1   ||      || h/2
    //   ||      ||        ||       ||      ||
    //   =====================================
    // return Row(children: <Widget>[
    //   // 3 rotated
    //   Column(children: <Widget>[
    //     Row(children: <Widget>[ //rotated
    //       // 5
    //       // 4
    //     ],),
    //     Row(children: <Widget>[
    //       // 2
    //       // 1
    //     ],),
    //   ],)
    //   // 0 rotated
    // ],);

    //   =============================
    //   ||   3   ||   4   ||   5   ||
    //   ||       ||       ||       ||
    // h ||=========================||
    //   ||   2   ||   1   ||   0   ||
    //   ||       ||       ||       ||
    //   =============================
    // return Column(children: <Widget>[
    //   Row(children: <Widget>[ // rotated
    //     // 5
    //     // 4
    //     // 3      
    //   ]),
    //   Row(children: <Widget>[
    //     // 2
    //     // 1
    //     // 0
    //   ]),
    // ],);
    
    return null;
  }

  Widget layout5Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
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
                  child: buildPlayer(i, 
                    constraints: boxTop, 
                    buttonSize: buttonSize, 
                    buttonAlignment: <int,Alignment>{
                      4: Alignment.topRight,
                      3: Alignment.topLeft,
                    }[i],
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
                child: buildPlayer(i, 
                  constraints: boxBottom, 
                  buttonSize: buttonSize, 
                  buttonAlignment: i == 1 ? Alignment.topCenter : null,
                ),
              ),
          ],),
        ),
      ],);

      final Widget positionedButton = Center(child: buildButton(),);

      return finishLayout(players, positionedButton, rotate, squadLayout, landscape);

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

      final Widget positionedButton = Padding(
        padding: rotate ? EdgeInsets.only(top: x) : EdgeInsets.only(left: x),
        child: Center(child: buildButton(),),
      );

      final Widget players = Row(children: <Widget>[
        RotatedBox(
          quarterTurns: 1,
          child: SizedBox(
            width: h,
            height: x,
            child: buildPlayer(2,
              constraints: box2,
              buttonAlignment: Alignment.topRight,
              buttonSize: buttonSize,
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
                  child: buildPlayer(4, 
                    constraints: box0134, 
                    buttonSize: buttonSize, 
                    buttonAlignment: Alignment.topRight,
                  ),
                ),
                SizedBox(
                  width: y/2,
                  height: h/2,
                  child: buildPlayer(3, 
                    constraints: box0134, 
                    buttonSize: buttonSize, 
                    buttonAlignment: Alignment.topLeft,
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
                child: buildPlayer(1, 
                  constraints: box0134, 
                  buttonSize: buttonSize, 
                  buttonAlignment: Alignment.topRight,
                ),
              ),
              SizedBox(
                width: y/2,
                height: h/2,
                child: buildPlayer(0, 
                  constraints: box0134, 
                  buttonSize: buttonSize, 
                  buttonAlignment: Alignment.topLeft,
                ),
              ),
            ]),
          ),
        ]),
      ]);

      return finishLayout(players, positionedButton, rotate, squadLayout, landscape);
    }

  }

  Widget layout4Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
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
    Widget positionedButton;
    if(squadLayout){
      final box = BoxConstraints(
        maxHeight: h/2,
        maxWidth: w/2,
      );

      positionedButton = Center(child: buildButton());

      players = Column(children: <Widget>[
        RotatedBox(
          quarterTurns: 2,
          child: SizedBox(
            width: w,
            height: h/2,
            child: Row(children: <Widget>[
              buildPlayer(3,
                constraints: box,
                buttonAlignment: Alignment.topRight,
                buttonSize: buttonSize,
              ),
              buildPlayer(2,
                constraints: box,
                buttonAlignment: Alignment.topLeft,
                buttonSize: buttonSize,
              ),
            ])
          ),
        ),
        SizedBox(
          width: w,
          height: h/2,
          child: Row(children: <Widget>[
            buildPlayer(1,
              constraints: box,
              buttonAlignment: Alignment.topRight,
              buttonSize: buttonSize,
            ),
            buildPlayer(0,
              constraints: box,
              buttonAlignment: Alignment.topLeft,
              buttonSize: buttonSize,
            ),
          ]),
        ),
      ]);

    } else {
      positionedButton = Center(child: buildButton(),);

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
          child: buildPlayer(2,
            constraints: extBox,
            buttonAlignment: null,
            buttonSize: buttonSize,
          ),
        ),
        SizedBox(
          width: w,
          height: h/2,
          child: Row(children: <Widget>[
            RotatedBox(
              quarterTurns: 1,
              child: buildPlayer(1,
                constraints: intBox,
                buttonAlignment: Alignment.topCenter,
                buttonSize: buttonSize,
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: buildPlayer(3,
                constraints: intBox,
                buttonAlignment: Alignment.topCenter,
                buttonSize: buttonSize,
              ),
            ),
          ]),
        ),
        buildPlayer(0,
          constraints: extBox,
          buttonAlignment: null,
          buttonSize: buttonSize,
        ),
      ]);
    }

    return finishLayout(players, positionedButton, rotate, squadLayout, landscape);
  }

  Widget layout3Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
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
    Widget positionedButton;
    if(squadLayout){
      final topBox = BoxConstraints(
        maxHeight: h/2,
        maxWidth: w,
      );
      final bottomBox = BoxConstraints(
        maxHeight: h/2,
        maxWidth: w/2,
      );
      positionedButton = Center(child: buildButton());
      players = Column(children: <Widget>[
        RotatedBox(
          quarterTurns: 2,
          child: buildPlayer(2,
            constraints: topBox,
            buttonAlignment: Alignment.topCenter,
            buttonSize: buttonSize,
          ),
        ),
        Row(children: <Widget>[
          buildPlayer(1,
            constraints: bottomBox,
            buttonAlignment: Alignment.topRight,
            buttonSize: buttonSize,
          ),
          buildPlayer(0,
            constraints: bottomBox,
            buttonAlignment: Alignment.topLeft,
            buttonSize: buttonSize,
          ),
        ]),
      ]);
    }
    else {
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
        positionedButton = Positioned(
          top: 0.0,
          bottom: 0.0,
          right: 0.0,
          width: y*2,
          child: Center(child: buildButton()),
        );
      } else {
        positionedButton = Positioned(
          top: 0.0,
          right: 0.0,
          left: 0.0,
          height: y*2,
          child: Center(child: buildButton()),
        );
      }
      players = ConstrainedBox(
        constraints: constraints,
        child: Column(children: <Widget>[
          RotatedBox(
            quarterTurns: 2,
            child: buildPlayer(2,
              constraints: topBox,
              buttonAlignment: Alignment.topCenter,
              buttonSize: buttonSize,
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
                child: buildPlayer(1,
                  constraints: bottomBox,
                  buttonAlignment: Alignment.topLeft,
                  buttonSize: buttonSize,
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: buildPlayer(0,
                  constraints: bottomBox,
                  buttonAlignment: Alignment.topRight,
                  buttonSize: buttonSize,
                ),
              ),
            ],),
          ),
        ],),
      );
    }

    return finishLayout(players, positionedButton, rotate, squadLayout, landscape);
  }

  Widget layout2Players(BuildContext context,{
    @required BoxConstraints constraints, 
    @required bool squadLayout,
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final bool landscape = w > h;
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
          child: buildPlayer(1,
            constraints: box,
            buttonAlignment: Alignment.topCenter,
            buttonSize: buttonSize,
          ),
        ),
        buildPlayer(0,
          constraints: box,
          buttonAlignment: Alignment.topCenter,
          buttonSize: buttonSize,
        ),
      ]),
    );
    final Widget positionedButton = Center(child: buildButton());

    return finishLayout(players, positionedButton, false, squadLayout, landscape);
  }

  Widget buildPlayer(int index, {
    @required BoxConstraints constraints,
    @required Size buttonSize,
    @required Alignment buttonAlignment,
  }) => SimplePlayerTile(
    index,
    onPosition: playerCallback(index),
    buttonAlignment: buttonAlignment,
    buttonSize: buttonSize,
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
  );

  @override
  Widget build(BuildContext context) {
    final bloc = widget.group.parent.parent;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor
        .withOpacity(widget.routeAnimationValue),
      child: SafeArea(
        top: true,
        child: WillPopScope(
          onWillPop: () async {
            if(bloc.game.gameAction.actionPending){
              bloc.scroller.cancel();
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
          child: bloc.settings.arenaSquadLayout.build((_, squadLayout)
            => LayoutBuilder(builder: (context, constraints){
              switch (widget.gameState.players.length) {
                case 2:
                  return layout2Players(context,
                    constraints: constraints,
                    squadLayout:squadLayout,
                  );
                  break;
                case 3:
                  return layout3Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                  );
                  break;
                case 4:
                  return layout4Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                  );
                  break;
                case 5:
                  return layout5Players(context,
                    constraints: constraints,
                    squadLayout: squadLayout,
                  );
                  break;
                default:
                  return Container();
              }
            }),
          ),
        ),
      ),
    );
  }
}