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

    final StageData<CSPage,SettingsPage> stage = Stage.of(context);

    return Material(
      type: MaterialType.transparency,
      child: bloc.settings.arenaSettings.scrollOverTap.build((context, scrollOverTap) 
        => scrollOverTap 
          ? InkResponse(
              onTap:() => tapWithScrollSettings(stage), 
              onLongPress: () => longPressWithScrollSettings(stage),
              child: VelocityPanDetector(
                onPanUpdate: onPanUpdate,
                onPanEnd: onPanEnd,
                onPanCancel: bloc.scroller.onDragEnd,
                child: Container(
                  /// Transparent color (not just null) unless the empty part would not be interactive
                  color: Colors.transparent,
                  child: content,
                ),
              ),
            ) 
          : Stack(children: <Widget>[
              Positioned.fill(child: content),
              
              Positioned.fill(child: Column(children: <Widget>[
                for(bool topHalf in const <bool>[true,false])
                  Expanded(child: InkResponse(
                    containedInkWell: true,
                    onTap: (){}, /// not null because the inkwell must be seen as enabled
                    onTapDown: (_) => this.tapOnly(topHalf, stage),
                    child: Container(color: Colors.transparent,),
                  ),),
              ],),),
            ],),
      ),
    );
  }


  /// With scroll settings, taps are used to select
  void tapWithScrollSettings(StageData stage) {
    if(
      page == CSPage.commanderDamage 
      && !(whoIsAttacking == name && havingPartnerB)
    ){
      bloc.game.gameAction.clearSelection();
      stage.mainPagesController.goToPage(CSPage.life);
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
  }


  /// With scroll settings, a long press will trigger commander damage
  /// (without scroll settings, it wont be there altogether)
  void longPressWithScrollSettings(StageData stage){
    if(page == CSPage.commanderDamage && this.whoIsAttacking == this.name){
      stage.mainPagesController.goToPage(CSPage.life);
    } else {
      stage.mainPagesController.goToPage(CSPage.commanderDamage);
      bloc.game.gameAction.attackingPlayer.set(this.name);
      bloc.game.gameAction.defendingPlayer.set("");
    } 
  }

  void onPanUpdate(CSDragUpdateDetails details) => PlayerGestures.pan(
    details,
    name,
    constraints.maxWidth,
    bloc: bloc,
    page: page,
    vertical: bloc.settings.arenaSettings.verticalScroll.value,
  );

  void onPanEnd(DragEndDetails _) => bloc.scroller.onDragEnd();


  /// with only taps, we need the relative position to be able to determimne if the
  /// tap happened on the top or bottom half of the player tile, so we will need to use
  /// the onTapUp callback instead of the normal onTap one.
  void tapOnly(bool topHalf, StageData stage){
    final actionBloc = bloc.game.gameAction;
    final selectedVar = actionBloc.selected;
    final previousVal = <String,bool>{
      for(final e in selectedVar.value.entries)
        e.key+'': e.value,
    };

    /// We must be in life page only!
    if(stage.mainPagesController.currentPage != CSPage.life)
      stage.mainPagesController.goToPage(CSPage.life);
    /// This will handle automatically any pending action 
  
    /// Check if there was already a selection going on
    bool othersAlreadySelected = false; /// (should not happen very often)
    for(final key in previousVal.keys){
      if(previousVal[key] && key != this.name){
        othersAlreadySelected = true;
        break;
      }
    }

    if(othersAlreadySelected){
      /// if other players were selected before, wether there was an edit or not, 
      /// confirm that edit and move on with this new selected player
      this.bloc.scroller.forceComplete();
    } 

    /// now, only select this player
    selectedVar.value = <String,bool>{
      for(final key in previousVal.keys)
        key: key == this.name,
    };
    selectedVar.refresh();

    /// and now edit the value
    // final bool topHalf = details.localPosition.dy < (this.constraints.maxHeight / 2);
    this.bloc.scroller.editVal(topHalf ? 1 : -1);

  }

}