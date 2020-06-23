import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/arena_widget.dart';
import 'package:counter_spell_new/widgets/stageboard/panel/collapsed_components/delayer.dart';


class ArenaDelayer extends StatefulWidget {
  final Duration duration;

  final Color color;

  final void Function() onManualCancel;
  final void Function() onManualConfirm;
  final DelayerController delayerController;


  ArenaDelayer({
    @required this.onManualCancel,
    @required this.onManualConfirm,
    @required this.delayerController,
    @required this.duration,
    @required this.color,
  });

  @override
  State createState() => new _ArenaDelayerState();
}

class _ArenaDelayerState extends State<ArenaDelayer> with TickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();

    this.initController();

    widget.delayerController.addListenersArena(
      startListener: scrolling,
      endListener: leaving,
    );

  }


  void initController(){
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
  }

  @override
  void didUpdateWidget(ArenaDelayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.duration != controller.duration){
      controller.dispose();
      initController();
    }
  }

  void scrolling(){
    if(!mounted) return;
    if(controller.isAnimating && controller.velocity > 0)
      return;
    if(controller.value == 1.0)
      return;

    this.controller.fling();
  }

  void leaving() async {
    if(!mounted) return;
    if(this.controller.value == 0.0)
      return;
    if(this.controller.isAnimating){
      if(this.controller.velocity < 0)
        return;
      await controller.fling();
    }
    this.controller.animateBack(0.0);
  }

  @override
  void dispose() {
    this.controller.dispose();
    widget.delayerController.removeArenaListeners();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.scroller.isScrolling.build((context, scrolling) => AnimatedOpacity(
      opacity: scrolling ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: AnimatedBuilder(
        animation: controller,
        builder:(_,__) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: ArenaWidget.buttonSize.height + 4, 
            maxWidth: ArenaWidget.buttonSize.width + 4,
          ),
          child: SizedBox.expand(
            child: CircularProgressIndicator(
              strokeWidth: 10,
              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
              value: controller.value,
            ),
          ),
        ),
      ),
    ));

  }
}


