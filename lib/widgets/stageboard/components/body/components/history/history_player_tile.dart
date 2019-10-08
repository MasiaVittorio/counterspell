import 'package:counter_spell_new/blocs/sub_blocs/themer.dart';
import 'package:counter_spell_new/models/game/history_model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/models/game/types/damage_type.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/widgets/resources/chip.dart';
import 'package:flutter/material.dart';

class HistoryPlayerTile extends StatelessWidget {

  //===================================
  // Data
  final DateTime time;
  final List<PlayerHistoryChange> changes;

  //===================================
  // UI resources
  final double tileSize;
  final double coreTileSize;
  final CSTheme theme;
  final Map<String, Counter> counters;

  //===================================
  // Constructor
  const HistoryPlayerTile(this.changes, {
    @required this.time,

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
          theme: theme,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ],
      ),
    );
  }
}

class _Change extends StatelessWidget {
  final PlayerHistoryChange change;

  final CSTheme theme;
  final Map<String, Counter> counters;
  
  const _Change(this.change, {
    @required this.theme,
    @required this.counters,
  });

  
  @override
  Widget build(BuildContext context) {
    final int increment = change.next - change.previous;
    final String text = increment >= 0 ? "+ $increment" : "- ${increment.abs()}";
    final String subText = "= ${change.next}";

    final Color color = CSThemer.getHistoryChipColor(
      attack: change.attack,
      theme: theme,
      type: change.type,
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

