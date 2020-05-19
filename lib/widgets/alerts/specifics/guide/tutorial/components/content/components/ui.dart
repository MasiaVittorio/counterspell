import 'package:counter_spell_new/core.dart';

class TutorialUI extends StatelessWidget {
  const TutorialUI();

  static const int flex = 5;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: flex - 1, child: SubExplanation(
          "Getting back here",
          separator: const Icon(Icons.keyboard_arrow_right),
          children: const <Widget>[
            ExtraButton(
              onTap: null,
              icon: Icons.menu,
              text: "Menu",
              forceExternalSize: true,
            ),
            ExtraButton(
              onTap: null,
              icon: Icons.info_outline,
              text: '"Info" tab',
              forceExternalSize: true,
            ),
            ExtraButton(
              onTap: null,
              icon: Icons.help_outline,
              text: "Tutorial",
              forceExternalSize: true,
            ),
          ],
        ),),

        Expanded(flex: flex-1, child: SubExplanation(
          "Opening the menu",
          separator: const Text("or"),
          children: const <Widget>[
            ExtraButton(
              onTap: null,
              icon: Icons.menu,
              text: "Tap the Icon",
              forceExternalSize: true,
            ),
            ExtraButton(
              onTap: null,
              icon: Icons.space_bar,
              text: 'Scroll up panel',
              forceExternalSize: true,
            ),
          ],
        ),),

        Expanded(flex: flex, child: SubExplanation(
          "The panel",
          separator: CSWidgets.extraButtonsDivider,
          children: const <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Alerts (like this) are shown in the panel", textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("You can close them by scrolling down", textAlign: TextAlign.center,),
            ),
          ],
        ),),

      ].separateWith(CSWidgets.height15),
    );
  }
}


class SubExplanation extends StatelessWidget {
  final List<Widget> children;
  final Widget separator;
  final String title;

  const SubExplanation(this.title, {
    @required this.children,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subtitle1;

    List<Widget> rowChildren = <Widget>[
      for(final child in children)
        Expanded(child: child,)
    ];

    if(this.separator != null){
      rowChildren = rowChildren.separateWith(this.separator);
    }

    return SubSection.withoutMargin(<Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(title, style: subhead,),
      ),
      CSWidgets.divider,
      Expanded(child: 
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(children: rowChildren,),
          ),
        ),
      ),
    ], crossAxisAlignment: CrossAxisAlignment.center,);
  }
}

// class SubExplanation extends StatelessWidget {

//   final IconData icon;
//   final String title;
//   final String text;

//   const SubExplanation({
//     @required this.icon,
//     @required this.title,
//     @required this.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SubSection(<Widget>[
//       _Title(icon, title),
//       CSWidgets.divider,
//       CSWidgets.height5,
//       SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
//           child: Text(text, style: TextStyle(fontSize: 15)),
//         ),
//       ),
//     ], margin: EdgeInsets.zero,);
//   }
// }

// class _Title extends StatelessWidget {

//   final IconData icon;
//   final String text;
//   const _Title(this.icon, this.text);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Row(children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12.0, 3.0, 12.0, 3.0),
//           child: Icon(icon),
//         ),
//         Text(text, style: Theme.of(context).textTheme.subtitle1,),
//       ],),
//     );
//   }
// }