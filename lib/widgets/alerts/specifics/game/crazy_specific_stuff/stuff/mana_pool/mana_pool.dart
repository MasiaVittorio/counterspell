import 'package:counter_spell_new/core.dart';
import '../all.dart';
import 'logic.dart';

class ManaPool extends GenericAlert {

  const ManaPool(): super(
    500,
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

class __ManaPoolState extends State<_ManaPool> {

  MPLogic logic;

  @override
  void initState() {
    super.initState();
    logic = MPLogic(widget.bloc);
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return HeaderedAlertCustom(
      title, 
      titleSize: 60, //TODO: tweak
      child: pool,
      bottom: recentActions,
    );
  }

  Widget get title => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const AlertDrag(),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: logic.show.build((_, show) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for(final color in Clr.values)
              _ColorToggle(
                color,
                onChanged: (v) => logic.show.edit((map) {
                  map[color] = v;
                }),
                value: show[color],
              ),
          ],
        ),),
      ),
    ],
  );

  Widget get pool => logic.show.build((_, show) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for(final color in Clr.values)
        if(show[color])
          _ColorNumber(color, scroller: logic.localScroller),
    ],
  ),);

  Widget get recentActions => logic.history.build((context, history) 
    => Row(children: [
      for(final child in [
        for(final action in history)
          _RecentAction(action, onTap: logic.apply),
      ]) Expanded(child: child),
    ]),
  );
}



class _RecentAction extends StatelessWidget {
  final ManaAction action;
  final void Function(ManaAction) onTap;

  _RecentAction(this.action, {@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      /* ... */
      // TODO: do
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
    return Container(
      /* ... */
      // TODO: do
    );
  }
}

class _ColorNumber extends StatelessWidget {

  final Clr color;
  final CSScroller scroller;

  _ColorNumber(this.color, {@required this.scroller});

  @override
  Widget build(BuildContext context) {
    return Container(
      /* ... */
      // TODO: do
    );
  }
}