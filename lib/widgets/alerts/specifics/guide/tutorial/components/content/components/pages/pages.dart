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

    final StageData<CSPage,SettingsPage> stage = Stage.of(context) as StageData<CSPage, SettingsPage>;
    final Map<CSPage,Color?>? colors = stage.themeController.derived.mainPageToPrimaryColor!.value;

    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subtitle1!;
    final TextStyle subheadBold = subhead.copyWith(fontWeight: subhead.fontWeight!.increment.increment);

    final double collapsedPanelSize = stage.dimensionsController.dimensions.value.collapsedPanelSize;

    return Column(
      children: <Widget>[
        
        SubSection.withoutMargin(<Widget>[
          Row(children: <Widget>[
            Expanded(child: Center(child: Padding(
              padding: const EdgeInsets.all(16.0),
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
            ),),),
          ],),
        ], crossAxisAlignment: CrossAxisAlignment.stretch,),

        Expanded(child: SubSection.withoutMargin(<Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedText(
              const <CSPage,String>{
                CSPage.history: "History page",
                CSPage.counters: "Counters page",
                CSPage.commanderDamage: "Commander Damage page",
              }[page]!,
              style: subhead,
            ),
          ),
          CSWidgets.divider,
          Expanded(
            child: const <CSPage,Widget>{
              CSPage.history: TutorialHistory(),
              CSPage.counters: TutorialCounters(),
              CSPage.commanderDamage: TutorialDamage(),
            }[page]!,
          ),
        ], crossAxisAlignment: CrossAxisAlignment.center,),),

        SubSection.withoutMargin(<Widget>[
          Container(
            constraints: BoxConstraints(minHeight: collapsedPanelSize + 8),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AnimatedText(
              tried 
              ? "The bottom panel contains different buttons for each page"
              : "Try changing page here!",
              textAlign: TextAlign.center,
              duration: CSAnimations.slow,
            ),
          ),
          bottomBar(colors, collapsedPanelSize, theme),
        ]),

      ].separateWith(CSWidgets.height15),
    );
  }

  Widget bottomBar(Map<CSPage,Color?>? colors, double collapsedPanelSize, ThemeData theme) => FakeBottomBar(
    collapsedPanelSize: collapsedPanelSize, 
    page: page, 
    colors: colors, 
    onSelect: (CSPage newPage) => this.setState((){
      this.page = newPage;
      this.tried = true;
    }), 
    orderedValues: const <CSPage>[
      CSPage.history, 
      CSPage.counters, 
      // CSPage.life, 
      CSPage.commanderDamage, 
      // CSPage.commanderCast,
    ], 
    leftTitles: <CSPage,String>{
      CSPage.history: "Life Chart",
      CSPage.counters: "Arena Mode",
      CSPage.commanderDamage: "Arena Mode",
    }, 
    rightTitles: <CSPage,String>{
      CSPage.history: "Restart",
      CSPage.counters: "Counter picker",
      CSPage.commanderDamage: "Info",
    },
  );
  
}