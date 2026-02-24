import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/stage/body/group/player_tile_utilities.dart';

class ExtraInfo {
  final Color? color;
  final int value;
  final String? note;
  final IconData icon;

  const ExtraInfo({
    required this.icon,
    required this.color,
    required this.value,
    this.note,
  });

  static List<ExtraInfo> fromPlayer(
    String name, {
    required Map<String, PlayerState> ofGroup,
    required Map<DamageType, bool?> types,
    required Map<String, bool?> havingPartnerB,
    required Map<CSPage, Color?>? pageColors,
    required Color? defenseColor,
    required Map<String?, Counter> counterMap,
  }) {
    final state = ofGroup[name];
    final iHaveB = havingPartnerB[name] == true;
    return [
      if (types[DamageType.commanderCast]!)
        if (state!.cast.a != 0)
          ExtraInfo(
            color: pageColors![CSPage.commanderCast],
            icon: CSIcons.castFilled,
            value: state.cast.a,
            note: iHaveB ? "first" : null,
          ),
      if (types[DamageType.commanderCast]!)
        if (iHaveB)
          if (state!.cast.b != 0)
            ExtraInfo(
              color: pageColors![CSPage.commanderCast],
              icon: CSIcons.castFilled,
              value: state.cast.a,
              note: "second",
            ),
      if (types[DamageType.commanderDamage]!)
        for (final entry in state!.damages.entries) ...[
          if (entry.value.a != 0)
            ExtraInfo(
                color: defenseColor,
                icon: CSIcons.defenceFilled,
                value: entry.value.a,
                note: havingPartnerB[entry.key] == true
                    ? "${PTileUtils.subString(entry.key, 4)} (A)"
                    : PTileUtils.subString(entry.key, 5)),
          if (havingPartnerB[entry.key] == true)
            if (entry.value.b != 0)
              ExtraInfo(
                color: defenseColor,
                icon: CSIcons.defenceFilled,
                value: entry.value.b,
                note: "${PTileUtils.subString(entry.key, 4)} (B)",
              ),
        ],
      if (types[DamageType.commanderDamage]!)
        for (final otherEntry in ofGroup.entries) ...[
          if ((otherEntry.value.damages[name]?.a ?? 0) != 0)
            ExtraInfo(
                color: pageColors![CSPage.commanderDamage],
                icon: iHaveB ? CSIcons.attackTwo : CSIcons.attackOne,
                value: otherEntry.value.damages[name]!.a,
                note: iHaveB
                    ? "${PTileUtils.subString(otherEntry.key, 4)} (A)"
                    : PTileUtils.subString(otherEntry.key, 5)),
          if (iHaveB)
            if ((otherEntry.value.damages[name]?.b ?? 0) != 0)
              ExtraInfo(
                color: pageColors![CSPage.commanderDamage],
                icon: CSIcons.attackTwo,
                value: otherEntry.value.damages[name]!.b,
                note: "${PTileUtils.subString(otherEntry.key, 4)} (B)",
              ),
        ],
      if (types[DamageType.counters]!)
        for (final entry in state!.counters.entries)
          if (entry.value != 0)
            ExtraInfo(
              color: pageColors![CSPage.counters],
              value: entry.value,
              icon: counterMap[entry.key]!.icon,
              note: counterMap[entry.key]!.shortName,
            ),
    ];
  }
}
