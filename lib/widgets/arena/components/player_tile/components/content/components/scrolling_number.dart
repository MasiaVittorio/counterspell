import 'package:counter_spell_new/core.dart';

class APTNumber extends StatelessWidget {

  APTNumber({
    @required this.constraints,
    @required this.increment,
    @required this.playerState,
    @required this.rawSelected,
    @required this.scrolling,
  });

  //Player information
  final PlayerState playerState;

  //Interaction information
  final bool rawSelected;
  final int increment;
  final bool scrolling;

  //Layout information
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    
    final fontSize = constraints.maxHeight * 0.4;
    final scale = 0.45;
    final int increment = rawSelected == null ? - this.increment : this.increment;
    final incrementString = increment >= 0 ? "+ $increment" : "- ${increment.abs()}";
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        AnimatedScale(
          alsoAlign: true,
          scale: scrolling ? scale : 1.0,
          duration: CSAnimations.fast,
          child: AnimatedCount(
            duration: CSAnimations.medium,
            count: playerState.life,
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        ),
        AnimatedListed(
          listed: scrolling ? true : false,
          duration: CSAnimations.fast,
          axis: Axis.horizontal,
          child: Text(
            "$incrementString = ${playerState.life + increment}",
            style: TextStyle(
              fontSize: fontSize * scale,
            ),
          ),
        ),
      ],
    );
  }
}