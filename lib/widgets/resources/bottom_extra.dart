import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';

class BottomExtra extends StatelessWidget {

  final Widget text;
  final VoidCallback onTap;
  final IconData icon;
  const BottomExtra(this.text, {@required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) 
    => InkWell(
      onTap: this.onTap,
      child: Container(
        height: 40,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            DefaultTextStyle(
              style: TextStyle(
                inherit: true,
                fontWeight: FontWeight.bold,
                color: RightContrast(Theme.of(context)).onCanvas,
              ),
              child: text,
            ),
            if(icon != null)  
              Icon(icon),
          ],
        ),
      ),
    );

}