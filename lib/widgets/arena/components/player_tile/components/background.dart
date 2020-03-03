import 'package:counter_spell_new/core.dart';
import 'package:division/division.dart';


class AptBackGround extends StatelessWidget {

  AptBackGround({
    @required this.imageApplied,
    @required this.highlighted,
  });

  final Widget imageApplied;
  final bool highlighted;

  static const double margin = 6.0;
  
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Division(
      style: StyleClass()
        ..animate(250, Curves.easeOut)
        ..margin(all: highlighted ? margin : 0.0)
        ..overflow.hidden()
        ..background.color(highlighted 
          ? themeData.canvasColor 
          : themeData.scaffoldBackgroundColor
        )
        ..borderRadius(all: highlighted ? 8 : 0)
        ..boxShadow(
          color: highlighted ? const Color(0x59000000) : Colors.transparent, 
          blur: highlighted ? 2 : 0,
          offset: [0,0]
        ),
      child: imageApplied,
    );
  }
}