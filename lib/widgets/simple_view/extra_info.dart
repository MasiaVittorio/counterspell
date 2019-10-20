import 'package:counter_spell_new/models/game/model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/models/game/types/damage_type.dart';
import 'package:counter_spell_new/models/ui/type_ui.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/widgets/stageboard/components/body/components/group/player_tile_utilities.dart';
import 'package:flutter/material.dart';

class ExtraInfo {
  final Color color;
  final int value;
  final String note;
  final IconData icon;
  const ExtraInfo({
    @required this.icon,
    @required this.color,
    @required this.value,
    this.note,
  });
  static List<ExtraInfo> fromPlayer(String name, {
    @required Map<String, PlayerState> ofGroup,
    @required Map<DamageType, bool> types,
    @required Map<String, bool> havingPartnerB,
    @required Map<CSPage,Color> pageColors,
    @required CSTheme theme,
    @required Map<String,Counter> counterMap,
  }){
    final state = ofGroup[name];
    final iHaveB = havingPartnerB[name] == true;
    return [
      //TODO: implement counters
      if(types[DamageType.commanderCast])
      if(state.cast.a != 0)
        ExtraInfo(
          color: pageColors[CSPage.commanderCast],
          icon: CSTypesUI.castIconFilled,
          value: state.cast.a,
          note: iHaveB ? "first" : null,
        ),
      if(types[DamageType.commanderCast])
      if(iHaveB)
      if(state.cast.b != 0)
        ExtraInfo(
          color: pageColors[CSPage.commanderCast],
          icon: CSTypesUI.castIconFilled,
          value: state.cast.a,
          note: "second",
        ),
      if(types[DamageType.commanderDamage])
      for(final entry in state.damages.entries)
        ...[
          if(entry.value.a!=0)
            ExtraInfo(
              color: theme.commanderDefence,
              icon: CSTypesUI.defenceIconFilled,
              value: entry.value.a,
              note: "${PTileUtils.subString(entry.key,3)}"+ (havingPartnerB[entry.key] == true 
                ? " (A)"
                : ""
              ),
            ),
          if(havingPartnerB[entry.key] == true)
          if(entry.value.b!=0)
            ExtraInfo(
              color: theme.commanderDefence,
              icon: CSTypesUI.defenceIconFilled,
              value: entry.value.a,
              note: "${PTileUtils.subString(entry.key,3)} (B)",
            ),
        ],
      if(types[DamageType.commanderDamage])
      for(final otherEntry in ofGroup.entries)
        ...[
          if((otherEntry.value.damages[name]?.a ?? 0) != 0)
            ExtraInfo(
              color: pageColors[CSPage.commanderDamage],
              icon: iHaveB ? CSTypesUI.attackIconTwo : CSTypesUI.attackIconOne,
              value: otherEntry.value.damages[name].a,
              note: "${PTileUtils.subString(otherEntry.key,3)}"+ (
                iHaveB ? " (A)" : ""
              ),
            ),
          if(iHaveB)
          if((otherEntry.value.damages[name]?.b ?? 0) != 0)
            ExtraInfo(
              color: pageColors[CSPage.commanderDamage],
              icon: CSTypesUI.attackIconTwo,
              value: otherEntry.value.damages[name].b,
              note: "${PTileUtils.subString(otherEntry.key,3)} (B)",
            ),
        ],
      if(types[DamageType.counters])
      for(final entry in state.counters.entries)
        if(entry.value != 0)
          ExtraInfo(
            color: pageColors[CSPage.counters],
            value: entry.value,
            icon: counterMap[entry.key].icon,
            note: counterMap[entry.key].shortName,
          ),
      
    ];
  }
}


