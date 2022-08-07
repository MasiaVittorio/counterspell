import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stage/body/history/history_tile.dart';

class HistoryPlayerTile extends StatelessWidget {

  //===================================
  // Data
  final DateTime? time;
  final DateTime? firstTime;
  final List<PlayerHistoryChange>? changes;
  final bool partnerB;
  //===================================
  // UI resources
  final double? tileSize;
  // final double coreTileSize;
  final Color defenceColor;
  final Map<String?, Counter> counters;
  final Map<CSPage?,Color?>? pageColors;

  //===================================
  // Constructor
  const HistoryPlayerTile(this.changes, {
    required this.partnerB,
    required this.time,
    required this.firstTime,
    required this.pageColors,
    required this.tileSize,
    // @required this.coreTileSize,
    required this.counters,
    required this.defenceColor,
  });


  //===================================
  // Builder
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      for(final change in changes!)
        if(!(
          change.type == DamageType.counters 
          && !counters.containsKey(change.counter!.longName)
        )) _Change(
          change, 
          // counters: counters,
          pageColors: pageColors,
          defenceColor: defenceColor,
          partnerB: partnerB,
        ),
    ];

    if(children.isEmpty) return SizedBox(height: tileSize,);

    return SizedBox(
      height: tileSize,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Time(time, first: firstTime,),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 4.0, bottom: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: SidChip.backgroundColor(Theme.of(context)),
                borderRadius: BorderRadius.circular(SidChip.height/2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children.separateWith(const SizedBox(width: 4.0,)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Change extends StatelessWidget {
  final PlayerHistoryChange change;
  final bool partnerB;

  final Color defenceColor;
  final Map<CSPage?,Color?>? pageColors;
  // final Map<String, Counter> counters;
  
  const _Change(this.change, {
    required this.partnerB,
    required this.defenceColor,
    required this.pageColors,
    // @required this.counters,
  });

  
  @override
  Widget build(BuildContext context) {
    final int increment = change.next! - change.previous!;
    final String text = increment >= 0 ? "+ $increment" : "- ${increment.abs()}";
    final String subText = "= ${change.next}${( partnerB 
        &&
        ( change.type == DamageType.commanderCast 
          || 
          ( change.type == DamageType.commanderDamage 
            && 
            change.attack!) ) )

        ? change.partnerA! ? " (A)" : " (B)"
        : ""}";


    final Color? color = CSThemer.getHistoryChipColor(
      attack: change.attack,
      defenceColor: defenceColor,
      type: change.type,
      pageColors: pageColors,
    );

    final IconData? icon = CSThemer.getHistoryChangeIcon(
      attack: change.attack,
      type: change.type,
      defenceColor: defenceColor,
      counter: change.counter,
    );

  	return SidChip(
      icon: icon,
      subText: subText,
      text: text,
      color: color,
    );
  }

}

class _Time extends StatelessWidget {
  final DateTime? time;
  final DateTime? first;
  const _Time(this.time, {required this.first});

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.settings.gameSettings.timeMode.build((_, mode) => Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        HistoryTile.timeString(time, first, mode), 
        style: const TextStyle(fontSize: 10),
      ),
    ));
  }
}

