import 'package:counter_spell_new/core.dart';

import 'components/all.dart';


class TutorialPages extends StatefulWidget {

  const TutorialPages();

  @override
  _TutorialPagesState createState() => _TutorialPagesState();
}


class _TutorialPagesState extends State<TutorialPages> {

  CSPage page = CSPage.counters;

  bool tried = false;

  @override
  Widget build(BuildContext context) {

    final StageData<CSPage,SettingsPage> stage = Stage.of(context);
    final Map<CSPage,Color> colors = stage.themeController.primaryColorsMap.value;

    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subhead;
    final TextStyle subheadBold = subhead.copyWith(fontWeight: subhead.fontWeight.increment.increment);
    final TextStyle body1 = theme.textTheme.body1;
    final TextStyle body1Bold = body1.copyWith(fontWeight: body1.fontWeight.increment.increment);

    final double collapsedPanelSize = stage.dimensions.value.collapsedPanelSize;

    return Column(
      children: <Widget>[
        
        SubSection.withoutMargin(<Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 4.0),
            child: RichText(
              text: TextSpan(
                style: subhead,
                children: <TextSpan>[
                  const TextSpan(text: "Each "),
                  TextSpan(text: "page", style: subheadBold),
                  const TextSpan(text: " has different "),
                  TextSpan(text: "controls", style: subheadBold),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          CSWidgets.divider,
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16, 16),
            child: Text("Try using the bottom bar!", textAlign: TextAlign.center,),
          ),
        ], crossAxisAlignment: CrossAxisAlignment.center,),

        Expanded(child: SubSection.withoutMargin(<Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedText(
              const <CSPage,String>{
                CSPage.history: "History page",
                CSPage.counters: "Counters page",
                CSPage.commanderDamage: "Commander Damage page",
              }[page],
              style: subhead,
            ),
          ),
          CSWidgets.divider,
          Expanded(
            child: const <CSPage,Widget>{
              CSPage.history: TutorialHistory(),
              CSPage.counters: TutorialCounters(),
              CSPage.commanderDamage: TutorialDamage(),
            }[page],
          ),
        ], crossAxisAlignment: CrossAxisAlignment.center,),),

        SubSection.withoutMargin(<Widget>[
          AnimatedOpacity(
            opacity: tried ? 1.0 : 0.0,
            duration: CSAnimations.medium,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  style: body1,
                  children: <TextSpan>[
                    const TextSpan(text: "The "),
                    TextSpan(text: "bottom panel", style: body1Bold),
                    const TextSpan(text: " contains "),
                    TextSpan(text: "different buttons", style: body1Bold),
                    const TextSpan(text: " for each page"),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          bottomBar(colors, collapsedPanelSize, theme),
        ]),

      ].separateWith(CSWidgets.height15),
    );
  }

  Widget bottomBar(Map<CSPage,Color> colors, double collapsedPanelSize, ThemeData theme) => SizedBox(
    height: collapsedPanelSize + RadioNavBar.defaultTileSize,
    child: Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Positioned(
          top: collapsedPanelSize / 2,
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: ClipRRect(
            borderRadius: SubSection.borderRadiusDefault,
            // clipBehavior: Clip.antiAlias,
            child: RadioNavBar<CSPage>(
              tileSize: RadioNavBar.defaultTileSize,
              topPadding: collapsedPanelSize / 2,
              selectedValue: page, 
              orderedValues: const <CSPage>[
                CSPage.history, 
                CSPage.counters, 
                // CSPage.life, 
                CSPage.commanderDamage, 
                // CSPage.commanderCast,
              ], 
              items: <CSPage,RadioNavBarItem>{
                CSPage.history: RadioNavBarItem(
                  title: "History",
                  icon: CSIcons.historyIconFilled,
                  unselectedIcon: CSIcons.historyIconOutlined,
                  color: colors[CSPage.history],
                ),
                CSPage.counters: RadioNavBarItem(
                  title: "Counters",
                  icon: CSIcons.counterIconFilled,
                  unselectedIcon: CSIcons.counterIconOutlined,
                  color: colors[CSPage.counters],
                ),
                CSPage.life: RadioNavBarItem(
                  title: "Life",
                  icon: CSIcons.lifeIconFilled,
                  unselectedIcon: CSIcons.lifeIconOutlined,
                  color: colors[CSPage.life],
                ),
                CSPage.commanderDamage: RadioNavBarItem(
                  title: "Damage",
                  icon: CSIcons.damageIconFilled,
                  unselectedIcon: CSIcons.damageIconOutlined,
                  color: colors[CSPage.commanderDamage],
                ),
                CSPage.commanderCast: RadioNavBarItem(
                  title: "Casts",
                  icon: CSIcons.castIconFilled,
                  unselectedIcon: CSIcons.castIconOutlined,
                  color: colors[CSPage.commanderCast],
                ),
              }, 
              onSelect: (CSPage newPage) => this.setState((){
                this.page = newPage;
                this.tried = true;
              })
            ),
          ),
        ),

        Positioned(
          top: 0.0,
          height: collapsedPanelSize,
          right: 16.0,
          left: 16.0,
          child: Material(
            borderRadius: BorderRadius.circular(collapsedPanelSize/2),
            elevation: 16,
            child: SizedBox(
              height: collapsedPanelSize,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Center(
                    child: <CSPage,Widget>{
                      CSPage.history: Text("Life Chart"),
                      CSPage.counters: Text("Arena Mode"),
                      CSPage.commanderDamage: Text("Arena Mode"),
                    }[page],
                  ),),
                  Container(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    width: 1,
                    height: collapsedPanelSize * 0.8,
                  ),
                  Expanded(child: Center(
                    child: <CSPage,Widget>{
                      CSPage.history: Text("Restart"),
                      CSPage.counters: Text("Counter Picker"),
                      CSPage.commanderDamage: Text("Info"),
                    }[page],
                  ),),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );


}