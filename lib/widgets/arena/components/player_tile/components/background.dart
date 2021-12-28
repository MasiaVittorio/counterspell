import 'package:counter_spell_new/core.dart';


class AptBackGround extends StatelessWidget {

  AptBackGround({
    required this.imageApplied,
    required this.highlighted,
    required this.isAttacking,
    required this.isDefending,
    required this.pageColors,
    required this.defenceColor,
  });

  final Widget imageApplied;
  final bool highlighted;
  final bool isAttacking;
  final bool isDefending;
  final Map<CSPage,Color?>? pageColors;
  final Color? defenceColor;

  static const double margin = 10.0;
  static const double _cmdrOpacity = 0.2;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    Color bkgColor = highlighted 
          ? themeData.canvasColor 
          : themeData.scaffoldBackgroundColor;
    
    if(isAttacking) {
      bkgColor = Color.alphaBlend(
        this.pageColors![CSPage.commanderDamage]!
            .withOpacity(_cmdrOpacity),
        bkgColor,
      );
    } else if (isDefending) {
      bkgColor = Color.alphaBlend(
        this.defenceColor!
            .withOpacity(_cmdrOpacity),
        bkgColor,
      );
    }

    // return Parent(
    //   style: ParentStyle()
    //     ..animate(250, Curves.easeOut)
    //     ..margin(all: highlighted ? margin : 0.0)
    //     ..overflow.hidden()
    //     ..background.color(bkgColor)
    //     ..borderRadius(all: highlighted ? 8 : 0)
    //     ..boxShadow(
    //       color: highlighted ? const Color(0x59000000) : Colors.transparent, 
    //       blur: highlighted ? 2 : 0,
    //       offset: Offset.zero,
    //     ),
    //   child: Stack(
    //     fit: StackFit.expand,
    //     alignment: Alignment.center,
    //     children: <Widget>[imageApplied],
    //   ),
    // );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
      margin: EdgeInsets.all(
        highlighted ? margin : 0.0,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bkgColor,
        borderRadius: BorderRadius.circular(highlighted ? 8 : 0),
        boxShadow: [BoxShadow(
          color: highlighted ? const Color(0x59000000) : Colors.transparent, 
          blurRadius: highlighted ? 2 : 0,
          offset: Offset.zero,
        )],
      ),
      // style: ParentStyle()
      //   ..animate(250, Curves.easeOut)
      //   ..margin(all: highlighted ? margin : 0.0)
      //   ..overflow.hidden()
      //   ..background.color(bkgColor)
      //   ..borderRadius(all: highlighted ? 8 : 0)
      //   ..boxShadow(
      //     color: highlighted ? const Color(0x59000000) : Colors.transparent, 
      //     blur: highlighted ? 2 : 0,
      //     offset: Offset.zero,
      //   ),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[imageApplied],
      ),
    );
  }
}