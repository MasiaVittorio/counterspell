import 'package:flutter/material.dart';


enum TimeMode{
  inGame,
  clock,
  none,
}

class TimeModes{
  static String nameOf(TimeMode mode) => map[mode];
  static TimeMode fromName(String name) => reversed[name];

  static const Map<TimeMode,String> map = <TimeMode,String>{
    TimeMode.inGame: "in game",
    TimeMode.clock: "clock",
    TimeMode.none: "none",
  };
  static const Map<String,TimeMode> reversed = <String,TimeMode>{
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