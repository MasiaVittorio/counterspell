import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/blocs/sub_blocs/scroller/scroller_recognizer.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:flutter/material.dart';


class PlayerGestures{

  static void _returnToLife(CSBloc bloc){
    if(bloc.scaffold.page.value == CSPage.life)
      return;
    bloc.scaffold.page.set(CSPage.life);
    bloc.scroller.ignoringThisPan = true;
  }

  static void pan(CSDragUpdateDetails details, String name, {
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
      case CSPage.life:
        if(scrollerBloc.ignoringThisPan) 
          return;
        if(actionBloc.selected.value[name] == false){
          actionBloc.selected.value[name] = true;
          actionBloc.selected.refresh();
        }
        scrollerBloc.onDragUpdate(details);
        return;
        break;
      case CSPage.commander:
        if(actionBloc.isSomeoneAttacking){
          actionBloc.defendingPlayer.set(name);
        }
        scrollerBloc.onDragUpdate(details);
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
  }){
    final actionBloc = bloc.game.gameAction;
    final scrollerBloc = bloc.scroller;
    switch (page) {
      case CSPage.history:
        _returnToLife(bloc);
        return;
        break;
      case CSPage.counters:
      case CSPage.life:
        actionBloc.selected.value[name] = rawSelected == false;
        actionBloc.selected.refresh();
        if(isScrollingSomewhere){
          scrollerBloc.delayerController.scrolling();
          scrollerBloc.delayerController.leaving();
        }
        return;
        break;
      case CSPage.commander:
        if(attacking){
          actionBloc.attackingPlayer.set("");
          actionBloc.defendingPlayer.set("");
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