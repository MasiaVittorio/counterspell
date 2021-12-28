import 'package:counter_spell_new/core.dart';


class TutorialDamage extends StatelessWidget {

  const TutorialDamage();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subtitle1!;
    final StageData<CSPage,SettingsPage> stage = Stage.of(context) as StageData<CSPage, SettingsPage>;
    final Map<CSPage,Color?> colors = stage.themeController.derived.mainPageToPrimaryColor.value!;
    final CSBloc bloc = CSBloc.of(context)!;
    final Color defenceColor = bloc.themer.defenceColor.value;

    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(McIcons.gesture_tap, color: colors[CSPage.commanderDamage],),
          trailing: Icon(CSIcons.attackOne, color: colors[CSPage.commanderDamage],),
          title: RichText(
            text: TextSpan(
              style: subhead,
              children: <TextSpan>[
                TextSpan(text: "Tap", style: TextStyle(fontWeight: subhead.fontWeight!.increment.increment)),
                const TextSpan(text: " on the "),
                TextSpan(text: "attacker", style: TextStyle(fontWeight: subhead.fontWeight!.increment.increment)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ListTile(
          leading: Icon(McIcons.gesture_swipe_horizontal, color: defenceColor,),
          trailing: Icon(CSIcons.defenceFilled, color: defenceColor,),
          title: RichText(
            text: TextSpan(
              style: subhead,
              children: <TextSpan>[
                TextSpan(text: "Scroll", style: TextStyle(fontWeight: subhead.fontWeight!.increment.increment)),
                const TextSpan(text: " on the "),
                TextSpan(text: "defender", style: TextStyle(fontWeight: subhead.fontWeight!.increment.increment)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }
}