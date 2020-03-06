import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/arena_widget.dart';
import 'components/all.dart';

class AptContent extends StatelessWidget {

  AptContent({
    @required this.name,
    @required this.pageColors,
    @required this.buttonAlignment,
    @required this.constraints,
    @required this.bloc,
    @required this.rawSelected,
    @required this.highlighted,
    @required this.isScrollingSomewhere,
    @required this.gameState,
    @required this.increment,
    @required this.page,
    @required this.whoIsAttacking,
    @required this.whoIsDefending,
    @required this.defenceColor,
    @required this.counter,
  });

  //Business Logic
  final CSBloc bloc;

  //Actual Game State
  final GameState gameState;
  final String name;

  //Interaction information
  final bool isScrollingSomewhere;
  final bool highlighted;
  final int increment;
  final bool rawSelected;
  final CSPage page;
  final String whoIsAttacking;
  final String whoIsDefending;
  final Color defenceColor;
  final Counter counter;

  //Theming
  final Map<CSPage,Color> pageColors;

  //Layout information
  final BoxConstraints constraints;
  final Alignment buttonAlignment;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        children: leftButton 
          ? <Widget>[expandedBody, info]
          : <Widget>[info, expandedBody],
      ),
    );
  }

  bool get leftButton => (buttonAlignment?.x ?? 0) <= 0;
  bool get rightInfo => leftButton;

  Widget get expandedBody => Expanded(child: body,);

  Widget get body => Column(children: <Widget>[
    if(buttonOnTop) SizedBox(height: ArenaWidget.buttonSize.height/2),
    Expanded(child: Center(child: number,),),
    nameAndRole,
  ],);

  bool get buttonOnTop => buttonAlignment != null;

  Widget get number {
    final playerState = gameState.players[name].states.last;

    bool scrolling;
    switch (page) {
      case CSPage.history:
        scrolling = false;
        break;
      case CSPage.counters:
      case CSPage.commanderCast:
      case CSPage.life:
        scrolling = this.highlighted && this.isScrollingSomewhere;
        break;
      case CSPage.commanderDamage:
        scrolling = this.whoIsDefending == this.name;
        break;
      default:
    }
    assert(scrolling != null);

    return APTNumber(
      rawSelected: rawSelected,
      scrolling: scrolling,
      increment: this.increment,
      playerState: playerState,
      constraints: this.constraints,
      name: this.name,
      page: this.page,
      whoIsAttacking: this.whoIsAttacking,
      whoIsDefending: this.whoIsDefending,
      isAttackerUsingPartnerB: this.gameState.players[this.whoIsAttacking]?.havePartnerB??false,
      usingPartnerB: gameState.players[name].usePartnerB,
      counter: this.counter, 
    );
  }

  Widget get nameAndRole => Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: rightInfo 
      ? MainAxisAlignment.start
      : MainAxisAlignment.end,
    children: rightInfo 
      ? <Widget>[role, nameWidget]
      : <Widget>[nameWidget, role],
  );

  Widget get nameWidget => AptName(
    bloc: this.bloc,
    name: this.name,
    gameState: this.gameState,
    whoIsAttacking: this.whoIsAttacking,
    whoIsDefending: this.whoIsDefending,
  );

  Widget get role => AptRole(
    name: this.name,
    rawSelected: this.rawSelected,
    bloc: this.bloc,
    pageColors: this.pageColors,
    isScrollingSomewhere: this.isScrollingSomewhere,
    page: this.page,
    whoIsAttacking: this.whoIsAttacking,
    whoIsDefending: this.whoIsDefending,
    havingPartnerB: this.gameState.players[this.name].havePartnerB,
    defenceColor: this.defenceColor,
  );

  Widget get info => AptInfo(
    gameState: this.gameState,
    bloc: this.bloc,
    name: this.name,
    pageColors: this.pageColors,
    defenceColor: this.defenceColor,
  );

}