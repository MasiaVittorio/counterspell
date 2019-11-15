import 'dart:math';

class FlavorTexts{
  static const Map<String,String> map = <String,String>{
    "Rancor": rancor,
    "Nihilistic Glee": nihilisticGlee,
    "Crystal Quarry": crystalQuarry,
    "Squandered Resources": squanderedResources,
    "Boldwyr Intimidator": boldwyrIntimidator,
    "Niv-Mizzet, the Firemind": nivMizzet,
    "Sizzle": sizzle,
    "Meddle": meddle,
  };

  static const String rancor = "Hatred outlives the hateful.";
  static const String nihilisticGlee = "All ends in obliteration — love in hatred, life in death, and light in empty darkness.";
  static const String crystalQuarry = "How tragic that greed eclipses beauty.";
  static const String squanderedResources = "He traded sand for skins, skins for gold, gold for life. In the end, he traded life for sand.";
  static const String boldwyrIntimidator = "Now everyone knows what you are";
  static const String nivMizzet = r"(Z–gt;)90º—(E–N²W)90ºt = 1";
  static const String sizzle = "Of course you should fight fire with fire. You should fight everything with fire.";
  static const String meddle = "Strength may win the fight, but style wins the crowd.";

  static String get random => map.values.elementAt(Random(DateTime.now().millisecondsSinceEpoch).nextInt(map.values.length-1));
}