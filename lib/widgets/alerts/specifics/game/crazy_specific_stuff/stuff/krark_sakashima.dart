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

  Random? rng;
  @override
  void initState() {
    super.initState();
    rng = Random(DateTime.now().millisecondsSinceEpoch);
  }

  _Spell spell = _Spell(0, 0, 1.0);
  _Zone? spellPlace = _Zone.hand;

  int mana = 0;
  int totalStormCount = 0;
  int totalResolved = 0;

  int howManyKrarks = 1;
  int howManyThumbs = 0;

  List<_ThumbTrigger> triggers = [];

  bool keepBouncing = false;
  int maxCasts = 100;


  /// Casts the spell and generates triggers
  void cast({required bool automatic}) {
    assert(canCast);

    triggers.clear();

    mana -= spell.cost; 

    ++totalStormCount;

    spellPlace = _Zone.stack;


    for(int i=0; i<howManyKrarks; i++){
      triggers.add(_ThumbTrigger(howManyThumbs, rng));
    }
    
    refreshIf(!automatic);
  }

  void solveTrigger(_Flip choice, {required bool automatic}){
    triggers.removeLast();
    if(choice == _Flip.bounce){
      spellPlace = _Zone.hand;
      /// could already be bounced in hand from another trigger, but that does not
      /// change how the current trigger can still copy the latest known spell information
      /// and setting spellPlace = hand more than one time has no effect
    } else {

      _solveSpell();

      /// if this was the last trigger, and the spell was never bounced
      /// you should add one resolved spell (the orignal card) to the total 
      /// resolved count, and resolve that spell as well by producing the mana
      if(triggers.isEmpty && spellPlace == _Zone.stack){
        _solveSpell();
        spellPlace = _Zone.graveyard;
      }
    }


    refreshIf(!automatic);
  }

  void _solveSpell(){
    totalResolved++;
    /// resolve
    if(spell.chance == 1.0 || rng!.nextDouble() < spell.chance){
      mana += spell.product;
    }
  }

  void reset() => setState((){
    this.mana = 0;
    this.totalStormCount = 0;
    this.totalResolved = 0;
    this.spellPlace = _Zone.hand;
    this.triggers.clear();
  });

  void refreshIf(bool v){
    if(v) refresh();
  }
  void refresh() => this.setState((){});


  void autoSolveTrigger(){
    _ThumbTrigger trigger = triggers.last;
    _Flip choice;
    if(spellPlace == _Zone.hand){ /// If already bounced, try to copy
      if(trigger.containsCopy){
        choice = _Flip.copy;
      } else {
        choice = _Flip.bounce;
      }
    } else { /// If still on the stack, try to bounce
      if(trigger.containsBounce){
        choice = _Flip.bounce;
      } else {
        choice = _Flip.copy;
      }
    }
    solveTrigger(choice, automatic: true);
  }

  void keepCasting({
    required int forUpTo,
  }){
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
    => mana >= spell.cost 
    && spellPlace == _Zone.hand;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlertCustom(
      Material(
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AlertDrag(),
            krarkSection,
            CSWidgets.height10,
          ],
        ),
      ),
      titleSize: 89 + AlertDrag.height,
      canvasBackground: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          spellSection,
          CSWidgets.height10,
          CSWidgets.divider,
          statusSection,
          CSWidgets.height5,
          CSWidgets.divider,
          triggersSection,
        ],
      ),
      bottom: actions,
    );
  }

  Widget get krarkSection => SubSection([
    ExtraButtons(children: [
      ExtraButton(
        text: "# of Krarks",
        icon: null,
        customCircleColor: Colors.transparent,
        customIcon: Text("$howManyKrarks"),
        onTap: () => this.setState(() {
          ++howManyKrarks;
        }),
        onLongPress: () => this.setState(() {
          howManyKrarks = 1;        
        }),
      ),
      ExtraButton(
        text: "# of Thumbs",
        icon: null,
        customCircleColor: Colors.transparent,
        customIcon: Text("$howManyThumbs"),
        onTap: () => this.setState(() {
          ++howManyThumbs;
        }),
        onLongPress: () => this.setState(() {
          howManyThumbs = 0;
        }),
      ),
    ],),
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
            customIcon: Text("${spell.cost}"),
            text: "Mana\ncost",
            twoLines: true,
            onTap: () => this.setState(() {
              spell = _Spell(
                (spell.cost) + 1,
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
            customIcon: Text("${spell.product}"),
            text: "Mana\nproduct",
            twoLines: true,
            onTap: () => this.setState(() {
              spell = _Spell(
                spell.cost,
                (spell.product) + 1,
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
            icon: <_Zone, IconData>{
              _Zone.hand: McIcons.cards_outline,
              _Zone.graveyard: ManaIcons.flashback,
              _Zone.stack: ManaIcons.instant,
            }[spellPlace!] ?? Icons.error,
            customCircleColor: Colors.transparent,
            text: (const <_Zone, String>{
              _Zone.hand: "Now\nin hand",
              _Zone.graveyard: "Now\nin yard",
              _Zone.stack: "On the\nstack",
            })[spellPlace!] ?? Icons.error as String?,
            twoLines: true,
            onTap: () => this.setState((){
              spellPlace = (const{
                _Zone.hand: _Zone.stack,
                _Zone.stack: _Zone.graveyard,
                _Zone.graveyard: _Zone.hand,
              })[spellPlace!];
            }),
          ),
          
          // TODO: slider per la chance, non puoi andare su altri alert o perdi questo state
          
        ],),
      ]),
    ],
  );

  Widget get statusSection => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SectionTitle("Status"),
      Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 6.0),
        child: Row(children: [
          Expanded(child: ExtraButton(
            icon: null,
            filled: true,
            customIcon: AnimatedText("$mana"),
            text: "Mana Pool",
            onTap: () => this.setState(() {
              mana++;
            }),
            onLongPress: () => this.setState(() {
              mana = 0;
            }),
          ),),
          Expanded(child: ExtraButton(
            icon: null,
            customIcon: AnimatedText("$totalStormCount"),
            text: "Storm count",
            onTap: null,
            onLongPress: () => this.setState(() {
              totalStormCount = 0;
            }),
          ),),
          const ExtraButtonDivider(),
          Expanded(child: ExtraButton(
            icon: null,
            customIcon: AnimatedText("$totalResolved"),
            text: "Resolved",
            onTap: null,
            onLongPress: () => this.setState(() {
              totalResolved = 0;
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
                SectionTitle("Trigger #${triggers.length} ${howManyThumbs > 0 ? "($howManyThumbs thumbs)" : "(regular flip)"}"),
                if(howManyFlips > 1) ExtraButtons(children: <Widget>[
                  ExtraButton(
                    customCircleColor: Colors.transparent,
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
                    icon: null,
                    customIcon: Text("$bounces"),
                    onTap: bounces > 0 
                      ? () => solveTrigger(_Flip.bounce, automatic: false) 
                      : null,
                    text: "Tails\n(bounce)",
                    twoLines: true,
                  ), 
                ],)
                else ExtraButtons(children: <Widget>[
                  ExtraButton(
                    icon: copies > 0 ? Icons.check : Icons.close,
                    onTap: null,
                    text: copies > 0 ? "Heads\n(copy)" : "Tails\n(bounce)",
                    twoLines: true,
                  ),
                  ExtraButton(
                    customCircleColor: Colors.transparent,
                    icon: Icons.keyboard_arrow_right,
                    onTap: () => solveTrigger(flips.first, automatic: false),
                    text: "Ok\n(${triggers.length > 1 ? "next" : "finish"})",
                    twoLines: true,
                  ), 
                ],)
 
              ];
            }()),
          ),),

          if(triggers.isNotEmpty) Expanded(flex: 2, child: ExtraButton(
            onTap: null,
            text: "More\ntriggers",
            twoLines: true,
            icon: null,
            customIcon: Text(triggers.length <= 1 ? "No" : "${triggers.length - 1}"),
          )),
          
          if(triggers.isEmpty) const Expanded(child: SubSection([
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
        CSWidgets.height10,
        SubSection([
          ListTile(
            leading: Icon(ManaIcons.instant),
            title: AnimatedText(canCast 
              ? "Cast spell ${(keepBouncing && howManyKrarks > 1) ? "(auto)" : "(manual)"}" 
              : "Can't cast spell"
            ),
            subtitle: canCast ? null : 
              mana < spell.cost ? Text("Missing mana", style: error,)
              : !(spellPlace == _Zone.hand) ? Text("Spell out of hand", style: error,)
              : null,
            onTap: canCast ? (
              (keepBouncing && howManyKrarks > 1) 
                ? () => this.keepCasting(forUpTo: maxCasts)
                : () => this.cast(automatic: false)
              ) : null,
          ),
        ],),

        SwitchListTile(
          value: this.howManyKrarks > 1 && keepBouncing,
          onChanged: (this.howManyKrarks > 1 && canCast) ? (v) => this.setState(() {
            keepBouncing = v;
          }) : null,
          title: Text("Keep casting/bouncing"),
          subtitle: Text("Until no bounce or $maxCasts casts"),
        )

      ],
    );
  }


}

enum _Zone {
  hand,
  graveyard,
  stack,
}


/// Mana burst spells cost X and give Y
class _Spell {
  final int cost;
  final int product;
  final double chance; ///spells that not always resolve 
  const _Spell(this.cost, this.product, this.chance);

}

class _ThumbTrigger {
  
  List<_Flip> flips;

  _ThumbTrigger(int howManyThumbs, Random? rng): flips = [
    for(int i=0; i<pow(2,howManyThumbs); ++i)
      (rng!.nextInt(2) == 0) ? _Flip.copy : _Flip.bounce,
      /// nextInt(2) gives either 0 or 1, so this flips a coin
  ];

  bool get containsCopy => this.flips.contains(_Flip.copy);
  bool get containsBounce => this.flips.contains(_Flip.bounce);

}

// TODO: extrabutton: fai che il contenuto possa overfloware oltre il cerchietto se è tutto filled

enum _Flip {bounce, copy}




