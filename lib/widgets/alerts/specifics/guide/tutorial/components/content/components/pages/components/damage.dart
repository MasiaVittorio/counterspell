import 'package:counter_spell_new/core.dart';


class TutorialDamage extends StatelessWidget {

  const TutorialDamage();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subhead;

    return Column(
      children: <Widget>[
        for(final child in <Widget>[
          RichText(
            text: TextSpan(
              style: subhead,
              children: <TextSpan>[
                TextSpan(text: "Tap", style: TextStyle(fontWeight: subhead.fontWeight.increment.increment)),
                const TextSpan(text: " on the "),
                TextSpan(text: "attacker", style: TextStyle(fontWeight: subhead.fontWeight.increment.increment)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
              style: subhead,
              children: <TextSpan>[
                TextSpan(text: "Scroll", style: TextStyle(fontWeight: subhead.fontWeight.increment.increment)),
                const TextSpan(text: " on the "),
                TextSpan(text: "defender", style: TextStyle(fontWeight: subhead.fontWeight.increment.increment)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ])
          Expanded(child: Center(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: child,
          )),)
      ],
    );
  }
}