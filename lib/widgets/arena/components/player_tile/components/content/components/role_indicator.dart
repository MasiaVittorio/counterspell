import 'package:counter_spell_new/core.dart';

class AptRole extends StatelessWidget {

  const AptRole({
    required this.bloc,
    required this.name,
    required this.pageColors,
    required this.rawSelected,
    required this.page,
    required this.isScrollingSomewhere,
    required this.whoIsAttacking,
    required this.whoIsDefending,
    // @required this.defenceColor,
    required this.havingPartnerB,
  });

  final CSBloc? bloc;
  final Map<CSPage,Color?>? pageColors;
  final String name;
  final bool? rawSelected;
  final CSPage page;
  final bool isScrollingSomewhere;
  final String? whoIsAttacking;
  final String? whoIsDefending;
  // final Color defenceColor;
  final bool havingPartnerB;

  static const double size = 56.0;

  @override
  Widget build(BuildContext context) {

    final Color pageColor = pageColors![page]!;
    final CSGameState stateBloc = bloc!.game.gameState;
    final CSGameAction actionBloc = bloc!.game.gameAction;


    return  SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          //normal selector (+anti selector) for life screen
          Positioned.fill(child: AnimatedPresented(
            duration: CSAnimations.fast,
            presented: [CSPage.life, CSPage.counters].contains(page),
            child: InkWell(
              onLongPress: (){
                actionBloc.selected.value[name]= rawSelected == null ? true : null;
                actionBloc.selected.refresh();
              },
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                child: Checkbox(
                  value: rawSelected,
                  activeColor: pageColor,
                  tristate: true,
                  onChanged: (b) {
                    actionBloc.selected.value[name] = rawSelected == false ? true : false;
                    actionBloc.selected.refresh();
                  },
                ),
              ),
            ),
          ),),

          //double partner // single partner for cast screen
          Positioned.fill(child: AnimatedPresented(
            duration: CSAnimations.fast,
            presented: page == CSPage.commanderCast,
            child: InkWell(
              onTap: () => stateBloc.toggleHavePartner(name),
              onLongPress: () {
                if(stateBloc.gameState.value.players[name]!.havePartnerB){
                  stateBloc.toggleUsePartner(name);
                } else {
                  stateBloc.toggleHavePartner(name);
                }
              },
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                child: Icon(
                  havingPartnerB
                    ? McIcons.account_multiple_outline
                    : McIcons.account_outline,
                ),
              ),
            ),
          ),),
          
          //attacking icon for commander damage screen
          Positioned.fill(child: AnimatedPresented(
            duration: CSAnimations.fast,
            presented: page == CSPage.commanderDamage && whoIsAttacking==name,
            child: InkWell(
              onTap: () {
                if(havingPartnerB){
                  stateBloc.toggleUsePartner(name);
                } else {
                  Stage.of(context)!.mainPagesController.goToPage(CSPage.life);
                }
              },
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                child: Icon(
                  havingPartnerB==true
                    ? CSIcons.attackTwo
                    : CSIcons.attackOne,
                  // color: this.pageColors[CSPage.commanderDamage],
                ),
              ),
            ),
          ),),

          //defending icon for commander damage screen
          Positioned.fill(child: AnimatedPresented(
            duration: CSAnimations.fast,
            presented: 
              page == CSPage.commanderDamage && 
              whoIsAttacking!=name && 
              whoIsAttacking!=null && 
              whoIsAttacking!="",
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              child: Icon(
                whoIsDefending == name
                  ? CSIcons.defenceFilled
                  : CSIcons.defenceOutline,
                // color: this.defenceColor,
              ),
            ),
          ),),
        ],
      ),
    );
  }
}
