import 'all.dart';
import 'package:counter_spell_new/core.dart';
import 'dart:math';

class ZndrspltOkaum extends GenericAlert {

  static const String _title = "Zndrsplt & Okaum";

  const ZndrspltOkaum(): super(
    540,
    _title,
    const <String>{"Zndrsplt","Okaum","Coins","Win","Flip","Coin"},
  );

  @override
  Widget build(BuildContext context) => const _ZndrspltOkaum();

}


class _ZndrspltOkaum extends StatefulWidget {

  const _ZndrspltOkaum();

  @override
  _ZndrspltOkaumState createState() => _ZndrspltOkaumState();
}

class _ZndrspltOkaumState extends State<_ZndrspltOkaum> {

  Random rng;
  @override
  void initState() {
    super.initState();
    rng = Random(DateTime.now().millisecondsSinceEpoch);
  }

  /// settings
  int zndrsplt = 0;
  int okaum = 0;
  int thumbs = 0;

  /// status
  int triggers = 0;
  _ThumbFlip currentFlip;
  int wins = 0;

  /// flip settings
  bool alwaysTryToWin = false;

  /// derived
  int get draws => wins * zndrsplt;
  int get power => okaum > 0 ? 3 * pow(2,wins) : 0;

  void beginCombat(){
    // debugPrint("enter beginCombat");
    wins = 0;
    triggers = okaum + zndrsplt;
    // debugPrint("beginCombat: wins $wins triggers $triggers");
    if(alwaysTryToWin){
      // debugPrint("beginCombat: alwaysTryToWin");
      autoSolveTriggers();
    } else {
      // debugPrint("beginCombat: manual");
      handleTrigger();
      refresh();
    }
    // debugPrint("exits beginCombat");
  }

  void handleTrigger(){
    // debugPrint("enters handleTrigger");
    if(triggers < 1){
      // debugPrint("triggers were less than one: $triggers");
      triggers = 0;
      // debugPrint("now triggers $triggers");
      // debugPrint("exits handleTrigger");
      return;
    }

    // debugPrint("triggers were $triggers");
    --triggers;
    // debugPrint("now triggers: $triggers");    
    _flip();
    // debugPrint("exits handleTrigger");
  }

  void solveFlip(bool choice){
    // debugPrint("enters solveFlip with choice $choice");
    assert(currentFlip.contains(choice));
    // debugPrint("wins were $wins");
    if(choice){ /// win flip
      ++wins;
      // debugPrint("now wins $wins! let's flip again");
      _flip(); /// again
    } else {
      currentFlip = null;
      // debugPrint("now current Flip null, let's check if there are more triggers");
      handleTrigger(); /// next commander's trigger if any
    }

    refreshIf(!alwaysTryToWin);
    // debugPrint("exits solveFlip");
  }

  void _flip(){
    // debugPrint("enters _flip");
    currentFlip = _ThumbFlip(thumbs, rng);
    // debugPrint("new Flip is: ${currentFlip.flips}");
    // debugPrint("exits _flip");
  }


  void autoSolveTriggers(){
    // debugPrint("enters autoSolveTriggers");
    handleTrigger(); /// --triggers and flips
    int _steps = 0;
    while(_steps < 100 && currentFlip != null){
      // debugPrint("step $_steps");
      ++_steps; /// security check, don't want to enter an infinite loop
      solveFlip(currentFlip.containsWin);
      /// if wins, just reflip and ++wins
      /// if loses, clears the flip and start the next trigger if any
    }

    // debugPrint("autoSolveTriggers: finish after step $_steps");
    currentFlip = null;
    triggers = 0;
    /// if the cycle broke at 10000 steps, that should be enough 
    /// for the player to win right?
    refresh();

    // debugPrint("exits autoSolveTriggers");
    // TODO: test if zero zndrsplt and okaums lead to some bugs
  }

  void toggleAuto() => this.setState(() {
    alwaysTryToWin = !alwaysTryToWin;    
  });

  void refreshIf(bool condition){
    if(condition) refresh();
  }
  void refresh() => this.setState((){});

