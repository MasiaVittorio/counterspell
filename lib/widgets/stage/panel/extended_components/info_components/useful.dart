import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/resources/highlightable/highlightable.dart';

class Useful extends StatelessWidget {
  const Useful();

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final stage = Stage.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PanelTitle("About CounterSpell", centered: false,),
        const Space.vertical(5),
        tutorial(logic),
        const Space.vertical(10),
        ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right),
          title: const Text("Badges"),
          leading: const Icon(McIcons.bookmark_check),
          onTap: () => stage.showAlert(const AchievementsAlert(), size: AchievementsAlert.height),
        ),
      ],
    );
  }

  Widget tutorial(CSBloc logic) => SubSection([Highlightable(
    controller: logic.tutorial.tutorialHighlight,
    radius: 10,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        ButtonTile.transparent(
          icon: Icons.help_outline,
          text: "Full tutorial",
          shrinkWrap: true,
          onTap: (){
            logic.tutorial.showTutorial(null);
          }, 
        ),
        const Icon(Icons.keyboard_arrow_right),
        ...(<Widget>[for(int i=0; i<TutorialData.values.length; ++i)
          ButtonTile.transparent(
            onTap: (){
              logic.tutorial.showTutorial(i);
            }, 
            shrinkWrap: true,
            icon: TutorialData.values[i].icon,
            text: TutorialData.values[i].title,
          ),].separateWith(CSWidgets.width5)),
      ],),
  ),),]);
}

