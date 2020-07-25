import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/resources/arena_layout/arena_layout_picker.dart';


class AboutCounterSpell extends StatelessWidget {

  const AboutCounterSpell();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final logic = CSBloc.of(context);

    return Section([
      const PanelTitle("About CounterSpell", centered: false,),
      RowOfExtraButtons(
        // margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        children: <Widget>[
          ExtraButton(
            icon: Icons.person_outline,
            text: "The developer",
            onTap: () => stage.showAlert(const Developer(), size: Developer.height),
          ),
          ExtraButton(
            icon: McIcons.file_document_box_check_outline,
            text: "Licenses",
            onTap: () => stage.showAlert(const AlertLicenses(), size: DamageInfo.height),
          ),
          ExtraButton(
            icon: McIcons.file_document_outline,
            text: "Changelog",
            onTap: logic.settings.showChangelog,
          ),
        ],
      ),
      CSWidgets.divider,
      ListTile(
        title: const Text("Tutorial"),
        leading: const Icon(Icons.help_outline),
        onTap: () => stage.showAlert(const AdvancedTutorial(), size: AdvancedTutorial.height),
      ),
      ListTile(
        title: const Text("Achievements"),
        leading: const Icon(McIcons.bookmark_check),
        onTap: () => stage.showAlert(const AchievementsAlert(), size: AchievementsAlert.height),
      ),
      ListTile(
        title: const Text("Test arena layout"),
        leading: const Icon(McIcons.null_icon),
        onTap: () => stage.showAlert(const ArenaLayoutAlert(), size: 900),
      ),
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