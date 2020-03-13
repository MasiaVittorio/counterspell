import 'package:counter_spell_new/core.dart';

class TutorialProFeatures extends StatelessWidget {
  const TutorialProFeatures();

  @override
  Widget build(BuildContext context) {
    
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subhead;

    return Column(children: <Widget>[

      Expanded(child: SubSection.withoutMargin(<Widget>[
        for(final child in [
          ListTile(title: RichText(
            text: TextSpan(
              style: subhead,
              children: <TextSpan>[
                const TextSpan(text: "Every "),
                TextSpan(text: "essential", style: TextStyle(fontWeight: subhead.fontWeight.increment)),
                const TextSpan(text: " feature here is free, but"),
              ],
            ),
            textAlign: TextAlign.center,
          ),),

          ListTile(title: RichText(
            text: TextSpan(
              style: subhead.copyWith(fontSize: subhead.fontSize + 2),
              children: <TextSpan>[
                const TextSpan(text: "CounterSpell is a ",),
                TextSpan(text: "one", style: subhead.copyWith(fontWeight: subhead.fontWeight.increment)),
                const TextSpan(text: " man project\n",),
              ],
            ),
            textAlign: TextAlign.center,
          ),),

          const ListTile(subtitle: Text(
            'so to keep things going, there are a couple of extra "pro" features you can unlock',
            textAlign: TextAlign.center,
          ),),
        ]) 
          Expanded(child: Center(child: child),)
      ],),),
      

      Row(children: <Widget>[
        for(final child in <Widget>[
          ExtraButton(
            text: "Theming options",
            icon: McIcons.palette_outline,
            onTap: (){},
          ),
          ExtraButton(
            text: "Past games stats",
            icon: CSIcons.leaderboards,
            onTap: (){},
          ),
        ]) 
          Expanded(child: SubSection.withoutMargin(<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: child,
            ),
          ]),), 
      ].separateWith(CSWidgets.width15),),


      Expanded(child: SubSection.withoutMargin(<Widget>[
        for(final child in [
          ListTile(title: RichText(
            text: TextSpan(
              style: subhead,
              children: <TextSpan>[
                const TextSpan(text: "You "),
                TextSpan(text: "don't", style: TextStyle(fontWeight: subhead.fontWeight.increment)),
                const TextSpan(text: " have to purchase every "),
                TextSpan(text: "single", style: TextStyle(fontWeight: subhead.fontWeight.increment)),
                const TextSpan(text: " pro feature"),
              ],
            ),
            textAlign: TextAlign.center,
          ),),

          ListTile(title: RichText(
            text: TextSpan(
              style: subhead,
              children: <TextSpan>[
                TextSpan(text: "any", style: TextStyle(fontWeight: subhead.fontWeight.increment)),
                const TextSpan(text: " single donation will "),
                TextSpan(text: "permanently", style: TextStyle(fontWeight: subhead.fontWeight.increment)),
                const TextSpan(text: " unlock everything\n"),
                TextSpan(text: "(even future stuff I may add)", style: TextStyle(fontSize: subhead.fontSize-2)),
              ],
            ),
            textAlign: TextAlign.center,
          ),),

        ]) Expanded(child: Center(child: child),),
      ],),),

    ].separateWith(CSWidgets.height15),);
  }
}