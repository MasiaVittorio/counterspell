import 'package:flutter/material.dart';


enum TimeMode{
  inGame,
  clock,
  none,
}

class TimeModes{
  static String? nameOf(TimeMode? mode) => map[mode!];
  static TimeMode? fromName(String? name) => reversed[name!];

  static const Map<TimeMode,String> map = <TimeMode,String>{
    TimeMode.inGame: "In game",
    TimeMode.clock: "Clock",
    TimeMode.none: "None",
  };
  static const Map<String,TimeMode> reversed = <String,TimeMode>{
    "In game": TimeMode.inGame,
    "Clock": TimeMode.clock,
    "None": TimeMode.none,
    "in game": TimeMode.inGame,
    "clock": TimeMode.clock,
    "none": TimeMode.none,
  };


  static const Map<TimeMode,IconData> icons = <TimeMode,IconData>{
    TimeMode.inGame: Icons.timelapse,
    TimeMode.clock: Icons.access_time,
    TimeMode.none: Icons.close,
  };
}