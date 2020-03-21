import 'package:counter_spell_new/core.dart';

class TheRoller extends StatelessWidget {
  const TheRoller();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final child in <Widget>[

            Row(children: <Widget>[
              for(final child in const <Widget>[
                ExtraButton(
                  onTap: null,
                  text: "Open the menu",
                  icon: Icons.menu,
                ),
                Text("(or scroll up the panel)"),
              ])
                Expanded(child: Center(child: child),),
            ].separateWith(CSWidgets.width15),),

            Row(children: <Widget>[
              for(final child in const <Widget>[
                ExtraButton(
                  onTap: null,
                  icon: Icons.menu,
                  text: '"Game" tab',
                ),
                Text("(it's the default one)")
              ])
                Expanded(child: Center(child: child),),
            ].separateWith(CSWidgets.width15),),

            ExtraButton(
              onTap: null,
              text: '"Random" button',
              icon: McIcons.dice_multiple,
            ),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: child,
            )
        ].separateWith(const Icon(Icons.keyboard_arrow_down)),
      ),
    );
  }
}