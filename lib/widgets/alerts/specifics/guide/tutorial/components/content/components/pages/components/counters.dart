import 'package:counter_spell_new/core.dart';


class TutorialCounters extends StatelessWidget {

  const TutorialCounters({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.titleMedium!;

    return IconTheme.merge(
      data: const IconThemeData(opacity: 0.63),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                for(final counter in Counter.defaultList)
                  Icon(counter.icon)
              ],
            ),
          ),
        ],
      ),
    );
  }
}