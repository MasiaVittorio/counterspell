import 'subsection.dart';
import 'package:flutter/material.dart';

class ExtraButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final double iconSize;

  ExtraButton({
    @required this.icon,
    @required this.text,
    @required this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SubSection(
      [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
          height: 32,
          child: Icon(icon, size: iconSize,),
        ),
        Container(
          alignment: Alignment.center,
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(text),
        ),
      ], 
      crossAxisAlignment: CrossAxisAlignment.center,
      onTap: onTap,
      margin: EdgeInsets.zero,
    );
  }
}