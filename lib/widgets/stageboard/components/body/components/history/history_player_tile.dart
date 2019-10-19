import 'package:counter_spell_new/blocs/sub_blocs/themer.dart';
import 'package:counter_spell_new/models/game/history_model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/models/game/types/damage_type.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/widgets/resources/chip.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/utils/divide_list.dart';

class HistoryPlayerTile extends StatelessWidget {

  //===================================
  // Data
  final DateTime time;
  final List<PlayerHistoryChange> changes;
  final bool partnerB;
  //===================================
  // UI resources
  final double tileSize;
  final double coreTileSize;
  final CSTheme theme;
  final Map<String, Counter> counters;
  final Map<CSPage,Color> pageColors;

  //===================================
  // Constructor
  const HistoryPlayerTile(this.changes, {
    @required this.partnerB,
    @required this.time,
    @required this.pageColors,
    @required this.tileSize,
    @required this.coreTileSize,
    @required this.counters,
    @required this.theme,
  });


  //===================================
  // Builder
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      for(final change in changes)
        if(!(
          change.type == DamageType.counters 
          && !counters.containsKey(change.counterName)
        )) _Change(
          change, 
          counters: counters,
          pageColors: pageColors,
          theme: theme,
          partnerB: this.partnerB ?? false,
        ),
    ];

    if(children.isEmpty) return SizedBox(height: tileSize,);

    return Container(
      height: tileSize,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Time(time),
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
                children: divideList(children, SizedBox(width: 4.0,)),
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

  final CSTheme theme;
  final Map<CSPage,Color> pageColors;
  final Map<String, Counter> counters;
  
  const _Change(this.change, {
    @required this.partnerB,
    @required this.theme,
    @required this.pageColors,
    @required this.counters,
  });

  
  @override
  Widget build(BuildContext context) {
    final int increment = change.next - change.previous;
    final String text = increment >= 0 ? "+ $increment" : "- ${increment.abs()}";
    final String subText = "= ${change.next}" + (
      ( this.partnerB 
        &&
        ( change.type == DamageType.commanderCast 
          || 
          ( change.type == DamageType.commanderDamage 
            && 
            change.attack) ) )

        ? change.partnerA ? " (A)" : " (B)"
        : "");


    final Color color = CSThemer.getHistoryChipColor(
      attack: change.attack,
      theme: theme,
      type: change.type,
      pageColors: pageColors,
    );

    final IconData icon = CSThemer.getHistoryChangeIcon(
      attack: change.attack,
      type: change.type,
      theme: theme,
      counterName: change.counterName,
      counters: counters,
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
  final DateTime time;
  const _Time(this.time);

  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, "0");
    final minutes = time.minute.toString().padLeft(2, "0");
    
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        "$hours: $minutes", 
        style: TextStyle(fontSize: 10),
      ),
    );
  }
}

