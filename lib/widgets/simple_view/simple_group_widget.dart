import 'package:counter_spell_new/business_logic/sub_blocs/game/sub_game_blocs/game_group.dart';
import 'package:counter_spell_new/game_model/game_state.dart';
import 'package:counter_spell_new/game_model/player_action.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/ui_model/ui_model.dart';
import 'package:counter_spell_new/widgets/simple_view/simple_player_tile.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';

class SimpleGroupWidget extends StatefulWidget {
  final GameState gameState;
  final Map<String,bool> selectedNames;
  final bool isScrollingSomewhere;
  final int increment;
  final CSGameGroup group;
  // final CSTheme theme;
  final Map<CSPage,Color> pageColors;
  final Map<String,PlayerAction> normalizedPlayerActions;

  final double routeAnimationValue;

  final Map<int, String> initialNameOrder;

  final void Function(Map<int,String>) onPositionNames;

  const SimpleGroupWidget({
    @required this.pageColors,
    // @required this.theme,
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
  _SimpleGroupWidgetState createState() => _SimpleGroupWidgetState();
}

class _SimpleGroupWidgetState extends State<SimpleGroupWidget> {

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
  
  @override
  void didUpdateWidget(SimpleGroupWidget oldWidget){
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
  //TODO: delayer sincronizzato

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
    Widget centerChild;

    if(indexToName.values.any((v) => v == null)){
      centerChild = const Icon(
        Icons.close,
        key: ValueKey("simplegroup_button_exit"),
      );
      centerTap = Navigator.of(context).pop;
    } else if(widget.isScrollingSomewhere){
      centerChild = Icon(
        Icons.close,
        key: ValueKey("simplegroup_button_Cancel_scrolling"),
      );
      centerTap = bloc.scroller.cancel;
    } else {
      centerChild = ImplicitlyAnimatedIcon(
        key: ValueKey("simplegroup_button_animated_icon"),
        state: open,
        icon: AnimatedIcons.menu_close,
        duration: MyDurations.fast,
      );
      centerTap = ()=> this.setState((){
        open = !open;
      });
    }
    assert(centerChild != null);
    assert(centerTap != null);

    return Opacity(
      opacity: widget.routeAnimationValue,
      child: Material(
        animationDuration: MyDurations.fast,
        elevation: open ? 10 : 4,
        borderRadius: BorderRadius.circular(_buttonSize/2),
        child: InkWell(
          onTap: centerTap,
          onLongPress: Navigator.of(context).pop,
          borderRadius: BorderRadius.circular(_buttonSize/2),
          child: Container(
            alignment: Alignment.center,
            width: _buttonSize,
            height: _buttonSize,
            child: AnimatedSwitcher(
              duration: MyDurations.fast,
              child:centerChild,
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
          duration: MyDurations.fast,
          color: Theme.of(context).scaffoldBackgroundColor
            .withOpacity(open ? 0.7 : 0.0),
        ),
      ),
    ),);
  }

  Widget buildButtons(){
    return AnimatedPositioned(
      duration: MyDurations.fast,
      bottom: (open ? 0.0 : - 120) - 120 * (1 -widget.routeAnimationValue),
      left: 0.0,
      right: 0.0,
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
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text("Back to full power"),
                onTap: Navigator.of(context).pop,
              ),
              ListTile(
                leading: Icon(McIcons.account_group_outline),
                title: Text("Reorder players"),
                onTap: () => this.setState((){
                  this.resetNames();
                  this.widget.onPositionNames(this.indexToName);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget finishLayout(Widget players, Widget positionedButton){
    assert(positionedButton != null);
    assert(players != null);
    return Stack(children: <Widget>[
      Positioned.fill(child: players,),
      buildBarrier(),
      positionedButton,
      buildButtons(),
    ]);
  }

  Widget layout4Players(BuildContext context,{
    @required BoxConstraints constraints, 
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final landscape = w >= h;
    Widget players;
    Widget positionedButton;
    if(landscape){
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

    return finishLayout(players, positionedButton);
  }

  Widget layout3Players(BuildContext context,{
    @required BoxConstraints constraints, 
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final landscape = w >= h;
    Widget players;
    Widget positionedButton;
    if(landscape){
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
      positionedButton = Positioned(
        top: 0.0,
        right: 0.0,
        left: 0.0,
        height: y*2,
        child: Center(child: buildButton()),
      );
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

    return finishLayout(players, positionedButton);
  }

  Widget layout2Players(BuildContext context,{
    @required BoxConstraints constraints, 
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

    return finishLayout(players, positionedButton);
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

            return true;
          },
          child: LayoutBuilder(builder: (context, constraints){
            switch (widget.gameState.players.length) {
              case 2:
                return layout2Players(context,
                  constraints: constraints,
                );
                break;
              case 3:
                return layout3Players(context,
                  constraints: constraints,
                );
                break;
              case 4:
                return layout4Players(context,
                  constraints: constraints,
                );
                break;
              default:
                return Container();
            }
          }),
        ),
      ),
    );
  }
}