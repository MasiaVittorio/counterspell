import 'package:counter_spell_new/core.dart';
import 'components/all.dart';


class SimplePlayerTile extends StatelessWidget {

  SimplePlayerTile(this.index, {
    @required this.pageColors,
    @required this.indexToName,
    @required this.onPosition,
    @required this.buttonAlignment,
    @required this.constraints,
    @required this.group,
    @required this.selectedNames,
    @required this.isScrollingSomewhere,
    @required this.gameState,
    @required this.increment,
    @required this.normalizedPlayerActions,
    @required this.routeAnimationValue,
    @required this.firstUnpositionedName,
    @required this.whoIsAttacking,
    @required this.whoIsDefending,
    @required this.defenceColor,
    @required this.page,
  }): assert(indexToName[index] != null || firstUnpositionedName != null);


  //Business Logic
  final CSGameGroup group;

  //Actual Game State
  final GameState gameState;

  //Interaction information
  final Map<String, bool> selectedNames;
  final bool isScrollingSomewhere;
  final int increment;
  final Map<String,PlayerAction> normalizedPlayerActions;
  final String whoIsAttacking;
  final String whoIsDefending;
  final Color defenceColor;
  final CSPage page;

  //Theming
  final Map<CSPage,Color> pageColors;

  //Layout information
  final BoxConstraints constraints;
  final Alignment buttonAlignment;

  //Reordering stuff
  final Map<int,String> indexToName;
  final int index;
  final VoidCallback onPosition;
  final String firstUnpositionedName;

  //Route enter / exit animation
  final double routeAnimationValue;




  @override
  Widget build(BuildContext context) {

    final bloc = group.parent.parent;
    final themeData = Theme.of(context);

    final String name = indexToName[index];
    if(name == null) return buildPositioner(themeData);

    final bool rawSelected = selectedNames[name];
    final bool highlighted = selectedNames[name] != false;

    final Widget content = AptContent(
      highlighted: highlighted,
      rawSelected: rawSelected,
      name: name,
      bloc: bloc,
      isScrollingSomewhere: this.isScrollingSomewhere,
      pageColors: this.pageColors,
      increment: this.increment,
      buttonAlignment: this.buttonAlignment,
      constraints: this.constraints,
      gameState: this.gameState,
      page: this.page,
      whoIsAttacking: this.whoIsAttacking,
      whoIsDefending: this.whoIsDefending,
      defenceColor: this.defenceColor,
      counter: Counter.poison,
      //LOW PRIORITY: not reacting to counters
    );

    final Widget gesturesApplied = AptGestures(
      content: content,
      rawSelected: rawSelected,
      name: name,
      bloc: bloc,
      constraints: this.constraints,
      isScrollingSomewhere: this.isScrollingSomewhere,
      page: this.page,
      havingPartnerB: this.gameState.players[name].havePartnerB,
      usingPartnerB: this.gameState.players[name].usePartnerB,
      defenceColor: this.defenceColor,
      whoIsAttacking: this.whoIsAttacking,
      whoIsDefending: this.whoIsDefending,
    );

    final Widget imageApplied = AptCardImage(
      bloc: bloc,
      name: name,
      gesturesApplied: gesturesApplied,
      gameState: this.gameState,
    );

    final Widget backgroundApplied = AptBackGround(
      highlighted: highlighted,
      imageApplied: imageApplied,
    );

    
    // now we just have to animate the route entry and exit
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            left: 0.0,
            top: (1-routeAnimationValue) * constraints.maxHeight,
            child: backgroundApplied,
          ),
        ],
      ),
    );
  }



  Widget buildPositioner(ThemeData themeData) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      onTap: onPosition,
      child: Container(
        color: Colors.transparent,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Center(child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "Tap to put $firstUnpositionedName here",
            style: themeData.textTheme.button,
          ),
        ),),
      ),
    ),
  );

}
