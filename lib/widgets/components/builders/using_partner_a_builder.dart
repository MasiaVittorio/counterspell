import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';

class UsingPartnerABuilder extends StatelessWidget {
  const UsingPartnerABuilder({super.key, required this.builder, this.child});

  final Widget Function(
    BuildContext context,
    List<bool> usingPartnerA,
    Widget? child,
  )
  builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return context.counterSpell.interactionLogic.usingPartnerA
        .buildWithStaticChild(builder: builder, child: child);
  }
}
