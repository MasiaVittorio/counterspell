import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';

class CSWidgets{
  static const Widget divider = const Padding(
    padding: const EdgeInsets.symmetric(horizontal:16.0),
    child: const Divider(height: 2.0,),
  );
  static const Widget deleteIcon = Icon(Icons.delete_forever, color: CSColors.delete,);
  static const Widget heigth10 = SizedBox(height: 10,);
}