import 'package:counter_spell_new/core.dart';

class SnackCounterSelector extends StatelessWidget {
  const SnackCounterSelector();
  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    return LayoutBuilder(builder: (_, constraints)
      => _SnackCounterSelector(
        height: constraints.maxHeight,
        width: constraints.maxWidth, 
        elements: bloc.game.gameAction.counterSet.list,
        initialIndex: bloc.game.gameAction.counterSet.index,
      ),
    );
  }
}

class _SnackCounterSelector extends StatefulWidget {
  const _SnackCounterSelector({
    @required this.width,
    @required this.height,
    @required this.elements,
    @required this.initialIndex,
  });

  final double height;
  final double width;
  final List<Counter> elements;
  final int initialIndex;

  @override
  _SnackCounterSelectorState createState() => _SnackCounterSelectorState();
}

class _SnackCounterSelectorState extends State<_SnackCounterSelector> with SingleTickerProviderStateMixin {

  AnimationController animationController;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(
      initialScrollOffset: initialScrollOffset,
    );
    animationController = AnimationController(
      vsync: this, 
      value: 0,
      upperBound: 1.5,
      duration: const Duration(milliseconds: 800),
    );
    this.prepare();
    //TODO: modo di calcolare l'offset iniziale
  }

  void prepare(){
    animationController.animateTo(1, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    this.animationController?.dispose();
    this.scrollController?.dispose();
    super.dispose();
  }

  //make the selected element visible at start
  double get initialScrollOffset => (initialElementOffset - visibleWidth + elementWidth)
      .clamp(0.0, maxOffset);
  double get initialElementOffset => elementOffset(widget.initialIndex) * 1.0;
  double elementOffset(int index) => elementWidth * index *1.0;
  double get elementWidth => widget.height + 5.0;
  double get maxOffset => widget.elements.length * elementWidth * 1.0 - visibleWidth;
  double get visibleWidth => widget.width - widget.height;
  //the snackbar is occupied by the closing button at the right, but you can paint content below it

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final CSGameAction gameAction = bloc.game.gameAction;

    final Widget child = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      physics: Stage.of(context).snackBarScrollPhysics(),
      child: gameAction.counterSet.build((_, current) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final counter in gameAction.counterSet.list)
            IconTheme.merge(
              data: IconThemeData(
                opacity: counter == current ? 1.0 : 0.65,
              ),
              child: StageSnackBarButton(
                onTap: () => gameAction.counterSet.chooseElement(counter), 
                icon: Icon(counter.icon, size: counter == current ? 25 : 23),
                accent: counter == current,
                // autoClose: false,
              ),
            ),
          StageSnackBarButton.placeHolder(),
        ].separateWith(CSWidgets.width5),
      ),),
    );

    return AnimatedBuilder(
      animation: animationController,
      child: child,
      builder: (_, child)
        => Transform.translate(
          offset: Offset((1 - animationController.value) * 200, 0),
          child: child,
        ),
    );
  }
}