  @override
  Widget build(BuildContext context) {
    return HeaderedAlertCustom(
      Material(
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertDrag(),
            settingsSection,
            CSWidgets.height10,
          ],
        ),
      ),
      titleSize: 89 + AlertDrag.height,
      canvasBackground: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          statusSection,
          triggersSection,
        ],
      ),
      bottom: actions,
    );
  }

  Widget get settingsSection => SubSection([
    ExtraButtons(children: [
      ExtraButton(
        customCircleColor: Colors.transparent,
        text: "# of Zndrsplt",
        icon: null,
        customIcon: Text("$zndrsplt"),
        onTap: () => this.setState(() {
          ++zndrsplt;
        }),
        onLongPress: () => this.setState(() {
          zndrsplt = 0;        
        }),
      ),
      ExtraButton(
        customCircleColor: Colors.transparent,
        text: "# of Okaum",
        icon: null,
        customIcon: Text("$okaum"),
        onTap: () => this.setState(() {
          ++okaum;
        }),
        onLongPress: () => this.setState(() {
          okaum = 0;
        }),
      ),
      ExtraButton(
        customCircleColor: Colors.transparent,
        text: "# of Thumbs",
        icon: null,
        customIcon: Text("$thumbs"),
        onTap: () => this.setState(() {
          ++thumbs;
        }),
        onLongPress: () => this.setState(() {
          thumbs = 0;
        }),
      ),
    ],),
  ],);

  Widget get statusSection => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SectionTitle("Status"),
      Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 6.0),
        child: Row(children: [
          Expanded(child: ExtraButton(
            icon: null,
            customIcon: Text("$draws"),
            twoLines: zndrsplt > 1,
            text: zndrsplt > 1 ? "Draws\n(total)" : "Draws",
            onTap: null,
          ),),
          const ExtraButtonDivider(),
          Expanded(child: ExtraButton(
            iconOverflow: true,
            icon: null,
            customIcon: Text(wins > 9 ? "3*2^$wins" : "$power"),
            twoLines: okaum > 1,
            text: okaum > 1 ? "P/T\n(/each)" : "P/T",
            onTap: null,
          ),),
          Expanded(child: ExtraButton(
            icon: null,
            filled: true,
            customIcon: Text("$wins"),
            text: "Wins",
            onTap: null,
            onLongPress: () => this.setState(() {
              wins = 0;
            }),
          ),),
        ]),
      ),
    ],
  );

  Widget get triggersSection => Padding(
    padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SectionTitle("Triggers"),
        Row(children: <Widget>[
          if(currentFlip != null) Expanded(flex: 6, child: SubSection(<Widget>[
            SectionTitle("Current flip ${currentFlip.flips.length > 1 ? '(${currentFlip.flips.length} thumb-coins)' : ""}"),
            if(currentFlip.flips.length > 1) ExtraButtons(children: <Widget>[
              ExtraButton(
                customCircleColor: Colors.transparent,
                icon: null,
                customIcon: Text("${currentFlip.howManyWins}"),
                onTap: currentFlip.howManyWins > 0 
                  ? () => solveFlip(true) 
                  : null,
                text: "Heads\n(win)",
                twoLines: true,
              ), 
              ExtraButton(
                customCircleColor: Colors.transparent,
                icon: null,
                customIcon: Text("${currentFlip.howManyLosses}"),
                onTap: currentFlip.howManyLosses > 0 
                  ? () => solveFlip(false) 
                  : null,
                text: "Tails\n(loss)",
                twoLines: true,
              ), 
            ],)
            else ExtraButtons(children: <Widget>[
              ExtraButton(
                icon: currentFlip.containsWin ? Icons.check : Icons.close,
                onTap: null,
                text: currentFlip.containsWin ? "Heads\n(win)" : "Tails\n(loss)",
                twoLines: true,
              ),
              ExtraButton(
                customCircleColor: Colors.transparent,
                icon: Icons.keyboard_arrow_right,
                onTap: () => solveFlip(currentFlip.flips.first),
                text: "Ok\n(${(currentFlip.containsWin || triggers > 0) ? "next" : "finish"})",
                twoLines: true,
              ), 
            ],)
 
          ]),),

          if(currentFlip != null) Expanded(flex: 2, child: ExtraButton(
            onTap: null,
            text: "More\ntriggers",
            twoLines: true,
            icon: null,
            customIcon: Text(triggers <= 0 ? "No" : "$triggers"),
          )),
          
          if(currentFlip == null) const Expanded(child: SubSection([
            ListTile(title: Text("No trigger left"),),
          ]),),
        ],),
      ],
    ),
  );

  Widget get actions => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CSWidgets.height10,
        SubSection([
          ListTile(
            leading: Icon(CSIcons.attackTwo),
            title: AnimatedText(
              (currentFlip == null ? "Begin Combat" : "Can't begin combat")
              + (this.alwaysTryToWin ? " (auto)" : " (manual)")
            ),
            subtitle: currentFlip == null ? null : Text("Solve triggers first"),
            onTap: currentFlip == null ? beginCombat : null,
          ),
        ],),
        SwitchListTile(
          title: Text("Keep flipping"),
          subtitle: Text("Until no win or 100 flips"),
          value: this.alwaysTryToWin, 
          onChanged: currentFlip == null ? (v) => this.setState(() {
            alwaysTryToWin = v;  
          }) : null,
        ),
      ],
    );

}



class _ThumbFlip {
  
  List<bool> flips;

  _ThumbFlip(int howManyThumbs, Random rng): flips = [
    for(int i=0; i<pow(2,howManyThumbs); ++i)
      (rng.nextInt(2) == 0),
      /// nextInt(2) gives either 0 or 1, so this flips a coin
  ];

  bool contains(bool choice) => this.flips.contains(choice);
  bool get containsWin => contains(true);
  bool get containsLoss => contains(false);

  int howMany(bool v) => [for(final f in flips) if(f == v) f].length;
  int get howManyWins => howMany(true);
  int get howManyLosses => howMany(false);
}


