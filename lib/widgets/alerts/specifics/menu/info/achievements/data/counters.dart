import 'package:counter_spell_new/core.dart';

class CountersMaster extends StatefulWidget {
  const CountersMaster();

  @override
  _CountersMasterState createState() => _CountersMasterState();
}

class _CountersMasterState extends State<CountersMaster> {

  CSPage page = CSPage.life;
  bool done = false;

  @override
  Widget build(BuildContext context) {

    final StageData<CSPage,SettingsPage> stage = Stage.of(context);

    final double collapsedPanelSize = stage.dimensions.value.collapsedPanelSize;
    final Map<CSPage,Color> colors = stage.themeController.primaryColorsMap.value;

    return Column(
      children: <Widget>[
        Expanded(child: Center(child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedText(
            done ? "Nice!" : <CSPage,String>{
              CSPage.life: "Go to the counters section",
              CSPage.counters: "Press the button on the right of the bottom panel",
            }[page] ?? "",
            textAlign: TextAlign.center,
            duration: CSAnimations.medium,
          ),
        ),),),

        FakeBottomBar(
          rightCallback: (){
            if(page == CSPage.counters) this.setState((){
              this.done = true;
            });
          },
          collapsedPanelSize: collapsedPanelSize, 
          page: page, 
          colors: colors, 
          onSelect: (CSPage newPage) => this.setState((){
            this.page = newPage;
          }), 
          orderedValues: const <CSPage>[
            // CSPage.history, 
            CSPage.counters, 
            CSPage.life, 
            // CSPage.commanderDamage, 
            // CSPage.commanderCast,
          ], 
          leftTitles: <CSPage,String>{
            CSPage.life: "Arena Mode",
            CSPage.counters: "Arena Mode",
          }, 
          rightTitles: <CSPage,String>{
            CSPage.life: "Playgroup",
            CSPage.counters: "Counter picker",
          },
        ),
      ],
    );
  }
}