import 'package:flutter/material.dart';

import 'hint.dart';

export 'hint.dart';

class TutorialData {

  const TutorialData({
    required this.icon,
    required this.title,
    required this.hints,
  });

  final IconData icon;
  final String title;
  final List<Hint> hints;

}