import 'backup_logic.dart';

extension CSBackupLog on CSBackupBloc {
  void log(String string) {
    // print("CS backup log: $string");
    logs.value += "\n";
    logs.value += string;
  }
}
