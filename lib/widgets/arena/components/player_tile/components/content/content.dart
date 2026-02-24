import 'package:counter_spell/core.dart';

import 'components/all.dart';

class AptContent extends StatelessWidget {
  const AptContent({
    super.key,
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
    required this.defenseColor,
    required this.counter,
  });

  //Business Logic
  final CSBloc bloc;

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
  final Color? defenseColor;
  final Counter counter;

  //Theming
  final Map<CSPage, Color?>? pageColors;

  //Layout information
  final BoxConstraints constraints;
  final Alignment buttonAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: leftButton
          ? <Widget>[expandedBody, if (page == CSPage.life) info]
          : <Widget>[if (page == CSPage.life) info, expandedBody],
    );
  }

  static bool rightInfoFromButtonAlignment(Alignment al) => (al.x) <= 0;
  bool get leftButton => rightInfo;
  bool get rightInfo => rightInfoFromButtonAlignment(buttonAlignment);

  Widget get expandedBody => Expanded(
        child: bloc.settings.arenaSettings.scrollOverTap.buildChild(
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
        ),
      );

  Widget get body => Stack(
        children: <Widget>[
          // const SizedBox(height: AptRole.size,),
          Positioned.fill(
            child: Center(
              child: number,
            ),
          ),
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: nameAndRole),
        ],
      );

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
        scrolling = highlighted && isScrollingSomewhere;
        break;
      case CSPage.commanderDamage:
        scrolling = whoIsDefending == name;
        break;
    }

    return APTNumberAlt(
      rawSelected: rawSelected,
      scrolling: scrolling,
      increment: increment,
      playerState: playerState,
      constraints: constraints,
      name: name,
      page: page,
      whoIsAttacking: whoIsAttacking,
      whoIsDefending: whoIsDefending,
      isAttackerUsingPartnerB:
          gameState!.players[whoIsAttacking!]?.usePartnerB ?? false,
      usingPartnerB: gameState!.players[name]!.usePartnerB,
      counter: counter,
    );
  }

  Widget get nameAndRole => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            rightInfo ? MainAxisAlignment.start : MainAxisAlignment.end,
        children:
            rightInfo ? <Widget>[role, nameWidget] : <Widget>[nameWidget, role],
      );

  Widget get nameWidget => AptName(
        bloc: bloc,
        name: name,
        gameState: gameState,
        whoIsAttacking: whoIsAttacking,
        whoIsDefending: whoIsDefending,
      );

  Widget get role => bloc.settings.arenaSettings.scrollOverTap.build(
        (context, scroll) => scroll
            ? AptRole(
                name: name,
                rawSelected: rawSelected,
                bloc: bloc,
                pageColors: pageColors,
                isScrollingSomewhere: isScrollingSomewhere,
                page: page,
                whoIsAttacking: whoIsAttacking,
                whoIsDefending: whoIsDefending,
                havingPartnerB: gameState!.players[name]!.havePartnerB,
                // defenseColor: this.defenseColor,
              )
            : const SizedBox(
                width: AptRole.size,
                height: AptRole.size,
              ),
      );

  Widget get info => AptInfo(
        gameState: gameState,
        bloc: bloc,
        name: name,
        pageColors: pageColors,
        defenseColor: defenseColor,
      );
}
