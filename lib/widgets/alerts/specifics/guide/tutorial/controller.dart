
import 'package:counter_spell_new/core.dart';

class TutorialPageController {

  TutorialPageController();

  int registered = 0;

  final Map<int,void Function(int)> _reactors = <int, void Function(int)>{};

  int register(void Function(int) reactor){
    ++registered;
    this._reactors[registered] = reactor;
    return registered;
  }

  void unregister(int? key){
    this._reactors.remove(key);
  }

  void _react(int newPage){
    for(final reactor in this._reactors.values)
      reactor(newPage);
  }

  set page(int newPage){
    this._react(newPage);
  }

  void dispose(){
    this._reactors.clear();
  }

}


class TutorialPageReactor extends StatefulWidget {

  TutorialPageReactor({
    required this.controller, 
    required this.builder,
  });

  final TutorialPageController controller;
  final Widget Function(BuildContext,int) builder;

  @override
  _TutorialPageReactorState createState() => _TutorialPageReactorState();
}

class _TutorialPageReactorState extends State<TutorialPageReactor> {

  int page = 0;
  int? registeredKey;

  @override
  void initState() {
    super.initState();
    this.registeredKey = this.widget.controller.register((int newPage){
      if(this.mounted) this.setState((){
        this.page = newPage;
      });
    });
  }

  @override
  void dispose() {
    this.widget.controller.unregister(this.registeredKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.builder(context, page);
  }
}