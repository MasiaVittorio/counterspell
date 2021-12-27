import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/components/all.dart';

class ArenaWidget extends StatefulWidget {

  const ArenaWidget({
    required this.logic,
  });

  static const Set<int> okNumbers = <int>{2,3,4,5,6};

  final CSBloc? logic;

  @override
  _ArenaWidgetState createState() => _ArenaWidgetState();

  static const double buttonDim = 56.0;
  static const Size buttonSize = Size(buttonDim,buttonDim);

}

class _ArenaWidgetState extends State<ArenaWidget> {

  bool open = false;

  CSBloc? get logic => widget.logic;
  CSSettings? get settings => logic!.settings;
  CSSettingsArena get arenaSettings => settings!.arenaSettings;
  CSGame? get gameLogic => logic!.game;
  CSGameState? get stateLogic => gameLogic!.gameState;
  CSGameAction? get actionLogic => gameLogic!.gameAction;
  CSGameGroup? get groupLogic => gameLogic!.gameGroup;

  void exit() => Navigator.of(context).pop();
  
  double get _buttonSize => ArenaWidget.buttonDim;
  Size get buttonSize => ArenaWidget.buttonSize;

  Widget get buildBarrier => IgnorePointer(
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
  );

  @override
  Widget build(BuildContext context) {
    final StageData<CSPage,SettingsPage>? stage = Stage.of(context);
    final theme = Theme.of(context);
    final arenaBloc = logic!.settings!.arenaSettings;
    final scrollerBloc = logic!.scroller;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        top: true,
        child: WillPopScope(
          onWillPop: () => decidePop(stage),
          child: LayoutBuilder(builder: (context, constraints)
          => ConstrainedBox(
            constraints: constraints,
            child: arenaBloc.layoutType   .build((context, layoutType) 
              => groupLogic!.arenaNameOrder.build((context, positions) 
              => groupLogic!.names         .build((context, names) 
              => arenaBloc.flipped        .build((context, flipped) 
              => StageBuild.offMainPage<CSPage>((_, page) 
              => scrollerBloc!.isScrolling .build((context, scrolling) 
              => ArenaLayout(
                  flipped: flipped[layoutType],
                  howManyChildren: names.length,
                  layoutType: layoutType!,
                  animateCenterWidget: true,
                  centerAlignment: open 
                    ? ArenaCenterAlignment.screen
                    : ArenaCenterAlignment.intersection,
                  childBuilder: (_, i, al) => ArenaPlayerTile(
                    i,
                    page: page,
                    buttonAlignment: al ?? Alignment.topCenter,
                    indexToName: positions,
                    isScrollingSomewhere: scrolling,
                    logic: logic,
                  ),
                  betweenGridAndCenter: buildBarrier,
                  centerChildBuilder: (_, axis) => buildButton(
                    constraints, 
                    page, 
                    axis, 
                    positions, 
                    scrolling, 
                    names,
                    layoutType,
                    flipped,
                  ),
                ),
              ),
            ))))
          ))),
        ),
      ),
    );
  }


  Future<bool> decidePop(StageData<CSPage,SettingsPage>? stage) async {
            
    if (logic!.game!.gameAction.actionPending) {
      logic!.scroller!.cancel(true);
      stage!.mainPagesController.goToPage(CSPage.life);
      return false;
    } 

    if(open){
      this.setState((){
        open = false;
      });
      return false;
    }

    return true;
  }


  Widget buildButton(
    BoxConstraints screenConstraints, 
    CSPage page, 
    Axis undoRedoAxis,
    Map<int,String?> indexToName,
    bool isScrollingSomewhere,
    List<String> names,
    ArenaLayoutType? layoutType,
    Map<ArenaLayoutType?,bool> flipped,
  ){
    final Widget button = ArenaMenuButton(
      names: names,
      flipped: flipped,
      page: page,
      logic: logic, 
      positions: indexToName, 
      isScrollingSomewhere: isScrollingSomewhere,
      open: open, 
      layoutType: layoutType,
      openMenu: () {
        logic!.stage!.mainPagesController.goToPage(CSPage.life);
        logic!.scroller!.cancel(true);
        this.setState((){
          open = true;
        });
      }, 
      closeMenu: () => this.setState(() {
        open = false;
      }),
      buttonSize: _buttonSize, 
      exit: exit,
      reorderPlayers: () => this.setState((){
        open = false;
        groupLogic!.arenaNameOrder.set(<int,String?>{
          for(final key in groupLogic!.arenaNameOrder.value.keys)
            key: null,
        });
      }),
      screenConstraints: screenConstraints,
    );


    final Widget delayer = logic!.settings!.scrollSettings.confirmDelay.build((context, delay) 
      => ArenaDelayer(
        onManualCancel: logic!.scroller!.cancel, 
        onManualConfirm: logic!.scroller!.forceComplete, 
        delayerController: logic!.scroller!.delayerController, 
        duration: delay, 
        color: Theme.of(context).colorScheme.onSurface,
        animationListener: logic!.scroller!.delayerAnimationListener,
      ),
    );

    final Widget undoRedo = ArenaUndo(
      undoRedoAxis: undoRedoAxis, 
      open: open,
      scrollingSomewhere: isScrollingSomewhere,
    );

    return Stack(children: <Widget>[
      Center(child: undoRedo),
      Center(child: delayer),
      Center(child: button),
    ],);
  }


}
