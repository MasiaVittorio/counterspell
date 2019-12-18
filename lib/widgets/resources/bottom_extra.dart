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
        Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 6.0),
          child: InkWell(
            onTap: this.onTap,
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