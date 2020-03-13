import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_gestures.dart';

class AptGestures extends StatelessWidget {

  AptGestures({
    @required this.content,
    @required this.bloc,
    @required this.name,
    @required this.isScrollingSomewhere,
    @required this.rawSelected,
    @required this.constraints,
    @required this.page,
    @required this.whoIsAttacking,
    @required this.whoIsDefending,
    @required this.havingPartnerB,
    @required this.usingPartnerB,
    @required this.defenceColor,
  });

  //child
  final Widget content;

  //Business Logic
  final CSBloc bloc;

  //Actual Game State
  final String name;

  //Interaction information
  final bool isScrollingSomewhere;
  final bool rawSelected;
  final CSPage page;
  final String whoIsAttacking;
  final String whoIsDefending;
  final Color defenceColor;
  final bool havingPartnerB;
  final bool usingPartnerB;

  //Layout information
  final BoxConstraints constraints;


  @override
  Widget build(BuildContext context) {

    final CSScroller scrollerBloc = bloc.scroller;
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          if(
            page == CSPage.commanderDamage 
            && !(whoIsAttacking == name && havingPartnerB)
          ){
            bloc.game.gameAction.clearSelection();
            stage.pagesController.pageSet(CSPage.life);
          } else {
            PlayerGestures.tap(
              name,
              page: page,
              attacking: whoIsAttacking == name,
              rawSelected: rawSelected,
              bloc: bloc,
              isScrollingSomewhere: isScrollingSomewhere,
              hasPartnerB: havingPartnerB,
              usePartnerB: usingPartnerB,
            );
          }
        },
        onLongPress: (){
          if(page == CSPage.commanderDamage && this.whoIsAttacking == this.name){
            stage.pagesController.pageSet(CSPage.life);
          } else {
            stage.pagesController.pageSet(CSPage.commanderDamage);
            bloc.game.gameAction.attackingPlayer.set(this.name);
            bloc.game.gameAction.defendingPlayer.set("");
          } 
        },
        child: VelocityPanDetector(
          onPanEnd: (_details) => scrollerBloc.onDragEnd(),
          onPanUpdate: (details) => PlayerGestures.pan(
            details,
            name,
            constraints.maxWidth,
            bloc: bloc,
            page: page,
            vertical: bloc.settings.arenaScreenVerticalScroll.value,
          ),
          onPanCancel: scrollerBloc.onDragEnd,
          child: Container(
            // width: constraints.maxWidth - _margin*2,
            // height: constraints.maxHeight - _margin*2,
            //to make the pan callback working, the color cannot be just null
            color: Colors.transparent,
            child: content,
          ),
        ),
      ),
    );
  }
}