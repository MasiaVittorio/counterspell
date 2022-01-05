import 'package:counter_spell_new/core.dart';

class TutorialSelection extends StatefulWidget {
  const TutorialSelection();

  @override
  _TutorialSelectionState createState() => _TutorialSelectionState();
}

class _TutorialSelectionState extends State<TutorialSelection> {
  Map<String,bool?> state = <String,bool?>{
    "Me": false,
    "You": true,
    "Them": false,
  };
  bool tried = false;

  void tapKey(String key) => this.setState((){
    this.state[key] = !(this.state[key] ?? true);
    this.tried = true;
  });

  @override
  Widget build(BuildContext context) {

    // final ThemeData theme = Theme.of(context);

    final CSBloc bloc = CSBloc.of(context)!;
    final Color color = bloc.stage.themeController.derived.mainPageToPrimaryColor.value![CSPage.life]!;

    // final colorBright = ThemeData.estimateBrightnessForColor(color);
    // final Color textColor = 
      // colorBright == Brightness.light 
      // ? Colors.black 
      // : Colors.white;
    final textStyle = TextStyle(fontSize: 0.26 * CSSizes.minTileSize);
    // final TextStyle subhead = theme.textTheme.subtitle1;

    final theme = Theme.of(context);
    final Color subColor = theme.scaffoldBackgroundColor;
    final Color selectedColor = Color.alphaBlend(
      color.withOpacity(0.5),
      theme.canvasColor,
    );


    return Column(
      children: <Widget>[

        SubSection(<Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Select multiple players at once!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),


        ], margin: EdgeInsets.zero, crossAxisAlignment: CrossAxisAlignment.stretch),

        Expanded(child: Section(<Widget>[
          const SectionTitle("Players list"),
          Expanded(child: ListView(
            primary: false,
            children: <Widget>[
              for(final String key in state.keys) 
                InkWell(
                  onTap: () => this.tapKey(key),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(key),
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
                        color: this.state[key] == false
                          ? subColor
                          : selectedColor,
                        increment: this.state[key] == true 
                          ? 7
                          : this.state[key] == false
                            ? 0
                            : -7,
                        borderRadiusFraction: 1.0,
                        
                      ),
                    ),
                  ),
                ),
            ].separateWith(CSWidgets.height10),
          ),),
        ],),),


        SubSection(<Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedOpacity(
              duration: CSAnimations.fast,
              opacity: this.tried ? 1.0 : 0.0,
              child: const Text(
                "(You can long press the small checkbox to anti-select a player: useful for lifelink!)",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(children: <Widget>[
                Expanded(
                  flex: 2,
                  child: ExtraButton(
                    onTap: (){},
                    text: "",
                    customIcon: Checkbox(value: true, onChanged: null,),
                    icon: null,
                    forceExternalSize: true,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ExtraButton(
                    onTap: (){},
                    text: "",
                    icon: null,
                    customIcon: Checkbox(value: false, onChanged: null,),
                    forceExternalSize: true,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ExtraButton(
                    onTap: (){},
                    text: "Anti-Selected",
                    icon: null,
                    customIcon: Checkbox(value: null, tristate: true, onChanged: null,),
                    forceExternalSize: true,
                  ),
                ),
                
            ].separateWith(CSWidgets.extraButtonsDivider),),
          ),
        ], margin: EdgeInsets.zero,),


      ].separateWith(CSWidgets.height15),
    );
  }
}