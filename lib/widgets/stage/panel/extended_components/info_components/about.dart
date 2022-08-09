import 'package:badges/badges.dart';
import 'package:counter_spell_new/core.dart';

class AboutCounterSpell extends StatelessWidget {

  const AboutCounterSpell();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final logic = CSBloc.of(context);

    return Section([
      const PanelTitle("About CounterSpell", centered: false,),
      ButtonTilesRow(
        // margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        children: <Widget>[
          ButtonTile(
            icon: null,
            customIcon: logic.badges.versionShown.build((_, __) => Badge(
              showBadge: logic.badges.changelogBadge,
              badgeContent: null,
              toAnimate: false,
              shape: BadgeShape.circle,
              // alignment: Alignment.topRight,
              badgeColor: Theme.of(context).colorScheme.secondary,
              position: BadgePosition.topEnd(),
              ignorePointer: true,
              child: const Icon(McIcons.file_document_outline),
            ),),
            text: "Changelog",
            onTap: logic.badges.showChangelog,
          ),
          ButtonTile(
            icon: Icons.help_outline,
            text: "Tutorial",
            onTap: () => stage!.showAlert(const AdvancedTutorial(), size: AdvancedTutorial.height),
          ),
          ButtonTile(
            icon: McIcons.bookmark_check,
            text: "Achievements",
            onTap: () => stage!.showAlert(const AchievementsAlert(), size: AchievementsAlert.height),
          ),
        ],
      ),

      SubSection(<Widget>[
        ButtonTilesRow(
          margin: EdgeInsets.zero,
          children: <Widget>[
            // ExtraButton(
            //   icon: Icons.person_outline,
            //   text: "Developer",
            //   onTap: () => stage.showAlert(const Developer(), size: Developer.height),
            //   customCircleColor: Colors.transparent,
            // ),
            ButtonTile.transparent(
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
            ButtonTile.transparent(
              icon: McIcons.text_box_check_outline,
              text: "Licenses",
              onTap: () => stage!.showAlert(const AlertLicenses(), size: DamageInfo.height),
            ),
          ],
        ),
      ],margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),),

    ]);
  }
}


// class IconsAlert extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return HeaderedAlert(
//       "icons",
//       child: Wrap(children: <Widget>[
//         for(final icon in <IconData>[
//           ManaIcons.artifact,
//           ManaIcons.artist_brush,
//           ManaIcons.artist_nib,
//           ManaIcons.c,
//           ManaIcons.chaos,
//           ManaIcons.dfc_day,
//           ManaIcons.dfc_enchantment,
//           ManaIcons.dfc_enchantment,
//           ManaIcons.dfc_ignite,
//           ManaIcons.dfc_moon,
//           ManaIcons.dfc_night,
//           ManaIcons.s,
//           ManaIcons.r,
//           ManaIcons.e,
//           // ManaIcons,
//           // ManaIcons,
//           // ManaIcons,
//           // ManaIcons,
//         ]) Icon(icon),
//       ],),
//     );
//   }
// }