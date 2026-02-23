import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/stage/panel/collapsed_components/delayer.dart';
import 'package:vibration/vibration.dart';

class ScrollerLogic {
  void dispose() {
    intValue.dispose();
    isScrolling.dispose();
    _onNextAutoConfirm.clear();
  }

  //==============================
  // Values

  final CSSettingsScroll scrollSettings;
  final bool Function() okVibrate;

  double value = 0.0;
  final BlocVar<int> intValue;
  final DelayerController delayerController;
  late BlocVar<bool> isScrolling;
  bool ignoringThisPan = false;
  final Map<String, VoidCallback> _onNextAutoConfirm = <String, VoidCallback>{};
  bool _clearNextAutoConfirm = false;

  final void Function(bool completed, bool alsoAttacker)? onCancel;

  //==============================
  // Constructor

  ScrollerLogic({
    required this.scrollSettings,
    required this.okVibrate,
    required void Function(int) onConfirm,
    required this.onCancel,
    bool? resetAfterConfirm,
  })  : delayerController = DelayerController(),
        intValue = BlocVar(0) {
    isScrolling = BlocVar<bool>(false, onChanged: (b) {
      if (b == false) {
        onConfirm.call(intValue.value);
        if (resetAfterConfirm!) {
          value = 0.0;
          intValue.set(0);
        }
      }
    });
  }

  //========================
  // Actions

  static const double _maxVel = 750;
  void onDragUpdate(CSDragUpdateDetails details, double width,
      {bool vertical = false}) {
    if (ignoringThisPan) return;

    delayerController.scrolling();

    final double vx = vertical
        ? details.velocity.pixelsPerSecond.dy
        : details.velocity.pixelsPerSecond.dx;

    final double maxSpeedWeight =
        scrollSettings.scrollDynamicSpeedValue.value!.clamp(0.0, 1.0);
    final double multiplierVel = scrollSettings.scrollDynamicSpeed.value!
        ? (vx / _maxVel).abs().clamp(0.0, 1.0) * maxSpeedWeight +
            (1 - maxSpeedWeight)
        : 1.0;

    final double multiplierPreBoost =
        (scrollSettings.scrollPreBoost.value! && value > -1.0 && value < 1.0)
            ? scrollSettings.scrollPreBoostValue.value!.clamp(1.0, 4.0)
            : 1.0;
    final double multiplier1Static = (scrollSettings.scroll1Static.value! &&
            value.abs() > 1.0 &&
            value.abs() < 2.0)
        ? scrollSettings.scroll1StaticValue.value!.clamp(0.0, 1.0)
        : 1.0;

    final double max = scrollSettings.scrollSensitivity.value!;
    final double fraction =
        (vertical ? -details.delta.dy : details.delta.dx) / width;

    value +=
        fraction * max * multiplierVel * multiplier1Static * multiplierPreBoost;

    if (intValue.setDistinct(value.round())) {
      feedBack();
    }
  }

  void onDragEnd() {
    if (!ignoringThisPan) delayerController.leaving();
    ignoringThisPan = false;
  }

  void delayerAnimationListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      if (isScrolling.setDistinct(false)) {
        _performAutoConfirm();
      }
      _performClearAutoConfirm();
    } else {
      if (isScrolling.setDistinct(true)) {
        _performClearAutoConfirm();
      }
    }
  }

  void _performAutoConfirm() {
    if (_clearNextAutoConfirm) {
      _performClearAutoConfirm();
    } else {
      for (final key in _onNextAutoConfirm.keys) {
        _onNextAutoConfirm[key]?.call();
      }
    }
  }

  void _performClearAutoConfirm() {
    _onNextAutoConfirm.clear();
    _clearNextAutoConfirm = false;
  }

  void registerCallbackOnNextAutoConfirm(String key, VoidCallback callback) {
    if (_clearNextAutoConfirm) _performClearAutoConfirm();
    _onNextAutoConfirm[key] = callback;
  }

  void feedBack() {
    if (okVibrate()) {
      Vibration.vibrate(
        amplitude: 177,
        duration: 50,
      );
    }
  }

  void cancel([bool alsoAttacker = false]) {
    value = 0.0;
    intValue.set(0);

    //this will trigger confirm() but the action will be null, so it will
    //not affect the gamestate's history
    bool completed = forceComplete();

    onCancel?.call(completed, alsoAttacker);

    _clearNextAutoConfirm = true;
  }

  bool forceComplete() => isScrolling.setDistinct(false);

  void editVal(int by) {
    delayerController.scrolling();
    intValue.value += by;
    intValue.refresh();
    delayerController.leaving();
  }
}
