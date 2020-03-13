import 'package:counter_spell_new/core.dart';

class TutorialUI extends StatelessWidget {
  const TutorialUI();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[

        const Expanded(child: const SubExplanation(
          icon: Icons.help_outline,
          title: "Getting back here",
          text: "To reopen this tutorial, just open up the menu and head for the \"Info\" section!",
        ),),

        const Expanded(child: const SubExplanation(
          icon: Icons.menu,
          title: "The main menu",
          text: "Opened by pressing the hamburger button or scrolling up the panel.",
        ),),

        const Expanded(child: const SubExplanation(
          icon: Icons.fullscreen,
          title: "The panel",
          text: "Alerts (like this one) are contained in an extended version of this app's main \"Panel\". You can often close them by scrolling down.",
        ),),

        // CSWidgets.height5,
        // _Title(Icons.space_bar, "Closed panel"),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //   child: Text("While the panel is closed down, it will show undo / re-do buttons and quick shortcuts that fit the page you're currently using.\n  (often, those actions are also found in the main menu in a larger and clearer layout)"),
        // ),
        // // ListTile(
        //   leading: Icon(McIcons.gesture_double_tap),
        //   title: Text("Just try stuff out!"),
        //   subtitle: Text("There's very little that can't be undone in CounterSpell, and when any action can be undesirable, it will prompt an alert that asks you for confirmation. So don't fear to try random buttons out if a shortcut doesn't have a label!"),
        // ),
      ].separateWith(CSWidgets.height15),
    );
  }
}

class SubExplanation extends StatelessWidget {

  final IconData icon;
  final String title;
  final String text;

  const SubExplanation({
    @required this.icon,
    @required this.title,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SubSection(<Widget>[
      _Title(icon, title),
      CSWidgets.divider,
      CSWidgets.height5,
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
          child: Text(text, style: TextStyle(fontSize: 15)),
        ),
      ),
    ], margin: EdgeInsets.zero,);
  }
}

class _Title extends StatelessWidget {

  final IconData icon;
  final String text;
  const _Title(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 3.0, 12.0, 3.0),
          child: Icon(icon),
        ),
        Text(text, style: Theme.of(context).textTheme.subhead,),
      ],),
    );
  }
}