import 'package:flutter/material.dart';

class DelayedChild extends StatefulWidget {
  const DelayedChild({
    super.key,
    required this.child,
    this.delay = Durations.long2,
    this.placeholder = const SizedBox.shrink(),
    this.skipDelay = false,
  });

  final Widget? child;
  final Duration delay;
  final bool skipDelay;
  final Widget? placeholder;

  @override
  State<DelayedChild> createState() => _DelayedChildState();
}

class _DelayedChildState extends State<DelayedChild> {
  bool showMainChild = false;
  @override
  void initState() {
    super.initState();
    if (widget.skipDelay) {
      showMainChild = true;
    } else {
      wait();
    }
  }

  void wait() async {
    if (!mounted) return;
    if (widget.skipDelay) {
      showMainChild = true;
      return;
    }
    await Future.delayed(widget.delay);
    if (!mounted) return;
    setState(() => showMainChild = true);
  }

  @override
  void didUpdateWidget(covariant DelayedChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.delay != widget.delay) {
      if (widget.skipDelay) {
        showMainChild = true;
      } else {
        showMainChild = false;
        wait();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return showMainChild
        ? widget.child ?? widget.placeholder ?? const SizedBox.shrink()
        : widget.placeholder ?? const SizedBox.shrink();
  }
}
