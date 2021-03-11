import 'package:counter_spell_new/core.dart';
import 'all.dart';
import 'dart:math';


class KrarkAndSakashima extends GenericAlert {
  static const String _title = "Krark & Sakashima";

  const KrarkAndSakashima(): super(
    800,
    _title,
    const <String>{"Krark","Sakashima","Thumbs"},
  );

  @override
  Widget build(BuildContext context) {
    return const _KrarkAndSakashima(_title);
  }
}

class _KrarkAndSakashima extends StatefulWidget {
  final String title;

  const _KrarkAndSakashima(this.title);

  @override
  _KrarkAndSakashimaState createState() => _KrarkAndSakashimaState();
}

class _KrarkAndSakashimaState extends State<_KrarkAndSakashima> {

  Random rng;
  @override
  void initState() {
    super.initState();
    rng = Random(DateTime.now().millisecondsSinceEpoch);
  }

  Spell spell = Spell(null, null, 1.0);
  bool spellInHand = true;

  int mana = 0;
  int totalStormCount = 0;
  int totalResolved = 0;

  int howManyKrarks = 1;
  int howManyThumbs = 0;

  List<Trigger> triggers = [];


  /// Casts the spell and generates triggers
  void cast({@required bool automatic}) {
    assert(spell.cost != null);
    assert(spell.product != null);
    assert(spell.cost <= mana);

    triggers.clear();

    mana -= spell.cost; 

    ++totalStormCount;

    spellInHand = false;


    for(int i=0; i<howManyKrarks; i++){
      triggers.add(Trigger(howManyThumbs, rng));
    }
    
    refreshIf(!automatic);
  }

  void solveTrigger(Flip choice, {@required bool automatic}){
    triggers.removeLast();
    if(choice == Flip.bounce){
      spellInHand = true;
    } else {
      totalResolved++;
      /// resolve
      if(spell.chance == 1.0 || rng.nextDouble() < spell.chance){
        mana += spell.product;
      }
    }

    /// TODO: if this is the last trigger, and the spell never was bounced
    /// you should add one resolved spell (the orignal card) to the total 
    /// resolved count, and resolve that spell as well by producing the mana

    refreshIf(!automatic);
  }

  void reset() => setState((){
    this.mana = 0;
    this.totalStormCount = 0;
    this.totalResolved = 0;
    this.spellInHand = true;
    this.triggers.clear();
  });

  void refreshIf(bool v){
    if(v) refresh();
  }
  void refresh() => this.setState((){});


  void autoSolveTrigger(){
    Trigger trigger = triggers.last;
    Flip choice;
    if(spellInHand){
      if(trigger.containsCopy){
        choice = Flip.copy;
      } else {
        choice = Flip.bounce;
      }
    } else {
      if(trigger.containsBounce){
        choice = Flip.bounce;
      } else {
        choice = Flip.copy;
      }
    }
    solveTrigger(choice, automatic: true);
  }

  void keepCasting({
    @required int forUpTo,
  }){
    assert(spell.cost != null);
    assert(spell.product != null);
    assert(forUpTo != null);
    assert(forUpTo > 0);
    assert(forUpTo < 1000000000);

    int steps = 0;
    while(mana >= spell.cost && steps < forUpTo){
      ++steps;
      cast(automatic: true);
      for(final _ in triggers){
        autoSolveTrigger();
      }
    }

    refresh();
  }

  bool get canCast => false;
  //TODO: fai

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          spellSection,
          manaStormResolvedSection,
          triggersSection,
        ],
      ),
      bottom: actions,
    );
  }

  Widget get spellSection => ListTile(
    // TODO: fai
  );

  Widget get manaStormResolvedSection => ExtraButtons(children: [
    // TODO: fai
  ],);

  Widget get triggersSection => ListTile(
    // TODO: fai
  );

  Widget get actions => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        leading: Icon(ManaIcons.instant),
        title: Text("Cast spell"),
        onTap: canCast ? () => this.cast(automatic: false) : null,
      ),
      if(this.howManyKrarks > 1)
        ListTile(
          leading: Icon(ManaIcons.instant),
          title: Text("Keep casting/bouncing"),
          subtitle: Text("Until no bounce or 100 casts"),
          onTap: canCast ? () => this.keepCasting(forUpTo: 100) : null,
        ),
      ListTile(
        leading: Icon(Icons.refresh),
        title: Text("Reset"),
        onTap: reset,
      ),
    ],
  );


}


/// Mana burst spells cost X and give Y
class Spell {
  final int cost;
  final int product;
  final double chance; ///spells that not always resolve 
  const Spell(this.cost, this.product, this.chance);
}

class Trigger {
  
  List<Flip> flips;

  Trigger(int howManyThumbs, Random rng): flips = [
    for(int i=0; i<pow(2,howManyThumbs); ++i)
      (rng.nextInt(2) == 0) ? Flip.copy : Flip.bounce,
      /// nextInt(2) gives either 0 or 1, so this flips a coin
  ];

  bool get containsCopy => this.flips.contains(Flip.copy);
  bool get containsBounce => this.flips.contains(Flip.bounce);

}

enum Flip {bounce, copy}
