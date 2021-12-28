import 'package:counter_spell_new/core.dart';

//position, size, dragUpdate, dragEnd, menuButton
class CSTopBarTitle extends StatelessWidget {
  const CSTopBarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);
    return StageBuild.offMainPage((_, dynamic page) => BlocVar.build2<Counter,bool>(
      bloc!.game.gameAction.counterSet.variable,
      stage!.panelController.isMostlyOpenedNonAlert,
      builder: (_, counter, openNonAlert,){
        String? text = "";
        if(openNonAlert){
          text = "CounterSpell";
        } else if(page == CSPage.counters){
          text = counter.longName;
        } else {
          text = CSPages.longTitleOf(page);
        }

        return AnimatedText(
          text!,
          duration: const Duration(milliseconds: 260),
          // style: Theme.of(context).primaryTextTheme.headline6.copyWith(
          //   fontWeight: FontWeight.w600,
          //   color: DefaultTextStyle.of(context).style.color,
          // ),
        );
      },
    ),);
  }

}


