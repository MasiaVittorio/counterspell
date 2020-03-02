

extension ClosestMultiples on num {

  double closestMultipleOf(
    double _, 
    {
      bool upper = false,
      bool lower = false,
      bool closerToZero = false, 
      bool fartherFromZero = false,
      bool overshoot = false, //if the number is already a multiple, go to the next
    }
  ){
    final double of = _.abs();

    final double divided = this/of;

    int integer;
    if(upper ?? false) integer = divided.ceil();
    else if(lower ?? false) integer = divided.floor();
    else if(closerToZero ?? false) {
      if(divided >= 0) integer = divided.floor();
      else integer = divided.ceil();
    } 
    else if(fartherFromZero ?? false){
      if(divided >= 0) integer = divided.ceil();
      else integer = divided.floor();
    } 
    else integer = divided.round();

    final double result = integer * of;

    if(overshoot && result == this.toDouble()){
      return result + (upper ? 1.0*of : -1.0*of);
    } 

    return result;
  }
}
