import 'package:counter_spell/core.dart';

class TutorialSelection extends StatefulWidget {
  const TutorialSelection({super.key});

  @override
  State createState() => _TutorialSelectionState();
}

class _TutorialSelectionState extends State<TutorialSelection> {
  Map<String, bool?> state = <String, bool?>{
    "Me": false,
    "You": true,
    "Them": false,
  };
  bool tried = false;

  void tapKey(String key) => setState(() {
        state[key] = !(state[key] ?? true);
        tried = true;
      });

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);

    final CSBloc bloc = CSBloc.of(context);
    final Color color = bloc.stage.themeController.derived
        .mainPageToPrimaryColor.value![CSPage.life]!;

    // final colorBright = ThemeData.estimateBrightnessForColor(color);
    // final Color textColor =
    // colorBright == Brightness.light
    // ? Colors.black
    // : Colors.white;
    const textStyle = TextStyle(fontSize: 0.26 * CSSizes.minTileSize);
    // final TextStyle subhead = theme.textTheme.titleMedium;

    final theme = Theme.of(context);
    final Color subColor = theme.scaffoldBackgroundColor;
    final Color selectedColor = Color.alphaBlend(
      color.withValues(alpha: 0.5),
      theme.canvasColor,
    );

    return Column(
      children: <Widget>[
        const SubSection(<Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Select multiple players at once!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
            margin: EdgeInsets.zero,
            crossAxisAlignment: CrossAxisAlignment.stretch),
        Expanded(
          child: Section(
            <Widget>[
              const SectionTitle("Players list"),
              Expanded(
                child: ListView(
                  primary: false,
                  children: <Widget>[
                    for (final String key in state.keys)
                      InkWell(
                        onTap: () => tapKey(key),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(key),
                            trailing: InkWell(
                              onTap: () => tapKey(key),
                              onLongPress: () => setState(() {
                                state[key] = null;
                              }),
                              child: Checkbox(
                                tristate: true,
                                value: state[key],
                                onChanged: (b) => setState(() {
                                  state[key] = b ?? false;
                                }),
                              ),
                            ),
                            leading: CircleNumber(
                              size: 56,
                              value: 40,
                              numberOpacity: 1.0,
                              open: state[key] != false,
                              style: textStyle,
                              duration: CSAnimations.fast,
                              color: state[key] == false
                                  ? subColor
                                  : selectedColor,
                              increment: state[key] == true
                                  ? 7
                                  : state[key] == false
                                      ? 0
                                      : -7,
                              borderRadiusFraction: 1.0,
                            ),
                          ),
                        ),
                      ),
                  ].separateWith(CSWidgets.height10),
                ),
              ),
            ],
          ),
        ),
        SubSection(
          <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedOpacity(
                duration: CSAnimations.fast,
                opacity: tried ? 1.0 : 0.0,
                child: const Text(
                  "(You can long press the small checkbox to anti-select a player: useful for lifelink!)",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: ButtonTile(
                      onTap: () {},
                      text: "",
                      customIcon: const Checkbox(
                        value: true,
                        onChanged: null,
                      ),
                      icon: null,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ButtonTile(
                      onTap: () {},
                      text: "",
                      icon: null,
                      customIcon: const Checkbox(
                        value: false,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ButtonTile(
                      onTap: () {},
                      text: "Anti-Selected",
                      icon: null,
                      customIcon: const Checkbox(
                        value: null,
                        tristate: true,
                        onChanged: null,
                      ),
                    ),
                  ),
                ].separateWith(CSWidgets.extraButtonsDivider),
              ),
            ),
          ],
          margin: EdgeInsets.zero,
        ),
      ].separateWith(CSWidgets.height15),
    );
  }
}
