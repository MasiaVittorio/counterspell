import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_utilities.dart';

class APTNumber extends StatelessWidget {

  APTNumber({
    required this.constraints,
    required this.increment,
    required this.playerState,
    required this.rawSelected,
    required this.scrolling,
    required this.name,
    required this.page,
    required this.counter,
    required this.isAttackerUsingPartnerB,
    required this.usingPartnerB,
    required this.whoIsAttacking,
    required this.whoIsDefending,
  });

  //Player information
  final PlayerState playerState;
  final String name;

  //Interaction information
  final bool rawSelected;
  final int increment;
  final bool scrolling;
  final CSPage page;
  final String whoIsAttacking;
  final String whoIsDefending;
  final bool usingPartnerB;
  final bool isAttackerUsingPartnerB;
  final Counter counter;

  //Layout information
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    
    final double fontSize = constraints.maxHeight * 0.4;
    const double scale = 0.45;
    final int increment = rawSelected == null ? - this.increment : this.increment;
    final String incrementString = increment >= 0 ? "+ $increment" : "- ${increment.abs()}";
    
    final int count = PTileUtils.cnValue(
      name, 
      page, 
      whoIsAttacking, 
      whoIsDefending,
      usingPartnerB ?? false,
      playerState,
      isAttackerUsingPartnerB ?? false,
      counter,
    )!;


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
            count: count,
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
            "$incrementString = ${count + increment}",
            style: TextStyle(
              fontSize: fontSize * scale,
            ),
          ),
        ),
      ],
    );
  }
}

class APTNumberAlt extends StatelessWidget {

  APTNumberAlt({
    required this.constraints,
    required this.increment,
    required this.playerState,
    required this.rawSelected,
    required this.scrolling,
    required this.name,
    required this.page,
    required this.counter,
    required this.isAttackerUsingPartnerB,
    required this.usingPartnerB,
    required this.whoIsAttacking,
    required this.whoIsDefending,
  });

  //Player information
  final PlayerState playerState;
  final String name;

  //Interaction information
  final bool? rawSelected;
  final int? increment;
  final bool? scrolling;
  final CSPage page;
  final String? whoIsAttacking;
  final String? whoIsDefending;
  final bool? usingPartnerB;
  final bool isAttackerUsingPartnerB;
  final Counter counter;

  //Layout information
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    
    final double fontSize = constraints.maxHeight * 0.4;
    const double scale = 0.9;
    final int increment = rawSelected == null ? - this.increment! : this.increment!;
    final String incrementString = increment >= 0 ? " + $increment" : " - ${increment.abs()}";
    
    final int count = PTileUtils.cnValue(
      name, 
      page, 
      whoIsAttacking, 
      whoIsDefending,
      usingPartnerB ?? false,
      playerState,
      isAttackerUsingPartnerB ?? false,
      counter,
    )!;


    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        AnimatedScale(
          alsoAlign: true,
          scale: scrolling! ? scale : 1.0,
          duration: CSAnimations.fast,
          child: AnimatedCount(
            count: count, 
            style: TextStyle(fontSize: fontSize), 
            duration: CSAnimations.medium,
          ),
          // Text(
          //   scrolling ? "${count + increment}" : "$count",
          //   style: TextStyle(fontSize: fontSize),
          // ),
        ),
        AnimatedListed(
          listed: scrolling! ? true : false,
          duration: CSAnimations.fast,
          axis: Axis.horizontal,
          overlapSizeAndOpacity: 0.9,
          child: Text(
            incrementString,
            style: TextStyle(fontSize: fontSize * scale * 0.32),
          ),
        ),
      ],
    );
  }
}

