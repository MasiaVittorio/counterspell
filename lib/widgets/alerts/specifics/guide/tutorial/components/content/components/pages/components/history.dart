import 'package:counter_spell_new/core.dart';


class TutorialHistory extends StatelessWidget {

  const TutorialHistory();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subhead;
    // final TextStyle body1 = theme.textTheme.body1;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          "Everything is recored in an horizontal scrollable list",
          style: subhead,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}