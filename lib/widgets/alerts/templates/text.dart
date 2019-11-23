import 'package:counter_spell_new/core.dart';

class TextAlert extends StatelessWidget {
  final String text;

  const TextAlert(this.text);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: Stage.of(context).panelScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(text),
        ),
      ),
    );
  }
}