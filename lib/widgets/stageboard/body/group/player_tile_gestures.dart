import 'package:counter_spell_new/core.dart';


class PlayerGestures{

  static void _returnToLife(CSBloc bloc){
    final stage = bloc.stageBloc!.controller!;
    if(stage.mainPagesController.goToPage(CSPage.life)){
      bloc.scroller!.ignoringThisPan = true;
    }
  }

  static void pan(CSDragUpdateDetails details, String name, double width, {
    required CSPage? page,
    required CSBloc bloc,
    bool vertical = false,
    CSScroller? dummyScroller,
  }){

    final CSGameAction? actionBloc = bloc.game!.gameAction;
    final CSScroller? scrollerBloc = dummyScroller ?? bloc.scroller;
    final bool tutorial = dummyScroller != null;
    
    switch (page) {
      case CSPage.history:
        _returnToLife(bloc);
        return;
        break;
      case CSPage.counters:
      case CSPage.commanderCast:
      case CSPage.life:
        if(scrollerBloc!.ignoringThisPan) 
          return;
        if(!tutorial){
          if(actionBloc!.selected.value[name] == false){
            actionBloc.selected.value[name] = true;
            actionBloc.selected.refresh();
          }
        }
        scrollerBloc.onDragUpdate(details, width, vertical: vertical ?? false);
        return;
        break;
      case CSPage.commanderDamage:
        if(actionBloc!.isSomeoneAttacking){
          actionBloc.defendingPlayer.set(name);
          scrollerBloc!.onDragUpdate(details, width, vertical: vertical ?? false);
        }
        return;
        break;
      default:
    }
  }

  static void tap(String name, {
    required CSBloc bloc,
    required CSPage? page,
    required bool? rawSelected,
    required bool isScrollingSomewhere,
    required bool attacking,
    required bool? hasPartnerB,
    required bool? usePartnerB,
  }){
    final actionBloc = bloc.game!.gameAction;
    // final gameStateBloc = bloc.game.gameState;
    final scrollerBloc = bloc.scroller;
    switch (page) {
      case CSPage.history:
        _returnToLife(bloc);
        return;
        break;
      case CSPage.counters:
      case CSPage.life:
      case CSPage.commanderCast: /// recently added
        actionBloc!.selected.value[name] = (rawSelected == false);
        actionBloc.selected.refresh();
        if(isScrollingSomewhere){
          scrollerBloc!.delayerController.scrolling();
          scrollerBloc.delayerController.leaving();
        }
        return;
        break;
      // case CSPage.commanderCast:
        // if(hasPartnerB==true){
        //   //toggling used partners
        //   gameStateBloc.gameState.value.players[name].usePartnerB = !usePartnerB;
        //   gameStateBloc.gameState.refresh();
        // }
        // if(isScrollingSomewhere){
        //   scrollerBloc.delayerController.scrolling();
        //   scrollerBloc.delayerController.leaving();
        // }
        // return;
        // break;
      case CSPage.commanderDamage:
        if(attacking){
          actionBloc!.attackingPlayer.set("");
          actionBloc.defendingPlayer.set("");
          // if(hasPartnerB==true){
          //   gameStateBloc.gameState.value.players[name].usePartnerB = !usePartnerB;
          //   gameStateBloc.gameState.refresh();
          // }
        } else {
          actionBloc!.attackingPlayer.set(name);
          actionBloc.defendingPlayer.set("");
        }
        return;
        break;
      default:
    }

  }

  static void tapOnlyArena(String name, {
    required CSBloc bloc,
    required CSPage page,
    required String? whoIsAttacking,
    required bool topHalf,
    required String? whoIsDefending,
  }){

    final actionBloc = bloc.game!.gameAction;

    switch (page) {
      case CSPage.commanderCast:
      case CSPage.history:
        //history and commander cast are not implemented in arena yet
        _returnToLife(bloc);
        return;
        break;
      case CSPage.counters:
      case CSPage.life:

        final selectedVar = actionBloc!.selected;
        final previousVal = <String,bool?>{
          for(final e in selectedVar.value.entries)
            e.key+'': e.value,
        };

        /// Check if there was already a selection going on
        bool othersAlreadySelected = false; /// (should not happen very often)
        for(final key in previousVal.keys){
          if(previousVal[key]! && key != name){
            othersAlreadySelected = true;
            break;
          }
        }

        if(othersAlreadySelected){
          /// if other players were selected before, wether there was an edit or not, 
          /// confirm that edit and move on with this new selected player
          bloc.scroller!.forceComplete();
        } 

        /// now, only select this player
        selectedVar.value = <String,bool>{
          for(final key in previousVal.keys)
            key: key == name,
        };
        selectedVar.refresh();
        break;

      case CSPage.commanderDamage:
        // should not happen in arena, but if theres no attacker, this player will be!
        if(whoIsAttacking == null || whoIsAttacking == ""){
          actionBloc!.attackingPlayer.set(name);
          return;
        }

        /// Check if there was already a defending player going on
        final bool othersAlreadyDefending = whoIsDefending != null && whoIsDefending != "" && whoIsDefending != name;

        if(othersAlreadyDefending){
          /// if other players were defending before, wether there was a non zero damage or not, 
          /// confirm that damage and move on with this new defending player
          bloc.scroller!.forceComplete();

          // but reselect the previous attacker then
          actionBloc!.attackingPlayer.set(whoIsAttacking);
        } 

        /// now, only select this player as defender
        actionBloc!.defendingPlayer.setDistinct(name);
        
        break;
      default:
    }

    /// and now edit the value
    bloc.scroller!.editVal(topHalf ? 1 : -1);
    bloc.scroller!.registerCallbackOnNextAutoConfirm("arena commander damage", (){
      bloc.stage!.mainPagesController.goToPage(CSPage.life);
    });
  }


}