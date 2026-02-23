import 'package:counter_spell/core.dart';

class TutorialUI extends StatelessWidget {
  const TutorialUI({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: const Stage<CSPage, SettingsPage>(
        body: _UIBody(),
        wholeScreen: false,
        topBarContent: StageTopBarContent(
          title: _UITopBar(),
        ),
        mainPages: StagePagesData.nullable(
          defaultPage: CSPage.counters,
          orderedPages: <CSPage>[
            CSPage.history,
            CSPage.counters,
            CSPage.commanderDamage
          ],
        ),
        collapsedPanel: _UICollapsed(),
        extendedPanel: _UIExtended(),
      ),
    );
  }
}

class _UIExtended extends StatelessWidget {
  const _UIExtended();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StageBuild.offPanelPage<SettingsPage>(
            (_, page) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedText(
                  page == SettingsPage.info
                      ? "You'll find the tutorial here!"
                      : 'Go to the "Info" tab',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(
                  page == SettingsPage.info
                      ? McIcons.emoticon_happy_outline
                      : Icons.info_outline,
                  size: 33,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UICollapsed extends StatelessWidget {
  const _UICollapsed();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    return stage.dimensionsController.dimensions.build(
      (_, dimensions) => Row(
        children: <Widget>[
          SizedBox(width: dimensions.barSize),
          const Expanded(
            child: Center(
              child: Text(
                "Or swipe me up!",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            width: dimensions.barSize,
            child: Center(
                child: IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => stage.showAlert(
                  AlternativesAlert(
                    label: "This is an alert",
                    alternatives: <Alternative>[
                      Alternative(
                        action: () {},
                        icon: Icons.space_bar,
                        title: "Alerts like this are shown in the panel",
                      ),
                      Alternative(
                        action: () {},
                        icon: McIcons.gesture_swipe_down,
                        title: "You can close them by scrolling down",
                      ),
                    ],
                  ),
                  size: AlternativesAlert.heightCalc(2)),
            )),
          ),
        ],
      ),
    );
  }
}

class _UIBody extends StatelessWidget {
  const _UIBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.keyboard_arrow_up),
          Text(
            "To get back to the tutorial...",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class _UITopBar extends StatelessWidget {
  const _UITopBar();

  @override
  Widget build(BuildContext context) {
    return StageBuild.offOpenNonAlert(
      (_, openNonAlert) =>
          AnimatedText(openNonAlert ? "In the panel" : '< Tap the Icon'),
    );
  }
}

class SubExplanation extends StatelessWidget {
  final List<Widget> children;
  final Widget? separator;
  final String title;

  const SubExplanation(
    this.title, {
    required this.children,
    this.separator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? subhead = theme.textTheme.titleMedium;

    List<Widget?> rowChildren = <Widget>[
      for (final child in children)
        Expanded(
          child: child,
        )
    ];

    if (separator != null) {
      rowChildren = rowChildren.separateWith(separator);
    }

    return SubSection.withoutMargin(
      <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: subhead,
          ),
        ),
        CSWidgets.divider,
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: rowChildren as List<Widget>,
              ),
            ),
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
