import 'package:counter_spell/core.dart';

export 'log.dart';
export 'past_games.dart';
export 'preferences.dart';

class CSBackupBloc {
  //===================================
  // Disposer
  void dispose() {
    logs.dispose();
  }

  //===================================
  // Values
  final CSBloc parent;

  final PersistentVar<String> logs = PersistentVar(
    initVal: "",
    key: "cs bloc backup and restore logs",
  );

  //===================================
  // Constructor
  CSBackupBloc(this.parent);
}
