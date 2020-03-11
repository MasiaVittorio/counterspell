import 'package:counter_spell_new/core.dart';
import 'components/all.dart'; 

class TutorialContent extends StatelessWidget {

  TutorialContent(this.controller);

  final PageController controller;

  static const List<Widget> children = <Widget>[
    TutorialScroll(),
    TutorialSelection(),
    TutorialHistory(),
    TutorialCommander(),
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: children.length,
      
      itemBuilder: (_, page){
        return SubSection(
          <Widget>[children[page],], 
          crossAxisAlignment: CrossAxisAlignment.stretch,
          margin: const EdgeInsets.all(8.0),
        );
      },
    );
  }
}