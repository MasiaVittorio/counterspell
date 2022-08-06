import 'package:counter_spell_new/core.dart';


class TutorialHistory extends StatelessWidget {

  const TutorialHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? subhead = theme.textTheme.subtitle1;
    // final TextStyle body1 = theme.textTheme.bodyText2;

    return Center(
      child: ListTile(
        leading: const Icon(McIcons.gesture_swipe_horizontal),
        trailing: const Icon(Icons.grid_on),
        title: Text(
          "Everything is recored in an horizontal scrollable grid",
          style: subhead,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}