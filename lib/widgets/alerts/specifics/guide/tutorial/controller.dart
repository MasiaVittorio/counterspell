import 'package:counter_spell/core.dart';

class TutorialPageController {
  TutorialPageController();

  int registered = 0;

  final Map<int, void Function(int)> _reactors = <int, void Function(int)>{};

  int register(void Function(int) reactor) {
    ++registered;
    _reactors[registered] = reactor;
    return registered;
  }

  void unregister(int? key) {
    _reactors.remove(key);
  }

  void _react(int newPage) {
    for (final reactor in _reactors.values) {
      reactor(newPage);
    }
  }

  set page(int newPage) {
    _react(newPage);
  }

  void dispose() {
    _reactors.clear();
  }
}

class TutorialPageReactor extends StatefulWidget {
  const TutorialPageReactor({super.key, 
    required this.controller,
    required this.builder,
  });

  final TutorialPageController controller;
  final Widget Function(BuildContext, int) builder;

  @override
  State createState() => _TutorialPageReactorState();
}

class _TutorialPageReactorState extends State<TutorialPageReactor> {
  int page = 0;
  int? registeredKey;

  @override
  void initState() {
    super.initState();
    registeredKey = widget.controller.register((int newPage) {
      if (mounted) {
        setState(() {
          page = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.controller.unregister(registeredKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, page);
  }
}
