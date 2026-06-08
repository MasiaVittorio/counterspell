import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

class DelayProvider extends StatefulWidget {
  const DelayProvider({
    super.key,
    required this.delay,
    required this.animationDuration,
    required this.child,
    required this.onApply,
  });

  final Duration delay;
  final Duration animationDuration;
  final Widget child;
  final VoidCallback onApply;

  @override
  State<DelayProvider> createState() => _DelayProviderState();
}

class _DelayProviderState extends State<DelayProvider>
    with SingleTickerProviderStateMixin
    implements DelayController {
  late final AnimationController controller;
  bool isCancelled = false;
  Completer? currentCompleter;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    controller.addStatusListener(_statusListener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _statusListener(AnimationStatus status) {
    if (controller.value == 0 && !isCancelled && !status.isAnimating) {
      widget.onApply();
    }
  }

  @override
  Future<void> extend() async {
    if (controller.isAnimating) return tap();
    return;
  }

  @override
  Future<void> open() async {
    if (!mounted) return;
    isCancelled = false;
    if (controller.status == AnimationStatus.forward) return;
    currentCompleter?.complete();
    currentCompleter = Completer();
    await controller.animateTo(
      1,
      duration: widget.animationDuration,
      curve: Easings.emphasizedDecelerate,
    );
    currentCompleter?.complete();
    currentCompleter = null;
    return;
  }

  @override
  Future<void> consume() async {
    if (!mounted) return;
    isCancelled = false;
    if (currentCompleter != null) {
      await currentCompleter!.future;
    }
    await controller.animateBack(
      0,
      curve: Curves.linear,
      duration: widget.delay,
    );
    return;
  }

  @override
  Future<void> tap() async {
    if (!mounted) return;
    await open();
    await consume();
  }

  @override
  Future<void> cancel() async {
    if (!mounted) return;
    isCancelled = true;
    await controller.animateBack(
      0,
      curve: Easings.emphasizedAccelerate,
      duration: widget.animationDuration,
    );
    isCancelled = false;
    return;
  }

  @override
  void forceConfirm() {
    if (!mounted) return;
    widget.onApply();
    cancel();
  }

  @override
  Widget buildWithValue({
    required Widget Function(BuildContext context, double value, Widget? child)
    builder,
    Widget? child,
  }) => ValueListenableBuilder(
    valueListenable: controller,
    child: child,
    builder: (context, value, child) => builder(context, value, child),
  );

  @override
  Widget build(BuildContext context) {
    return CleanProvider<DelayController>(
      data: this as DelayController,
      child: widget.child,
    );
  }
}

extension BuildContextDelay on BuildContext {
  DelayController get delay => provide<DelayController>();
}

mixin DelayController {
  Widget buildWithValue({
    required Widget Function(BuildContext context, double value, Widget? child)
    builder,
    Widget? child,
  });

  Future<void> extend(); // taps if already ongoing

  Future<void> open();

  Future<void> consume();

  Future<void> tap();

  Future<void> cancel();

  void forceConfirm();
}
