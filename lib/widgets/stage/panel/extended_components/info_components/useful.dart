import 'package:badges/badges.dart';
import 'package:counter_spell_new/core.dart';

class Useful extends StatelessWidget {
  const Useful();

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final stage = Stage.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PanelTitle("Useful", centered: false,),
        buttons(stage, logic, context),
        CSWidgets.height5,
        tutorial(logic),
      ],
    );
  }

  ExtraButtons buttons(StageData stage, CSBloc logic, BuildContext context) 
    => ExtraButtons(
      children: [
        ExtraButton(
          text: "Support",
          icon: Icons.attach_money,
          onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
        ),
        ExtraButton(
          customIcon: logic.badges.stuffILikeShown.build((_, __) => Badge(
            showBadge: logic.badges.stuffILikeBadge,
            badgeContent: null,
            toAnimate: false,
            shape: BadgeShape.circle,
            // alignment: Alignment.topRight,
            badgeColor: Theme.of(context).colorScheme.secondary,
            position: BadgePosition.topEnd(),
            ignorePointer: true,
            child: const Icon(Icons.star_border)
          ),),
          icon: null,
          text: "Stuff I like",
          onTap: logic.badges.showStuffILike,
        ),
        ExtraButton(
          icon: McIcons.bookmark_check,
          text: "Achievements",
          onTap: () => stage.showAlert(const AchievementsAlert(), size: AchievementsAlert.height),
        ),
      ],
    );

  SubSection tutorial(CSBloc logic) => SubSection([SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      ExtraButton.transparent(
        icon: Icons.help_outline,
        text: "Tutorial",
        shrinkWrap: true,
        onTap: (){
          logic.tutorial.showTutorial(0, full: true);
        }, 
      ),
      const Icon(Icons.keyboard_arrow_right),
      ...(<Widget>[for(int i=0; i<TutorialData.values.length; ++i)
        ExtraButton.transparent(
          onTap: (){
            logic.tutorial.showTutorial(i, full: false);
          }, 
          shrinkWrap: true,
          icon: TutorialData.values[i].icon,
          text: TutorialData.values[i].title,
        ),].separateWith(CSWidgets.width5)),
    ],),
  )]);
}

