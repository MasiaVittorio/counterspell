
import 'package:counter_spell_new/core.dart';

class HighlightController {

  final String id;

  HighlightController(this.id);

  Future<void> Function()? _launch;

  Future<void> launch() async {
    debugPrint("launch?");
    if(_launch != null){
      debugPrint("indeed, launch!");
      await _launch!();
    } else {
      /// NOPE
    }
  }

  void attach(Future<void> Function() launch){
    debugPrint("\\ Attatching $id");
    _launch = launch;
  }

  void detatch(){
    debugPrint("/// DETATCHING $id");
    _launch = null;
  }

}
