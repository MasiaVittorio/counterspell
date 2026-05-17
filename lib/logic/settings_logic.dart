import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

extension SettingsLogicFromContext on BuildContext {
  SettingsLogic get settingsLogic => counterSpell.settingsLogic;
}

class SettingsLogic extends LogicBase {
  final PersistentReactive<bool> hapticFeedbackWanted = PersistentReactive(
    true,
    key: 'hapticFeedback',
  );
  late final PersistentReactive<bool> alwaysOnDisplayWanted;

  final Reactive<bool?> hapticFeedbackAvailable = Reactive(null);
  final PersistentReactive<bool> preferListView = PersistentReactive(
    false,
    key: 'preferListView',
  );

  final PersistentReactive<Axis> arenaDirection = PersistentReactive(
    Axis.vertical,
    key: 'arenaDirection',
    toJsonEncodable: (value) => value.name,
    fromJsonDecoded: (jsonDecoded) => Axis.values.byName(jsonDecoded as String),
  );

  final PersistentReactive<HistoryTimeStampMode> historyTimeStampMode =
      PersistentReactive(
        HistoryTimeStampMode.timeAgo,
        key: 'historyTimeStampMode',
        toJsonEncodable: (value) => value.name,
        fromJsonDecoded: (jsonDecoded) =>
            HistoryTimeStampMode.values.byName(jsonDecoded as String),
      );
  final PersistentReactive<bool> force24H = PersistentReactive(
    true,
    key: 'force24H',
  );

  @override
  void dispose() {
    hapticFeedbackWanted.dispose();
    alwaysOnDisplayWanted.dispose();
    hapticFeedbackAvailable.dispose();
    arenaDirection.dispose();
    historyTimeStampMode.dispose();
    force24H.dispose();
    super.dispose();
  }

  SettingsLogic() {
    _checkHapticFeedbackAvailable();
    alwaysOnDisplayWanted = PersistentReactive<bool>(
      true,
      key: 'alwaysOnDisplay',
      afterReading: (want) => WakelockPlus.toggle(enable: want),
    );
    alwaysOnDisplayWanted.addListener(_listener);
  }

  void _listener() => WakelockPlus.toggle(enable: alwaysOnDisplayWanted.value);

  void vibrate() {
    if (hapticFeedbackAvailable.value == true && hapticFeedbackWanted.value) {
      Vibration.vibrate(amplitude: 177, duration: 50);
    }
  }

  void _checkHapticFeedbackAvailable() async {
    try {
      hapticFeedbackAvailable.update(await Vibration.hasVibrator());
    } catch (_) {
      hapticFeedbackAvailable.update(false);
    }
  }
}

enum HistoryTimeStampMode {
  time('hh:mm'),
  timeAgo('Time ago');

  const HistoryTimeStampMode(this.label);

  final String label;

  String format(DateTime timeStamp, bool force24H) {
    switch (this) {
      case HistoryTimeStampMode.time:
        return timeStamp.format(force24H ? 'HH:mm' : 'hh:mm');
      case HistoryTimeStampMode.timeAgo:
        final duration = DateTime.now().difference(timeStamp).abs();
        final int s = duration.inSeconds;
        if (s < 90) return '${s}s ago';
        final int m = duration.inMinutes;
        if (m < 60) return '${m}m ago';
        if (m < 60 + 45) return '1h ${m - 60}m ago';
        final int h = (duration.inMinutes / 60).round();
        if (h < 24 + 12) return '${h}h ago';
        final int d = (duration.inHours / 24).round();
        return '${d}d ago';
    }
  }
}
