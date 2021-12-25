import 'package:counter_spell_new/core.dart';
import 'components/all.dart';

class AptContent extends StatelessWidget {

  AptContent({
    required this.name,
    required this.pageColors,
    required this.buttonAlignment,
    required this.constraints,
    required this.bloc,
    required this.rawSelected,
    required this.highlighted,
    required this.isScrollingSomewhere,
    required this.gameState,
    required this.increment,
    required this.page,
    required this.whoIsAttacking,
    required this.whoIsDefending,
    required this.defenceColor,
    required this.counter,
  });

  //Business Logic
  final CSBloc? bloc;

  //Actual Game State
  final GameState? gameState;
  final String name;

  //Interaction information
  final bool isScrollingSomewhere;
  final bool highlighted;
  final int? increment;
  final bool? rawSelected;
  final CSPage page;
  final String? whoIsAttacking;
  final String? whoIsDefending;
  final Color? defenceColor;
  final Counter counter;

  //Theming
  final Map<CSPage,Color?>? pageColors;

  //Layout information
  final BoxConstraints constraints;
  final Alignment buttonAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: leftButton 
        ? <Widget>[expandedBody, if(page == CSPage.life) info]
        : <Widget>[if(page == CSPage.life) info, expandedBody],
    );
  }

  static bool rightInfoFromButtonAlignment(Alignment al) => (al?.x ?? 0) <= 0;
  bool get leftButton => rightInfo;
  bool get rightInfo => rightInfoFromButtonAlignment(this.buttonAlignment);

  Widget get expandedBody => Expanded(child: bloc!.settings!.arenaSettings.scrollOverTap.buildChild(
    child: body,
    builder: (context, scrolls, child) => IgnorePointer(
      ignoring: !scrolls,
      /// if we have taps, two buttons are below this content in a stack
      /// so if we want those buttons to be tappable through the text, we need ignore pointer
      /// while if we have scrolls, all this content is wrapped inside a gesture detector so we don't need to
      /// 
      /// Anyway remember, that only the body can be ignored, while the info is to be scrollable so cannot be, and will
      /// block any tap in taps mode unfortunately
      child: child,
    ),
  ),);

  Widget get body => Stack(children: <Widget>[
    // const SizedBox(height: AptRole.size,),
    Positioned.fill(child: Center(child: number,),),
    Positioned(
      bottom:0.0, 
      left: 0.0,
      right: 0.0,
      child: nameAndRole
    ),
  ],);


  Widget get number {
    final playerState = gameState!.players[name]!.states.last;

    bool? scrolling;
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

    return APTNumberAlt(
      rawSelected: rawSelected,
      scrolling: scrolling,
      increment: this.increment,
      playerState: playerState,
      constraints: this.constraints,
      name: this.name,
      page: this.page,
      whoIsAttacking: this.whoIsAttacking,
      whoIsDefending: this.whoIsDefending,
      isAttackerUsingPartnerB: this.gameState!.players[this.whoIsAttacking!]?.usePartnerB??false,
      usingPartnerB: gameState!.players[name]!.usePartnerB,
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

  Widget get role => this.bloc!.settings!.arenaSettings.scrollOverTap.build((context, scroll) => scroll
    ? AptRole(
      name: this.name,
      rawSelected: this.rawSelected,
      bloc: this.bloc,
      pageColors: this.pageColors,
      isScrollingSomewhere: this.isScrollingSomewhere,
      page: this.page,
      whoIsAttacking: this.whoIsAttacking,
      whoIsDefending: this.whoIsDefending,
      havingPartnerB: this.gameState!.players[this.name]!.havePartnerB,
      // defenceColor: this.defenceColor,
    )
    : const SizedBox(width: AptRole.size, height: AptRole.size,),
  );

  Widget get info => AptInfo(
    gameState: this.gameState,
    bloc: this.bloc,
    name: this.name,
    pageColors: this.pageColors,
    defenceColor: this.defenceColor,
  );

}