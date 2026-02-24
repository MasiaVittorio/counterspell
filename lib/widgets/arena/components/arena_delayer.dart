import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/arena/arena_widget.dart';
import 'package:counter_spell/widgets/stage/panel/collapsed_components/delayer.dart';

class ArenaDelayer extends StatefulWidget {
  final Duration duration;

  final Color color;

  final void Function() onManualCancel;
  final void Function() onManualConfirm;
  final DelayerController delayerController;

  final AnimationStatusListener animationListener;

  const ArenaDelayer({
    super.key,
    required this.onManualCancel,
    required this.onManualConfirm,
    required this.delayerController,
    required this.duration,
    required this.color,
    required this.animationListener,
  });

  @override
  State createState() => _ArenaDelayerState();
}

class _ArenaDelayerState extends State<ArenaDelayer>
    with TickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();

    initController();

    widget.delayerController.addListenersArena(
      startListener: scrolling,
      endListener: leaving,
    );
  }

  void initController() {
    controller?.dispose();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    controller!.addStatusListener(widget.animationListener);
  }

  @override
  void didUpdateWidget(ArenaDelayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != controller!.duration) {
      controller!.dispose();
      initController();
    }
  }

  bool scrolling() {
    if (!mounted) return false;
    if (controller!.isAnimating && controller!.velocity > 0) {
      return true;
    }
    if (controller!.value == 1.0) {
      return true;
    }

    controller!.fling();
    return true;
  }

  bool leaving() {
    if (!mounted) return false;
    if (controller!.value == 0.0) {
      return true;
    }

    bool fling = false;
    if (controller!.isAnimating) {
      if (controller!.velocity < 0) {
        return true;
      }
      fling = true;
    }
    _leaving(fling);
    return true;
  }

  void _leaving(bool withFling) async {
    if (!mounted) return;
    if (withFling) await controller!.fling();
    if (!mounted) return;
    controller!.animateBack(0.0);
  }

  @override
  void dispose() {
    controller!.dispose();
    widget.delayerController.removeArenaListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.scroller.isScrolling.build(
      (context, scrolling) => AnimatedOpacity(
        opacity: scrolling ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: AnimatedBuilder(
          animation: controller!,
          builder: (_, _) => ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: ArenaWidget.buttonSize.height + 4,
              maxWidth: ArenaWidget.buttonSize.width + 4,
            ),
            child: SizedBox.expand(
              child: CircularProgressIndicator(
                strokeWidth: 10,
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                value: controller!.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
