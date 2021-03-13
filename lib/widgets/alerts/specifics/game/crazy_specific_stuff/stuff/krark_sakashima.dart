import 'package:counter_spell_new/core.dart';
import 'all.dart';
import 'dart:math';


class KrarkAndSakashima extends GenericAlert {
  static const String _title = "Krark & Sakashima";

  const KrarkAndSakashima(): super(
    700,
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

  _Spell spell = _Spell(0, 0, 1.0);
  bool spellInHand = true;

  int mana = 0;
  int totalStormCount = 0;
  int totalResolved = 0;

  int howManyKrarks = 1;
  int howManyThumbs = 0;

  List<_ThumbTrigger> triggers = [];


  /// Casts the spell and generates triggers
  void cast({@required bool automatic}) {
    assert(canCast);

    triggers.clear();

    mana -= spell.cost; 

    ++totalStormCount;

    spellInHand = false;


    for(int i=0; i<howManyKrarks; i++){
      triggers.add(_ThumbTrigger(howManyThumbs, rng));
    }
    
    refreshIf(!automatic);
  }

  void solveTrigger(_Flip choice, {@required bool automatic}){
    triggers.removeLast();
    if(choice == _Flip.bounce){
      spellInHand = true;
    } else {

      _solveSpell();

      /// if this was the last trigger, and the spell was never bounced
      /// you should add one resolved spell (the orignal card) to the total 
      /// resolved count, and resolve that spell as well by producing the mana
      if(triggers.isEmpty && !spellInHand){
        _solveSpell();
      }
    }


    refreshIf(!automatic);
  }

  void _solveSpell(){
    totalResolved++;
    /// resolve
    if(spell.chance == 1.0 || rng.nextDouble() < spell.chance){
      mana += spell.product;
    }
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
    _ThumbTrigger trigger = triggers.last;
    _Flip choice;
    if(spellInHand){
      if(trigger.containsCopy){
        choice = _Flip.copy;
      } else {
        choice = _Flip.bounce;
      }
    } else {
      if(trigger.containsBounce){
        choice = _Flip.bounce;
      } else {
        choice = _Flip.copy;
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
    while(canCast && steps < forUpTo){
      ++steps;
      cast(automatic: true);
      final n = triggers.length;
      for(int i=0; i<n; ++i){
        autoSolveTrigger();
      }
    }

    refresh();
  }

  bool get canCast 
    => spell != null 
    && spell.ok 
    && mana >= spell.cost 
    && spellInHand;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlertCustom(
      Material(
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertDrag(),
            krarkSection,
          ],
        ),
      ),
      titleSize: 79 + AlertDrag.height,
      canvasBackground: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          spellSection,
          statusSection,
          triggersSection,
        ],
      ),
      bottom: actions,
    );
  }

  Widget get krarkSection => ExtraButtons(children: [
    ExtraButton(
      text: "Krarks",
      icon: null,
      customIcon: Text("$howManyKrarks"),
      onTap: () => this.setState(() {
        ++howManyKrarks;
      }),
      onLongPress: () => this.setState(() {
        howManyKrarks = 1;        
      }),
    ),
    ExtraButton(
      text: "Thumbs",
      icon: null,
      customIcon: Text("$howManyThumbs"),
      onTap: () => this.setState(() {
        ++howManyThumbs;
      }),
      onLongPress: () => this.setState(() {
        howManyThumbs = 0;
      }),
    ),
  ],);

  Widget get spellSection => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SectionTitle("Spell"),
      SubSection([
        ExtraButtons(children: [
          ExtraButton(
            icon: null,
            customCircleColor: Colors.transparent,
            filled: true,
            customIcon: Text("${spell.cost}"),
            text: "Cost",
            onTap: () => this.setState(() {
              spell = _Spell(
                (spell.cost ?? 0) + 1,
                spell.product,
                spell.chance,
              );    
            }),
            onLongPress: () => this.setState(() {
              spell = _Spell(
                0,
                spell.product,
                spell.chance,
              );    
            }),
          ),
          ExtraButton(
            icon: null,
            customCircleColor: Colors.transparent,
            filled: true,
            customIcon: Text("${spell.product}"),
            text: "Produces",
            onTap: () => this.setState(() {
              spell = _Spell(
                spell.cost,
                (spell.product ?? 0) + 1,
                spell.chance,
              );    
            }),
            onLongPress: () => this.setState(() {
              spell = _Spell(
                spell.cost,
                0,
                spell.chance,
              );    
            }),
          ),
          ExtraButton(
            icon: spellInHand ? McIcons.cards_outline : ManaIcons.flashback,
            customCircleColor: Colors.transparent,
            filled: true,
            text: spellInHand ? "In hand" : "In yard",
            onTap: () => this.setState((){
              spellInHand = !spellInHand;
            }),
          ),
          // ExtraButton(
          //   icon: null,
          //   customCircleColor: Colors.transparent,
          //   filled: true,
          //   customIcon: Text("${(spell.chance*100).round()}%"),
          //   text: "Chance",
          //   onTap: () {
          //     // TODO: slider per la chance, non puoi andare su altri alert o perdi questo status
          //   }
          // ),
        ],)
      ]),
    ],
  );

  Widget get statusSection => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SectionTitle("Status"),
      ExtraButtons(children: [
          ExtraButton(
            icon: null,
            customIcon: Text("$mana"),
            text: "Mana Pool",
            onTap: () => this.setState(() {
              mana++;
            }),
            onLongPress: () => this.setState(() {
              mana = 0;
            }),
          ),
          ExtraButton(
            icon: null,
            customIcon: Text("$totalStormCount"),
            text: "Storm count",
            onTap: null,
            onLongPress: () => this.setState(() {
              totalStormCount = 0;
            }),
          ),
          ExtraButton(
            icon: null,
            customIcon: Text("$totalResolved"),
            text: "Resolved",
            onTap: null,
            onLongPress: () => this.setState(() {
              totalResolved = 0;
            }),
          ),
      ],),
      CSWidgets.divider,
    ],
  );

  Widget get triggersSection => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // const SectionTitle("Triggers"),
        Row(children: <Widget>[
          if(triggers.isNotEmpty) Expanded(flex: 6, child: SubSection(((){
              final _ThumbTrigger trigger = triggers.last;
              final flips = trigger.flips;
              final howManyFlips = flips.length;
              final int copies = ([
                for(final f in flips) 
                  if(f == _Flip.copy) "",
              ]).length;
              final int bounces = howManyFlips - copies;

              return <Widget>[
                SectionTitle("Current trigger ($howManyFlips coin ${howManyFlips > 1 ? "flips" : "flip"})"),
                ExtraButtons(children: <Widget>[
                  ExtraButton(
                    customCircleColor: Colors.transparent,
                    filled: true,
                    icon: null,
                    customIcon: Text("$copies"),
                    onTap: copies > 0 
                      ? () => solveTrigger(_Flip.copy, automatic: false) 
                      : null,
                    text: "Heads\n(copy)",
                    twoLines: true,
                  ), 
                  ExtraButton(
                    customCircleColor: Colors.transparent,
                    filled: true,
                    icon: null,
                    customIcon: Text("$bounces"),
                    onTap: bounces > 0 
                      ? () => solveTrigger(_Flip.bounce, automatic: false) 
                      : null,
                    text: "Tails\n(bounce)",
                    twoLines: true,
                  ), 
                ],),
              ];
            }()),
          ),),

          if(triggers.length > 1) Expanded(flex: 2, child: ExtraButton(
            filled: false,
            onTap: null,
            text: "More\ntriggers",
            twoLines: true,
            icon: null,
            customIcon: Text("${triggers.length - 1}"),
          )),
          
          if(triggers.isEmpty) Expanded(child: SubSection([
            ListTile(title: Text("No trigger left"),),
          ]),),
        ],),
      ],
    ),
  );

  Widget get actions {
    final error = TextStyle(color: Theme.of(context).colorScheme.error);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(ManaIcons.instant),
          title: Text(canCast ? "Cast spell" : "Can't cast spell"),
          subtitle: canCast ? null : 
            mana < spell.cost ? Text("Missing mana", style: error,)
            : !spellInHand ? Text("Spell in graveyard", style: error,)
            : !spell.ok ? Text("Missing data", style: error,)
            : null,
          onTap: canCast ? () => this.cast(automatic: false) : null,
        ),
        if(this.howManyKrarks > 1 && canCast)
          ListTile(
            leading: Icon(ManaIcons.instant),
            title: Text("Keep casting/bouncing"),
            subtitle: Text("Until no bounce or 100 casts"),
            onTap: canCast ? () => this.keepCasting(forUpTo: 100) : null,
          ),
        // ListTile(
        //   leading: Icon(Icons.refresh),
        //   title: Text("Reset"),
        //   onTap: reset,
        // ),
      ],
    );
  }


}


/// Mana burst spells cost X and give Y
class _Spell {
  final int cost;
  final int product;
  final double chance; ///spells that not always resolve 
  const _Spell(this.cost, this.product, this.chance);

  bool get ok => cost != null && product != null && chance != null;
}

class _ThumbTrigger {
  
  List<_Flip> flips;

  _ThumbTrigger(int howManyThumbs, Random rng): flips = [
    for(int i=0; i<pow(2,howManyThumbs); ++i)
      (rng.nextInt(2) == 0) ? _Flip.copy : _Flip.bounce,
      /// nextInt(2) gives either 0 or 1, so this flips a coin
  ];

  bool get containsCopy => this.flips.contains(_Flip.copy);
  bool get containsBounce => this.flips.contains(_Flip.bounce);

}

enum _Flip {bounce, copy}



// TODO: extrabutton: fai che il contenuto possa overfloware oltre il cerchietto se è tutto filled

