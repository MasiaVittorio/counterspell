import 'package:badges/badges.dart';
import 'package:counter_spell_new/core.dart';

class Useful extends StatelessWidget {
  const Useful();

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final stage = Stage.of(context);

    return Section([
      const PanelTitle("Useful", centered: false,),
      SubSection([SingleChildScrollView(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ExtraButton(
            icon: Icons.help_outline,
            text: "Tutorial",
            onTap: (){
              // TODO: tutorial as a whole, to divide into sections
            },
            customCircleColor: Colors.transparent,
          ),
          const Icon(Icons.keyboard_arrow_right),
          ...(<Widget>[for(final data in TutorialData.values) //TODO: sections bloc, to integrate with badges bloc and stufffff
            ExtraButton(
              onTap: (){}, 
              icon: data.icon,
              text: data.title,
              customCircleColor: Colors.transparent,
            ),].separateWith(CSWidgets.width5)),
        ],),
        scrollDirection: Axis.horizontal,
      )]),
      CSWidgets.height5,
      ExtraButtons(
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
              badgeColor: Theme.of(context).accentColor,
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
        
      ),
    ]);
  }
}

