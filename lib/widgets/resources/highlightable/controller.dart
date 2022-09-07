

class HighlightController {

  final String id;

  HighlightController(this.id);

  Future<void> Function()? _launch;

  Future<void> launch() async {
    if(_launch != null){
      await _launch!();
    } else {
      /// NOPE
    }
  }

  void attach(Future<void> Function() launch){
    _launch = launch;
  }

  void detatch(){
    _launch = null;
  }

}
