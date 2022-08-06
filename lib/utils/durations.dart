extension TextFormat on Duration {

  String get textFormat{
    final int seconds = inSeconds;

    if(seconds < 60){ // 60 seconds
      return "${seconds}s";
    } 
    else if(seconds < 60*10){ // one to ten minutes
      final int minutes = (seconds/60).floor();
      final int remainder = seconds % 60;
      if(remainder == 0) {
        return "${minutes}m";
      } else {
        return "${minutes}m:${remainder}s";
      }
    } 
    else if(seconds < 60*60){ // ten to 60 minutes
      final int minutes = (seconds/60).floor();
      return "${minutes}m";
    } 
    else if(seconds < 60*60*4){ // 1 to 4 hours 
      final int hours = (seconds/(60*60)).floor();
      final int remainder = seconds % (60*60);
      final int mins = (remainder / 60).floor();
      if(mins == 0) return "${hours}h";
      return "${hours}h : ${mins}m";
    } 
    else { // over 4 hours
      final int hours = (seconds/(60*60)).floor();
      return "${hours}h";
    }
  }  
}