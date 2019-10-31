import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/scroller/scroller_recognizer.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:flutter/material.dart';


class PlayerGestures{

  static void _returnToLife(CSBloc bloc){
    final stage = bloc.stageBloc.controller;
    if(stage.pagesController.page.setDistinct(CSPage.life)){
      bloc.scroller.ignoringThisPan = true;
    }
  }

  static void pan(CSDragUpdateDetails details, String name, double width, {
    @required CSPage page,
    @required CSBloc bloc,
  }){

    final actionBloc = bloc.game.gameAction;
    final scrollerBloc = bloc.scroller;
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
        if(actionBloc.selected.value[name] == false){
          actionBloc.selected.value[name] = true;
          actionBloc.selected.refresh();
        }
        scrollerBloc.onDragUpdate(details, width);
        return;
        break;
      case CSPage.commanderDamage:
        if(actionBloc.isSomeoneAttacking){
          actionBloc.defendingPlayer.set(name);
          scrollerBloc.onDragUpdate(details, width);
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
  }){
    final actionBloc = bloc.game.gameAction;
    final gameGroup = actionBloc.parent.gameGroup;
    final scrollerBloc = bloc.scroller;
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
          gameGroup.usingPartnerB.value[name] = 
              !(gameGroup.usingPartnerB.value[name] ?? false);
          gameGroup.usingPartnerB.refresh();
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
            actionBloc.parent.gameGroup.usingPartnerB.value[name] = !(usePartnerB??false);
            actionBloc.parent.gameGroup.usingPartnerB.refresh();
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