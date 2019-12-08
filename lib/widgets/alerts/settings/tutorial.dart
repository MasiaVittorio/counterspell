import 'package:counter_spell_new/core.dart';

class TutorialAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Stack(children: <Widget>[
        Positioned.fill(child: SingleChildScrollView(),),
        Positioned(
          top: 0.0,
          height: AlertTitle.height,
          left: 0.0,
          right: 0.0,
          child: Container(
            color: theme.scaffoldBackgroundColor.withOpacity(0.7),
            child: const AlertTitle("Tutorial"),
          ),
        ),
      ],),
    );
  }
}