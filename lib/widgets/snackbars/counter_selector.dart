import 'package:counter_spell_new/core.dart';

class SnackCounterSelector extends StatefulWidget {
  const SnackCounterSelector();

  @override
  _SnackCounterSelectorState createState() => _SnackCounterSelectorState();
}

class _SnackCounterSelectorState extends State<SnackCounterSelector> with SingleTickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this, 
      value: 0,
      upperBound: 1.5,
      duration: const Duration(milliseconds: 800),
    );
    this.prepare();
  }

  void prepare(){
    controller.animateTo(1, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    this.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final CSGameAction gameAction = bloc.game.gameAction;

    final Widget child = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
      animation: controller,
      child: child,
      builder: (_, child)
        => Transform.translate(
          offset: Offset((1 - controller.value) * 200, 0),
          child: child,
        ),
    );
  }
}