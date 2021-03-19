import 'package:counter_spell_new/business_logic/sub_blocs/scroller/scroller_generic.dart';
import 'package:counter_spell_new/core.dart';
import 'package:division/division.dart';
import '../all.dart';
import 'logic.dart';

class ManaPool extends GenericAlert {

  const ManaPool(): super(
    _RecentAction.height + __ManaPoolState.titleSize + 6 * 64,
    "Mana Pool",
    const {"Mana", "Pool"},
  );

  @override
  Widget build(BuildContext context) => _ManaPool(CSBloc.of(context));
}

class _ManaPool extends StatefulWidget {
  final CSBloc bloc;
  _ManaPool(this.bloc);

  @override
  __ManaPoolState createState() => __ManaPoolState();
}

class __ManaPoolState extends State<_ManaPool> with SingleTickerProviderStateMixin {

  AnimationController controller;

  MPLogic logic;

  @override
  void initState() {
    super.initState();
    logic = MPLogic(widget.bloc);

    this.initController();

    logic.localScroller.delayerController.addListenersMain(
      startListener: scrolling,
      endListener: leaving,
    );

  }

  @override
  void dispose() {
    logic.dispose();
    _disposeController();
    super.dispose();
  }

  void initController(){
    _disposeController();
    controller = AnimationController(
      duration: CSBloc.of(context).settings.scrollSettings.confirmDelay.value,
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    controller.addStatusListener(logic.localScroller.delayerAnimationListener);
  }

  bool scrolling(){
    if(!mounted) return false;
    if(controller.isAnimating && controller.velocity > 0)
      return true;
    if(controller.value == 1.0)
      return true;

    this.controller.fling();
    return true;
  }

  bool leaving() {
    if(!mounted) return false;
    if(this.controller.value == 0.0)
      return true;

    bool fling = false;
    if(this.controller.isAnimating){
      if(this.controller.velocity < 0)
        return true;
      fling = true;
    }
    _leaving(fling);
    return true;
  }

  void _leaving(bool withFling) async {
    if(!mounted) return;
    if(withFling) await  this.controller.fling();
    if(!mounted) return;
    this.controller.animateBack(0.0);
  }

  void _disposeController(){
    this.controller?.dispose();
    this.controller = null;
  }


  @override
  Widget build(BuildContext context) {
    return HeaderedAlertCustom(
      title, 
      titleSize: titleSize,
      child: pool,
      bottom: recentActions,
    );
  }

  static const double titleSize = 80;

  Widget get title => Material(
    elevation: 2,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AlertDrag(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: logic.show.build((_, show) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for(final color in Clr.values)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4,0,4,6),
                  child: _ColorToggle(
                    color,
                    onChanged: (v){
                      logic.show.edit((map) {
                        map[color] = v;
                      });
                      Stage.of(context).panelController.alertController
                        .recalcAlertSize(calcSize([
                          for(final c in Clr.values)
                            if(show[c]) c,
                        ].length));
                    },
                    value: show[color],
                  ),
                ),
            ],
          ),),
        ),
      ],
    ),
  );

  double calcSize(int shown) => _RecentAction.height + titleSize + shown * 64;

  Widget get pool => BlocVar.build3(
    logic.show,
    logic.pool,
    logic.selected,
    builder: (_, show, pool, selected) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for(final color in Clr.values)
          if(show[color])
            _ColorNumber(
              color, 
              scroller: logic.localScroller,
              value: pool[color],
              onPan: logic.onPan,
              selected: selected == color,
            ),
      ],
    ),
  );
  

  Widget get recentActions => logic.history.build((context, history) 
    => logic.show.build((_, show) => Row(children: [
      for(final child in [
        for(final action in history)
          if(show[action.color])
            _RecentAction(action, onTap: logic.apply),
      ]) Expanded(child: child),
      if(history.isEmpty) const SizedBox(height: _RecentAction.height),
    ]),),
  );
}



class _RecentAction extends StatelessWidget {
  static const double height = 60.0;
  final ManaAction action;
  final void Function(ManaAction) onTap;

  _RecentAction(this.action, {@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SubSection(
      [Container(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Icon(
              action.color.icon,
              color: action.color.color.withOpacity(0.4),
              size: 35,
            ),
            Center(child: Text(
              "${action.delta >= 0 ? '+' : ''}${action.delta}",
            ),),
          ],
        ),
      ),],
      color: false,
      crossAxisAlignment: CrossAxisAlignment.center,
      onTap: () => onTap(action),
      margin: EdgeInsets.zero,
    );
  }
}

class _ColorToggle extends StatelessWidget {

  final Clr color;
  final void Function(bool v) onChanged;
  final bool value;

  _ColorToggle(this.color, {
    @required this.onChanged,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color c = value 
      ? color.color 
      : Color.alphaBlend(
        theme.scaffoldBackgroundColor.withOpacity(0.5), 
        theme.canvasColor,
      );

    return Division(
      style: StyleClass()
        ..animate(150)
        ..width(50)
        ..height(50)
        ..borderRadius(all: 40)
        ..background.color(c)
        ..elevation(value ? 4:0)
        ..overflow.hidden(),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => onChanged(!value),
          child: Center(
            child: Icon(
              color.icon,
              size: 23,
              color: CSColors.contrastWith(c),
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorNumber extends StatelessWidget {

  final Clr color;
  final ScrollerLogic scroller;
  final int value;
  final void Function(Clr) onPan;
  final bool selected;

  _ColorNumber(this.color, {
    @required this.scroller,
    @required this.value,
    @required this.onPan,
    @required this.selected,
  });


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ConstrainedBox(
        constraints: constraints,
        child: VelocityPanDetector(
          onPanEnd: (_) => scroller.onDragEnd(),
          onPanCancel: scroller.onDragEnd,
          onPanUpdate: (details) {
            if(scroller.ignoringThisPan) return;
            onPan(color);
            scroller.onDragUpdate(
              details, 
              constraints.maxWidth, 
              vertical: false
            );
          },
          child: scroller.isScrolling.build((_, scrolling) 
            => scroller.intValue.build((_, increment){
              final textStyle = TextStyle(
                color: color.color.brightness.contrast, 
                fontSize: 0.26 * CSSizes.minTileSize,
              );

              return Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.keyboard_arrow_left),
                      Expanded(child: Center(child: CircleNumber(
                        size: 56,
                        value: value,
                        numberOpacity: 1.0,
                        open: scrolling && selected,
                        style: textStyle,
                        duration: CSAnimations.fast,
                        color: color.color,
                        increment: scrolling && selected ? increment : 0,
                        borderRadiusFraction: 1.0,
                        extraIcon: Icon(
                          color.icon,
                          color: Theme.of(context).canvasColor.withOpacity(0.7),
                          size: 30,
                        ),
                      ),),),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              );
            },),
          ),
        ),
      ),
    );
  }
}