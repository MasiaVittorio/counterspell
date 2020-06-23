import 'package:counter_spell_new/core.dart';


class PlayerGestures{

  static void _returnToLife(CSBloc bloc){
    final stage = bloc.stageBloc.controller;
    if(stage.mainPagesController.goToPage(CSPage.life)){
      bloc.scroller.ignoringThisPan = true;
    }
  }

  static void pan(CSDragUpdateDetails details, String name, double width, {
    @required CSPage page,
    @required CSBloc bloc,
    bool vertical = false,
    @required CSScroller scrollerBloc,
    bool tutorial = false,
  }){

    final CSGameAction actionBloc = bloc.game.gameAction;

    switch (page) {
      case CSPage.history:
        _returnToLife(bloc);
        return;
        break;
      case CSPage.counters:
      case CSPage.commanderCast:
      case CSPage.life:
        if(scrollerBloc.ignoringThisPan) 
          return;
        if(!tutorial){
          if(actionBloc.selected.value[name] == false){
            actionBloc.selected.value[name] = true;
            actionBloc.selected.refresh();
          }
        }
        scrollerBloc.onDragUpdate(details, width, vertical: vertical ?? false);
        return;
        break;
      case CSPage.commanderDamage:
        if(actionBloc.isSomeoneAttacking){
          actionBloc.defendingPlayer.set(name);
          scrollerBloc.onDragUpdate(details, width, vertical: vertical ?? false);
        }
        return;
        break;
      default:
    }
  }

  static void tap(String name, {
    @required CSBloc bloc,
    @required CSPage page,
    @required bool rawSelected,
    @required bool isScrollingSomewhere,
    @required bool attacking,
    @required bool hasPartnerB,
    @required bool usePartnerB,
    @required CSScroller scrollerBloc,
  }){
    final actionBloc = bloc.game.gameAction;
    final gameStateBloc = bloc.game.gameState;
    switch (page) {
      case CSPage.history:
        _returnToLife(bloc);
        return;
        break;
      case CSPage.counters:
      case CSPage.life:
        actionBloc.selected.value[name] = (rawSelected == false);
        actionBloc.selected.refresh();
        if(isScrollingSomewhere){
          scrollerBloc.delayerController.scrolling();
          scrollerBloc.delayerController.leaving();
        }
        return;
        break;
      case CSPage.commanderCast:
        if(hasPartnerB==true){
          //toggling used partners
          gameStateBloc.gameState.value.players[name].usePartnerB = !usePartnerB;
          gameStateBloc.gameState.refresh();
        }
        if(isScrollingSomewhere){
          scrollerBloc.delayerController.scrolling();
          scrollerBloc.delayerController.leaving();
        }
        return;
        break;
      case CSPage.commanderDamage:
        if(attacking){
          if(hasPartnerB==true){
            gameStateBloc.gameState.value.players[name].usePartnerB = !usePartnerB;
            gameStateBloc.gameState.refresh();
          }
        } else {
          actionBloc.attackingPlayer.set(name);
          actionBloc.defendingPlayer.set("");
        }
        return;
        break;
      default:
    }

  }
}