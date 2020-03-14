import 'package:counter_spell_new/core.dart';


class TutorialCounters extends StatelessWidget {

  const TutorialCounters();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subhead;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          "Independently tracks a variety of different counters",
          style: subhead,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}