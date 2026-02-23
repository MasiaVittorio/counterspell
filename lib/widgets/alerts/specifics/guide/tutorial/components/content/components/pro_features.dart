import 'package:counter_spell/core.dart';

class TutorialProFeatures extends StatelessWidget {
  const TutorialProFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    final StageData? stage = Stage.of(context);
    final ThemeData theme = Theme.of(context);
    final TextStyle body1 = theme.textTheme.bodyMedium!;
    final TextStyle subhead = theme.textTheme.titleMedium!;
    final TextStyle subheadBold =
        subhead.copyWith(fontWeight: body1.fontWeight!.increment.increment);

    void showSupport() => this.showSupport(stage!);

    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: SubSection.withoutMargin(
            <Widget>[
              ListTile(
                leading: const Icon(McIcons.thumb_up_outline),
                title: RichText(
                  text: TextSpan(
                    style: subhead,
                    children: <TextSpan>[
                      const TextSpan(text: "Every essential feature is "),
                      TextSpan(text: "free", style: subheadBold),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                trailing: const Icon(Icons.attach_money),
                title: RichText(
                  text: TextSpan(
                    style: subhead,
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'There are just a couple of ',
                      ),
                      TextSpan(text: 'extra', style: subheadBold),
                      const TextSpan(
                        text: ' "pro" features',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            onTap: showSupport,
          ),
        ),
        Row(
          children: <Widget>[
            for (final child in <Widget>[
              ButtonTile(
                text: "Theming options",
                icon: McIcons.palette_outline,
                onTap: showSupport,
              ),
              ButtonTile(
                text: "Past games stats",
                icon: CSIcons.leaderboards,
                onTap: showSupport,
              ),
            ])
              Expanded(
                child: SubSection.withoutMargin(<Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: child,
                  ),
                ]),
              ),
          ].separateWith(CSWidgets.width15),
        ),
        Expanded(
          flex: 2,
          child: SubSection.withoutMargin(
            <Widget>[
              for (final child in [
                ListTile(
                  trailing: const Icon(McIcons.cards_outline),
                  title: RichText(
                    text: TextSpan(
                      style: subhead,
                      children: <TextSpan>[
                        const TextSpan(text: "You "),
                        TextSpan(
                            text: "DON'T",
                            style: TextStyle(
                                fontWeight: subhead.fontWeight!.increment)),
                        const TextSpan(
                            text: " have to purchase every single feature"),
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
                        const TextSpan(text: "Any one donation unlocks "),
                        TextSpan(text: "everything", style: subheadBold),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ])
                Expanded(
                  child: Center(child: child),
                ),
            ],
            onTap: showSupport,
          ),
        ),
      ].separateWith(CSWidgets.height15),
    );
  }

  void showSupport(StageData stage) =>
      stage.showAlert(const SupportAlert(), size: SupportAlert.height);
}
