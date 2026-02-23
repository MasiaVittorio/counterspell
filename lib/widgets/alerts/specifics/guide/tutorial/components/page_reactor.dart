import 'package:flutter/material.dart';

class PageReactor extends AnimatedWidget {
  // a PageView controller to listen for page offset updates
  final PageController controller;

  final Widget Function(BuildContext, int) builder;

  const PageReactor({
    required this.controller,
    required this.builder,
    super.key,
  })  : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return builder(context, controller.page?.round() ?? controller.initialPage);
  }
}
