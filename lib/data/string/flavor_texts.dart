import 'dart:math';
import 'package:counter_spell_new/core.dart';


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
    "Fodder Cannon": fodderCannon,
    "Balshan Collaborator": balshanCollaborator,
    "Ignite The Beacon": igniteTheBeacon,
    "Deranged Assistant": derangedAssistant,
    "Goblin Piledriver": goblinPiledriver,
    "Darksteel Plate": darksteelPlate,
    "Goblin Balloon Brigade": goblinBalloonBrigade,
    "Enormous Baloth": enormousBaloth,
  };

  static const String fodderCannon = 
"""Step 1: Find your cousin.
Step 2: Get your cousin in the cannon.
Step 3: Find another cousin.""";
  static const String balshanCollaborator = "Power, gold, crackers--every bird has its price.";
  static const String igniteTheBeacon = "If you can’t save yourself, you fight to give someone else a chance.";
  static const String derangedAssistant = "Garl, adjust the slurry dispensers. Garl, fetch more corpses. Garl, quit crying and give me your brain tissue. If he doesn't stop being so rude, I'm quitting.";
  static const String goblinPiledriver = "Throw enough goblins at any problem and it should go away. At the very least, there will be fewer goblins.";
  static const String darksteelPlate = '"If there can be no victory, then I will fight forever."';
  static const String goblinBalloonBrigade = '"The enemy is getting too close! Quick! Inflate the toad!"';
  static const String enormousBaloth = "Its diet consists of fruits, plants, small woodlands animals, large woodlands animals, woodlands, fruit groves, fruit farmers, and small cities.";
  static const String rancor = "Hatred outlives the hateful.";
  static const String nihilisticGlee = "All ends in obliteration — love in hatred, life in death, and light in empty darkness.";
  static const String crystalQuarry = "How tragic that greed eclipses beauty.";
  static const String squanderedResources = "He traded sand for skins, skins for gold, gold for life. In the end, he traded life for sand.";
  static const String boldwyrIntimidator = "Now everyone knows what you are";
  static const String nivMizzet = r"(Z–gt;)90º—(E–N²W)90ºt = 1";
  static const String sizzle = 'Of course you should fight fire with fire. You should fight everything with fire.';
  static const String meddle = "Strength may win the fight, but style wins the crowd.";

  static String get random => map.values.elementAt(Random(DateTime.now().millisecondsSinceEpoch).nextInt(map.values.length-1));
}

class QuoteTile extends StatelessWidget {

  const QuoteTile();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Stage.of(context)!.showAlert(
        const QuotesAlert(),
        size: QuotesAlert.height,
      ),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal:16.0),
        child: Text(
          FlavorTexts.random, 
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}