import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class BodyPageBuilder extends StatelessWidget {
  const BodyPageBuilder({super.key, this.child, required this.builder});

  final Widget? child;
  final ChildValueBuilder<BodyPage> builder;

  @override
  Widget build(BuildContext context) {
    return context.counterSpell.pagesLogic.bodyPage.build(
      (context, value) => builder(context, value, child),
    );
  }
}
