import 'all.dart';
import 'package:counter_spell_new/core.dart';
import 'dart:math';

class ZndrspltOkaum extends GenericAlert {

  static const String _title = "Zndrsplt & Okaum";

  const ZndrspltOkaum(): super(
    500,
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
  int get power => 3 * pow(2,wins);

  void beginCombat(){
    wins = 0;
    triggers = okaum + zndrsplt;

    if(alwaysTryToWin){
      autoSolveTriggers();
    } else {
      handleTrigger();
      refresh();
    }
  }

  void handleTrigger(){
    if(triggers < 1){
      triggers = 0;
      return;
    }

    --triggers;
    _flip();
  }

  void solveFlip(bool choice){
    assert(currentFlip.contains(choice));

    if(choice){ /// win flip
      ++wins;
      _flip(); /// again
    } else {
      currentFlip = null;
      handleTrigger(); /// next commander's trigger if any
    }

    refreshIf(!alwaysTryToWin);
  }

  void _flip(){
    currentFlip = _ThumbFlip(thumbs, rng);
  }

  void autoSolveTriggers(){
    handleTrigger(); /// --triggers and flips
    int _steps = 0;
    while(triggers > 0 && _steps < 100000 && currentFlip != null){
      ++_steps; /// security check, don't want to enter an infinite loop
      solveFlip(currentFlip.containsWin);
      /// if wins, just reflip and ++wins
      /// if loses, clears the flip and start the next trigger if any
    }

    currentFlip = null;
    triggers = 0;
    /// if the cycle broke at 10000 steps, that should be enough 
    /// for the player to win right?
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
    return Container(
      // TODO: almost copy krark and sakashima design
    );
  }
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



