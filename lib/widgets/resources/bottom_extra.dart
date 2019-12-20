import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';

class BottomExtra extends StatelessWidget {

  final Widget text;
  final VoidCallback onTap;
  const BottomExtra(this.text, {@required this.onTap});

  @override
  Widget build(BuildContext context) 
    => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // const Divider(),
        InkWell(
          onTap: this.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: DefaultTextStyle(
                  style: TextStyle(
                    inherit: true,
                    fontWeight: FontWeight.bold,
                    color: RightContrast(Theme.of(context)).onCanvas,
                  ),
                  child: text,
                ),
              ),
            ),
          ),
        ),
      ],
    );

}