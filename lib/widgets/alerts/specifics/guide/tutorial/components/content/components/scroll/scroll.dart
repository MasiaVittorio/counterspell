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
  bool scrolled = false;

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
      
      Expanded(child: SubSection(<Widget>[
        Expanded(child: Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: Text(
            "Scroll horizontally to increase or decrease the number",
            style: theme.textTheme.subhead,
            textAlign: TextAlign.center,
          ),),
        ),),),
        CSWidgets.divider,
        CSWidgets.height10,
        LocalNumber(localScroller, widget.bloc, value, () {
          if(this.mounted && scrolled == false)
            this.setState((){
              scrolled = true;
            });
        }),
        CSWidgets.height20,
        // Expanded(child: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Center(child: Text(
        //     "The change is applied after a short delay",
        //     style: theme.textTheme.subhead,
        //     textAlign: TextAlign.center,
        //   ),),
        // ),),
      ], margin: EdgeInsets.zero,),),

      CSWidgets.height10,

      Expanded(child: SubSection(<Widget>[
        // Expanded(child: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Center(child: AnimatedOpacity(
        //     duration: CSAnimations.fast,
        //     opacity: scrolled ? 1.0 : 0.0,
        //     child: Text(
        //       "(If you scroll again before the delay expires, you'll gain more time!)",
        //       textAlign: TextAlign.center,
        //     ),
        //   ),),
        // ),),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: AnimatedOpacity(
            duration: CSAnimations.fast,
            opacity: scrolled ? 1.0 : 0.0,
            child: Text(
              "The change is applied after a short delay",
              style: theme.textTheme.subhead,
              textAlign: TextAlign.center,
            ),
          ),),
        ),),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
            child: LocalDelayer(localScroller, widget.bloc),
          ),
        ),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: AnimatedOpacity(
            duration: CSAnimations.fast,
            opacity: scrolled ? 1.0 : 0.0,
            child: Text(
              "(You can scroll multiple times before it expires)",
              textAlign: TextAlign.center,
            ),
          ),),
        ),),
      ], margin: EdgeInsets.zero,),),

    ]);
  }
}
