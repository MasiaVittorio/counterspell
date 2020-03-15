import 'package:counter_spell_new/core.dart';
import 'data/all.dart';

class AchievementAlert extends StatelessWidget {

  final Achievement achievement;

  static const double height = 550;

  const AchievementAlert(this.achievement);

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subhead;

    return HeaderedAlert(
      achievement.shortTitle,
      canvasBackground: true,
      alreadyScrollableChild: true,
      child: Padding(
        padding: const EdgeInsets.only(top: AlertTitle.height),
        child: Column(children: <Widget>[

          SubSection.stretch(<Widget>[
            const SectionTitle("Title"),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 6, 15, 9),
              child: Text(achievement.title, style: subhead),
            ),
          ], margin: const EdgeInsets.symmetric(horizontal: 15)),

          SubSection.stretch(<Widget>[
            const SectionTitle("Description"),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 6, 15, 9),
              child: Text(achievement.text, style: subhead),
            ),
          ], margin: const EdgeInsets.symmetric(horizontal: 15)),

          Expanded(child: SubSection.stretch(<Widget>[
            Expanded(child: achieveHints[achievement.shortTitle] ?? Container()),
          ]),),

        ].separateWith(CSWidgets.height15, alsoLast: true),),
      ),
    );
  }
}