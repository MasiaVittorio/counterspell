import 'all.dart';

abstract class PlayerAction{

  //=====================================
  // To be abstracted

  const PlayerAction();
  PlayerState apply(PlayerState state);
  PlayerAction normalizeOn(PlayerState state);


  //=====================================
  // Factory

  factory PlayerAction.fromStates({
    required PlayerState previous,
    required PlayerState next,
    required Map<String,Counter> counterMap,
    int? minVal, 
    int? maxVal,
  }){
    List<PlayerAction> detectedAcions = [];

    final deltaLife = next.life- previous.life;
    if(deltaLife != 0) {
      detectedAcions.add(PALife(
        deltaLife, 
        minVal: minVal, 
        maxVal: maxVal,
      ));
    }

    for(final name in previous.damages.keys){
      final deltaA = next.damages[name]!.a - previous.damages[name]!.a;
      if(deltaA != 0) {
        detectedAcions.add(PADamage( name, deltaA,
          settings: CommanderSettings.off,
          partnerA: true,
          maxVal: maxVal,
          minLife: minVal,
        ));
      }
      final deltaB = next.damages[name]!.b - previous.damages[name]!.b;
      if(deltaB != 0) {
        detectedAcions.add(PADamage(name, deltaB,
          settings: CommanderSettings.off,
          partnerA: false,
          maxVal: maxVal,
          minLife: minVal,
        ));
      }
    }

    final deltaA = next.cast.a - previous.cast.a;
    if(deltaA != 0) {
      detectedAcions.add(PACast(
        deltaA,
        partnerA: true,
        maxVal: maxVal,
      ));
    }
    final deltaB = next.cast.b - previous.cast.b;
    if(deltaB != 0) {
      detectedAcions.add(PACast(
        deltaB,
        partnerA: false,
        maxVal: maxVal,
      ));
    }
    
    final Set<String?> counters = <String>{
      ...next.counters.keys,
      ...previous.counters.keys,
    };
    for(final counter in counters){
      final deltaCounter = (next.counters[counter] ?? 0) - (previous.counters[counter] ?? 0);
      if(deltaCounter != 0) {
        detectedAcions.add(PACounter(
          deltaCounter,
          counterMap[counter]!,
          minVal: minVal ?? PlayerState.kMinValue,
          maxVal: maxVal ?? PlayerState.kMaxValue,
        ));
      }
    }

    if(detectedAcions.isEmpty) {
      return const PANull();
    }

    if(detectedAcions.length == 1) {
      return detectedAcions.first;
    }

    return PACombined(detectedAcions);
  }

}
