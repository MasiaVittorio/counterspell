import 'package:flutter/material.dart';

class PageReactor extends AnimatedWidget {
  // a PageView controller to listen for page offset updates
  final PageController controller;

  final Widget Function(BuildContext, int) builder;

  PageReactor({
    @required this.controller,
    @required this.builder,
    Key key,
  })  : assert(controller != null),
        super(listenable: controller, key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, controller.page?.round() ?? controller.initialPage);
  }
}
