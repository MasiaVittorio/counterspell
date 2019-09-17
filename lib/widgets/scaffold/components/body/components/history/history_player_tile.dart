import 'package:counter_spell_new/blocs/sub_blocs/themer.dart';
import 'package:counter_spell_new/models/game/history_model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/models/game/types/damage_type.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
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

  static const double _height = 35;
  
  @override
  Widget build(BuildContext context) {
    final int increment = change.next - change.previous;
    final String incString = increment >= 0 ? "+ $increment" : "- ${increment.abs()}";
    
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

    final Color textColor = theme.data.colorScheme.onPrimary;
    
    final chip = Container(
      height: _height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(_height),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: _height,
            width: _height,
            child: IconTheme(
              data: theme.data.primaryIconTheme,
              child: Icon(
                icon,
                color: textColor,
                size: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 11.0),
            child: Text(
              incString,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      )
    );

    final littleDarker = theme.data
      .colorScheme
      .onSurface
      .withOpacity(0.1); 

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: littleDarker,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_height / 2),
            bottom: Radius.circular(_height / 2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            chip,
              Text(
              "= ${change.next}",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
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

