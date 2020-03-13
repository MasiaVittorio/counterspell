import 'package:counter_spell_new/core.dart';

class TutorialSelection extends StatefulWidget {
  const TutorialSelection();

  @override
  _TutorialSelectionState createState() => _TutorialSelectionState();
}

class _TutorialSelectionState extends State<TutorialSelection> {
  Map<String,bool> state = <String,bool>{
    "Me": false,
    "You": true,
    "Them": false,
  };

  void tapKey(String key) => this.setState((){
    this.state[key] = !(this.state[key] ?? true);
  });

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    final CSBloc bloc = CSBloc.of(context);
    final Color color = bloc.stage.themeController.primaryColorsMap.value[CSPage.life];

    final colorBright = ThemeData.estimateBrightnessForColor(color);
    final Color textColor = colorBright == Brightness.light 
      ? Colors.black 
      : Colors.white;
    final textStyle = TextStyle(color: textColor, fontSize: 0.26 * CSSizes.minTileSize);


    return Column(
      children: <Widget>[

        Expanded(child: SubSection(<Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "You can select more than one player to affect at once!",
              style: theme.textTheme.subhead,
            ),
          ),

          CSWidgets.divider,
          CSWidgets.height10,

          Expanded(child: ListView(
            primary: false,
            children: <Widget>[
              for(final String key in state.keys) 
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    title: Text(key),
                    onTap: () => this.tapKey(key),
                    trailing: InkWell(
                      onTap: () => this.tapKey(key),
                      onLongPress: () => this.setState((){
                        this.state[key] = null;
                      }),
                      child: Checkbox(
                        tristate: true,
                        value: this.state[key],
                        onChanged: (b) => this.setState((){
                          this.state[key] = b ?? false;
                        }),
                      ),
                    ),
                    leading: CircleNumber(
                      size: 56,
                      value: 40,
                      numberOpacity: 1.0,
                      open: this.state[key] != false,
                      style: textStyle,
                      duration: CSAnimations.fast,
                      color: color,
                      increment: this.state[key] == true 
                        ? 7
                        : this.state[key] == false
                          ? 0
                          : -7,
                      borderRadiusFraction: 1.0,
                    ),
                  ),
                ),
            ].separateWith(CSWidgets.height10),
          ),),
        ], margin: EdgeInsets.zero,),),

        CSWidgets.height15,

        SubSection(<Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("(You can long press the small checkbox to anti-select a player: useful for lifelink!)"),
          ),
        ], margin: EdgeInsets.zero,),

      ],
    );
  }
}