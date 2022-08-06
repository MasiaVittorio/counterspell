import 'package:counter_spell_new/business_logic/sub_blocs/scroller/scroller_generic.dart';
import 'package:counter_spell_new/core.dart';
import 'components/all.dart';

class TutorialScroll extends StatelessWidget {
  const TutorialScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return _Local(CSBloc.of(context));
  }
}


class _Local extends StatefulWidget {

  const _Local(this.bloc);
  final CSBloc? bloc;

  @override
  __LocalState createState() => __LocalState();
}

class __LocalState extends State<_Local> {

  ScrollerLogic? localScroller;
  int value = 40;
  bool scrolled = false;

  @override
  void initState() {
    super.initState();
    localScroller = ScrollerLogic(
      okVibrate: () => widget.bloc!.settings.appSettings.canVibrate! 
        && widget.bloc!.settings.appSettings.wantVibrate.value,
      onCancel: null,
      scrollSettings: widget.bloc!.settings.scrollSettings,
      resetAfterConfirm: true,
      onConfirm: (increment){
        if(mounted) {
          setState((){
            value += increment;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    localScroller!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    final ThemeData theme = Theme.of(context); 
    final TextStyle subhead = theme.textTheme.subtitle1!;

    

    return Column(children: <Widget>[
      
      Expanded(child: SubSection(<Widget>[
        Expanded(child: Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: RichText(
            text: TextSpan(
              style: subhead,
              children: <TextSpan>[
                const TextSpan(text: "Scroll "),
                TextSpan(text: "horizontally", style: TextStyle(fontWeight: subhead.fontWeight!.increment.increment)),
                const TextSpan(text: " to increase or decrease the number"),
              ],
            ),
            textAlign: TextAlign.center,
          ),),
        ),),),
        CSWidgets.divider,
        CSWidgets.height10,
        LocalNumber(localScroller as CSScroller?, widget.bloc, value, () {
          if(mounted && scrolled == false) {
            setState((){
              scrolled = true;
            });
          }
        }),
        CSWidgets.height20,
      ], margin: EdgeInsets.zero,),),

      CSWidgets.height10,

      Expanded(child: SubSection(<Widget>[
        Expanded(child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(child: AnimatedOpacity(
            duration: CSAnimations.fast,
            opacity: scrolled ? 1.0 : 0.0,
            child: Text(
              "The change is applied after a delay",
              style: theme.textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ),),
        ),),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Material(
            elevation: 2,
            // color: Color.alphaBlend(
            //   SubSection.getColor(theme),
            //   theme.canvasColor,
            // ),
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(120),
            child: LocalDelayer(localScroller as CSScroller?, widget.bloc),
          ),
        ),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(child: AnimatedOpacity(
            duration: CSAnimations.fast,
            opacity: scrolled ? 1.0 : 0.0,
            child: const Text(
              "(You can keep scrolling before it expires)",
              textAlign: TextAlign.center,
            ),
          ),),
        ),),
      ], margin: EdgeInsets.zero,),),

    ]);
  }
}
