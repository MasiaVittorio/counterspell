import 'package:counter_spell_new/core.dart';

class TutorialProFeatures extends StatelessWidget {
  const TutorialProFeatures();

  @override
  Widget build(BuildContext context) {
    
    final ThemeData theme = Theme.of(context);
    final TextStyle body1 = theme.textTheme.body1;
    final TextStyle body1Bold = theme.textTheme.body1.copyWith(fontWeight: body1.fontWeight.increment.increment);
    final TextStyle subhead = theme.textTheme.subhead;
    final TextStyle subheadBold = subhead.copyWith(fontWeight: body1.fontWeight.increment.increment);
    final TextStyle big = subhead.copyWith(fontSize: subhead.fontSize + 2);
    final TextStyle bigBold = big.copyWith(fontWeight: body1.fontWeight.increment.increment);

    return Column(children: <Widget>[

      Expanded(flex: 3, child: SubSection.withoutMargin(<Widget>[
        ListTile(
          leading: const Icon(McIcons.thumb_up_outline),
          title: RichText(
            text: TextSpan(
              style: subhead,
              children: <TextSpan>[
                const TextSpan(text: "Every "),
                TextSpan(text: "essential", style: subheadBold),
                const TextSpan(text: " feature here is "),
                TextSpan(text: "free", style: subheadBold),
                const TextSpan(text: " , but"),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        ListTile(
          trailing: Icon(Icons.person_outline),
          title: RichText(
            text: TextSpan(
              style: big,
              children: <TextSpan>[
                const TextSpan(text: "CounterSpell is a ",),
                TextSpan(text: "one", style: bigBold),
                const TextSpan(text: " man project",),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // ListTile(title: RichText(
        //   text: TextSpan(
        //     style: body1,
        //     children: <TextSpan>[
        //       const TextSpan(text: 'so to keep things going, there are a couple of ',),
        //       TextSpan(text: 'extra', style: body1Bold),
        //       const TextSpan(text: ' "pro" features',),
        //     ],
        //   ),
        //   textAlign: TextAlign.center,
        // ),),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: RichText(
            text: TextSpan(
              style: body1,
              children: <TextSpan>[
                const TextSpan(text: 'so I made a couple of ',),
                TextSpan(text: 'extra', style: body1Bold),
                const TextSpan(text: ' "pro" features',),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ], mainAxisAlignment: MainAxisAlignment.spaceAround,),),
      

      Row(children: <Widget>[
        for(final child in <Widget>[
          ExtraButton(
            text: "Theming options",
            icon: McIcons.palette_outline,
            onTap: null,
          ),
          ExtraButton(
            text: "Past games stats",
            icon: CSIcons.leaderboards,
            onTap: null,
          ),
        ]) 
          Expanded(child: SubSection.withoutMargin(<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: child,
            ),
          ]),), 
      ].separateWith(CSWidgets.width15),),


      Expanded(flex: 2, child: SubSection.withoutMargin(<Widget>[
        for(final child in [
          ListTile(
            trailing: const Icon(McIcons.cards_outline),
            title: RichText(
              text: TextSpan(
                style: subhead,
                children: <TextSpan>[
                  const TextSpan(text: "You "),
                  TextSpan(text: "DON'T", style: TextStyle(fontWeight: subhead.fontWeight.increment)),
                  const TextSpan(text: " have to purchase every "),
                  TextSpan(text: "single", style: TextStyle(fontWeight: subhead.fontWeight.increment)),
                  const TextSpan(text: " pro feature"),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          ListTile(
            leading: const Icon(McIcons.crown),
            title: RichText(
              text: TextSpan(
                style: subhead,
                children: <TextSpan>[
                  TextSpan(text: "any", style: subheadBold),
                  const TextSpan(text: " one donation will "),
                  TextSpan(text: "permanently", style: subheadBold),
                  const TextSpan(text: " unlock everything\n"),
                  // TextSpan(text: "(even future stuff I may add)", style: body1),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

        ]) Expanded(child: Center(child: child),),
      ],),),

    ].separateWith(CSWidgets.height15),);
  }
}