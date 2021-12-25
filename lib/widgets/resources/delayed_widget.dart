import 'package:flutter/material.dart';


class Waiting extends StatelessWidget {

  const Waiting();

  @override
  Widget build(BuildContext context) 
    => Center(child: CircularProgressIndicator(),);
}

class DelayedWidget extends StatefulWidget {

  const DelayedWidget({
    this.before = const Waiting(),
    required this.after,
    this.delay = defaultDelay,
    this.getBackgroundColor = background,
  }) : assert(after != null);

  final Widget after;
  final Widget before;
  final Duration delay;
  final Color Function(ThemeData) getBackgroundColor;

  static Color background(ThemeData theme) => theme.canvasColor;

  static const Duration defaultDelay = const Duration(milliseconds: 500);

  @override
  _DelayedWidgetState createState() => _DelayedWidgetState();
}

class _DelayedWidgetState extends State<DelayedWidget> with SingleTickerProviderStateMixin{

  bool after = false;
  late AnimationController barrierOpacity;
  bool fadedIn = false;

  @override
  void initState() {
    super.initState();
    barrierOpacity = AnimationController(
      value: 1.0,
      vsync: this,
    );
    wait();
  }

  void wait() async {
    await Future.delayed(widget.delay ?? DelayedWidget.defaultDelay);

    if(!mounted) return;

    setState(() {
      after = true;
    });

    await barrierOpacity.animateBack(0.0, duration: opacityDuration);

    if(!mounted) return;

    setState((){
      fadedIn = true;
    });

  }

  static const opacityDuration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final background = widget.getBackgroundColor?.call(theme)
        ?? DelayedWidget.background(theme);
    return Container(
      color: background,
      child: after 
        ? fadedIn 
          ? widget.after 
          : Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(child: widget.after),
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: barrierOpacity,
                  builder: (_, __) => Container(
                    color: background.withOpacity(barrierOpacity.value),
                  ),
                ),
              ),
            ],
          ) 
        : widget.before ?? const Waiting(),
    );
  }
}