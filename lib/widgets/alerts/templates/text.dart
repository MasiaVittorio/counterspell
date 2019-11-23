import 'package:counter_spell_new/core.dart';

class TextAlert extends StatelessWidget {
  final String text;
  final String title;

  const TextAlert(this.text, {this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: Stage.of(context).panelScrollPhysics(),
        child: Column(
          children: <Widget>[
            if(title != null) AlertTitle(title),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}