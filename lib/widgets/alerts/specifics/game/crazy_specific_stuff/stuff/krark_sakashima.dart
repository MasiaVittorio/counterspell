import 'dart:math';

/// Random number generating
var rng = Random();

bool get flip => rng.nextInt(2) == 0; // nextInt(2) gives either 0 or 1, so this flips a coin

///with N thumbs in play you get N extra flips before losing
bool flipWith(int thumbs){
  assert(thumbs >= 0);
  for(int i=0; i<thumbs+1; ++i){
    if(flip) return true;
  }
  return false;
}

/// Mana burst spells cost X and give Y
class Spell {
  final int cost;
  final int product;
  const Spell(this.cost, this.product);
}

const seethingSong = Spell(3,5);
const desperateRitual = Spell(2,3);

// main() {
  
//   int tryNtimes = 10001;
//   Spell spellToTry = seethingSong;
//   int howManyKrarks = 3; 
//   /// Krark
//   /// Sakashima
//   /// Other clones...
//   int howManyThumbs = 1;
//   /// Krark's thumb
//   /// Artifact clones...

//   var results = [
//     for(int i=0; i<tryNtimes; ++i)
//       trySpell(spellToTry, howManyKrarks, howManyThumbs)
//   ]; 

//   results.sort((a,b) => a.mana - b.mana);
//   print("mana median: ${results[tryNtimes~/2].mana}");
  
//   double average = [for(final r in results) r.mana]
//     .reduce((a, b) => a + b) / results.length;   
//   print("mana average: ${average.round()}");
// }

class Result {
  final int mana;
  final int steps;
  Result(this.mana, this.steps);
}

Result trySpell(Spell spell, int krarks, int thumbs){
  int mana = spell.cost;
  
  int steps = 0;
  while(mana >= spell.cost && steps<10000){
    ++steps;
    
    mana -= spell.cost; /// cast the spell

    int toHand = 0; /// how many coins will get the spell back to hand
    int copy = 0; /// and how many coins will copy the spell
    for(int i=0; i<krarks; i++){
      if(toHand == 0){ /// first we try to get tails at least one time
        if(flipWith(thumbs)){
          ++toHand;
        } else {
          ++copy;
        }
      } else { /// then if we already bounced, we try to get head to copy
        if(flipWith(thumbs)){
          ++copy;
        } else {
          ++toHand;
        }
      } /// maybe a less safe but more statistically rewarding
        /// algorythm can be found?
    }

    for(int i=0; i<copy; ++i){
      mana += spell.product;
    } /// for each copy, generate the mana
    if(toHand == 0) break;
    /// If we didn't get the spell bounced to hand, no more steps
  }
  
  return Result(mana, steps);
  
}