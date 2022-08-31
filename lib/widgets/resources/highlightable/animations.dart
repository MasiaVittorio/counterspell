import 'package:flutter/material.dart';
import 'package:sid_utils/sid_utils.dart';

class HighlightAnimations {
  
  static const Duration duration = Duration(milliseconds: 1100);

  static const Curve _breathIn = Cubic(.26,0,.03,.97);
  static const Curve _breathOut = Cubic(.26,0,.29,.98);
  static const _inFrac = 0.65;

  // goes to 1.0 and then back
  static double breath(double t) {
    if(t < _inFrac){
      return _breathIn.transform(t.mapToRange(0, 1, fromMax: _inFrac));
    } else {
      return 1 - _breathOut.transform(t.mapToRange(0, 1, fromMin: _inFrac));
    }
  }
  
  // first arrives at 0.5, then proceeds to 1.0
  static double slide(double t) {
    if(t < _inFrac){
      return _breathIn.transform(t / _inFrac) / 2;
    } else {
      return _breathOut.transform((t-_inFrac) / (1 - _inFrac)) / 2 + 0.5;
    }
  }

  // goes to 0.0 in half the time, stays there
  static double circleSize(double t) {
    if(t < _inFrac){
      return _breathIn.transform(t / _inFrac);
    } else {
      return 1.0;
    }
  }

  // stays at 1.0 for half the time then starts to go to zero
  static double circleOpacity(double t) {
    if(t < _inFrac){
      return 1.0;
    } else {
      return 1 - _breathOut.transform(t.mapToRange(0, 1, fromMin: _inFrac));
    }
  }


}