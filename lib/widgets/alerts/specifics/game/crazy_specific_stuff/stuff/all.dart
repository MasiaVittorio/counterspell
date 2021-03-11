export 'krark_sakashima.dart';
import 'package:flutter/material.dart';

// TODO: migliora e implementa in stage? lol
abstract class GenericAlert extends StatelessWidget {
  final double size;
  final String title;
  final Set<String> tags;

  const GenericAlert(this.size, this.title, this.tags);
}

