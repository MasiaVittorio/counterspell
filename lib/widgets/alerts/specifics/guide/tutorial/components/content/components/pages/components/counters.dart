import 'package:counter_spell_new/core.dart';


class TutorialCounters extends StatelessWidget {

  const TutorialCounters();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subtitle1!;

    return IconTheme.merge(
      data: IconThemeData(opacity: 0.63),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: RichText(
              text: TextSpan(
                style: subhead,
                children: <TextSpan>[
                  TextSpan(text: "Independently", style: TextStyle(fontWeight: subhead.fontWeight!.increment.increment)),
                  const TextSpan(text: " tracks a variety of different counters"),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                for(final counter in Counter.defaultList)
                  Icon(counter.icon)
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}