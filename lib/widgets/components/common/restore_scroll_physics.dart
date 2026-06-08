import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class RestoreScrollPhysics extends StatelessWidget {
  const RestoreScrollPhysics({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(
        context,
      ).copyWith(physics: context.provide<ScrollPhysics>()),
      child: child,
    );
  }
}
