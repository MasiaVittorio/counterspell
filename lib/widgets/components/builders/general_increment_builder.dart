import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class GeneralIncrementBuilder extends StatelessWidget {
  const GeneralIncrementBuilder({super.key, required this.builder, this.child});

  final ChildValueBuilder<int> builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return context.counterSpell.interactionLogic.generalIncrement
        .buildWithStaticChild(child: child, builder: builder);
  }
}
