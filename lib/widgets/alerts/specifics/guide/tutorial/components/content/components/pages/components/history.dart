import 'package:counter_spell_new/core.dart';


class TutorialHistory extends StatelessWidget {

  const TutorialHistory();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subhead;
    // final TextStyle body1 = theme.textTheme.body1;

    return Center(
      child: ListTile(
        leading: Icon(McIcons.gesture_swipe_horizontal),
        trailing: Icon(Icons.grid_on),
        title: Text(
          "Everything is recored in an horizontal scrollable grid",
          style: subhead,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}