import 'package:counter_spell_new/core.dart';
import 'components/all.dart';

class TutorialScroll extends StatelessWidget {
  const TutorialScroll();

  @override
  Widget build(BuildContext context) {
    return _Local(CSBloc.of(context));
  }
}


class _Local extends StatefulWidget {

  _Local(this.bloc);
  final CSBloc bloc;

  @override
  __LocalState createState() => __LocalState();
}

class __LocalState extends State<_Local> {

  CSScroller localScroller;
  int value = 40;

  @override
  void initState() {
    super.initState();
    this.localScroller = CSScroller(this.widget.bloc, tutorialConfirm: (increment){
      if(this.mounted)
        this.setState((){
          this.value += increment;
        });
    });
  }


  @override
  Widget build(BuildContext context) {
    
    final ThemeData theme = Theme.of(context); 

    return Column(children: <Widget>[
      Expanded(child: Center(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Scroll horizontally to increase or decrease the number",
          style: theme.textTheme.subhead,
          textAlign: TextAlign.center,
        ),
      ),),),
      CSWidgets.divider,
      CSWidgets.height15,
      LocalNumber(localScroller, widget.bloc, value),
      CSWidgets.height15,
      CSWidgets.divider,
      Expanded(child: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "The change is applied after a short delay",
              style: theme.textTheme.subhead,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "(If you scroll again before the delay expires, you'll gain more time!)",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),),),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: LocalDelayer(localScroller, widget.bloc),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "(You can also manually cancel or confirm an action before the delay expires)",
          textAlign: TextAlign.center,
        ),
      ),
    ],);
  }
}
