import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/data/tutorial/arena.dart';
import 'package:counter_spell_new/data/tutorial/commander.dart';
import 'package:counter_spell_new/data/tutorial/counters.dart';
import 'package:counter_spell_new/data/tutorial/gestures.dart';
import 'package:counter_spell_new/data/tutorial/history.dart';
import 'package:counter_spell_new/data/tutorial/playgroup.dart';
import 'package:counter_spell_new/widgets/resources/highlightable/highlightable.dart';
import 'package:counter_spell_new/widgets/resources/tutorial_card/tutorial_card.dart';



class CSTutorial {

  void dispose(){
    showingTutorial.dispose();
    cachedGame.dispose();
  }

  final CSBloc parent;

  // Needs stage only to show, not to initialize
  // Needs gameState ready to restore game from cache
  CSTutorial(this.parent): 
    cachedGame = PersistentVar(
      initVal: null, 
      key: "counterspell_persistent_var_cached_tutorial_game",
      toJson: (game) => game?.toJson(),
      fromJson: (json) => json == null ? null : GameState.fromJson(json),
      readCallback: (cached) => _reactToCachedGame(cached, parent),
    ),
    changelogVersionShown = PersistentVar(
      initVal: 0, 
      key: "counterspell_persistent_var_changelog_hint_shown",
      readCallback: (val) => _reactToVersionShown(val, parent),
    );

  ///=============================================
  /// Values =================================
  final BlocVar<bool> showingTutorial = BlocVar<bool>(false);
  List<Hint> hints = [];
  final PersistentVar<GameState?> cachedGame;
  final PersistentVar<int> changelogVersionShown;

  int _changedPartner = 0;
  int _commanderDamage = 0;
  int _backOrForward = 0;
  int _counterPick = 0;

  final tutorialHighlight = HighlightController("tutorial");
  final changelogHighlight = HighlightController("changelog");
  final aHighlight = HighlightController("a");
  final panelRestartHighlight = HighlightController("panel restart");
  final panelEditPlaygroupHighlight = HighlightController("panel edit");
  final panelArenaPlaygroupHighlight = HighlightController("panel arena");
  final collapsedRightButtonHighlight = HighlightController("collapsed right");
  final collapsedLeftButtonHighlight = HighlightController("collapsed left");
  final playerHighlight = HighlightController("player");
  final secondPlayerHighlight = HighlightController("second player");
  final entireCollapsedPanel = HighlightController("entire collapsed");
  final backForthHighlight = HighlightController("backforth");
  final numberCircleHighlight = HighlightController("number circle");
  final checkboxHighlight = HighlightController("checkbox");

  TutorialCardsState Function()? retrieveState;

  ///=============================================
  /// Methods =================================

  void attach(TutorialCardsState Function() retrieve){
    retrieveState = retrieve;
  }

  PageController? retrieveController() => retrieveState?.call().controller;

  int get currentPage => retrieveController()?.page?.round() ?? 0;
  Hint? get currentHint => hints.safeAt(currentPage);

  void nextHint(){
    retrieveController()?.nextPage(
      duration: const Duration(milliseconds: 500), 
      curve: const Cubic(0.77,0,0.18,1),
    );
  }

  /// Show =====================
  void showTutorial(int? index) async {
    cachedGame.set(GameState.fromJson(
      parent.game.gameState.gameState.value.toJson(),
    ));
    parent.game.gameState.overwriteGame(CSGameState.defaultGameState);
    await parent.stage.closePanelCompletely();
    hints = Tutorials.base.checkIndex(index)
      ? [
        ...Tutorials.base[index!].hints,
        TutorialCards.last,
      ]
      : [
      TutorialCards.first,
      for(final tutorial in Tutorials.base)
        ...tutorial.hints,
      TutorialCards.last,
    ];

    retrieveController()?.jumpToPage(0);
    _changedPartner = 0;
    _commanderDamage = 0;
    _backOrForward = 0;
    _counterPick = 0;
    showingTutorial.set(true);
    await Future.delayed(const Duration(milliseconds: 300));
    handle(hints.first, retrieveState?.call().highlights.safeAt(0),0);
  }

  void handle(Hint hint, HighlightController? selfHighlight, int index) async {
    final stage = parent.stage;
    if(hint.page != null){
      stage.mainPagesController.goToPage(hint.page);
    }
    if(hint.autoHighlight != null){

      Future<void> h() async {
        if(hint == currentHint){
          await hint.autoHighlight!(parent);
        }
      }
      Future<void> i() async {
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      await Future.delayed(const Duration(milliseconds: 1000));
      for(final a in [
        for(int i=0; i<hint.repeatAuto; i++)
          h,
      ].separateWith(i)){
        await a();
      }

    }
    if(selfHighlight != null){
      await Future.delayed(const Duration(milliseconds: 300));
      selfHighlight.launch();
    }
  }

  void quitTutorial(){
    parent.game.gameState.overwriteGame(
      cachedGame.value == null 
        ? CSGameState.defaultGameState
        : GameState.fromJson(cachedGame.value!.toJson()),
    );
    cachedGame.set(null);
    showingTutorial.set(false);
  }

  
  ///======================================================================
  /// Private Initializing Methods =================================
  static void _reactToCachedGame(GameState? cached, CSBloc parent){
    if(cached!=null){
      final stateBloc = parent.game.gameState;
      final variable = stateBloc.gameState; 
      if(variable.reading){
        variable.readCallback = (_) => stateBloc.overwriteGame(cached);
      } else {
        stateBloc.overwriteGame(cached);
      }
    }
  }

  static void _reactToVersionShown(int val, CSBloc parent) async {
    if(val == 0){
      parent.tutorial.changelogVersionShown.set(ChangeLogData.lastBigChange);
    } else {
      if(val < ChangeLogData.lastBigChange){

        await Future.delayed(const Duration(milliseconds: 1500));
        await parent.stage.closePanelCompletely();
        parent.stage.openPanel();
        await Future.delayed(const Duration(milliseconds: 500));
        parent.stage.panelPagesController!.goToPage(SettingsPage.info);
        await Future.delayed(const Duration(milliseconds: 500));
        parent.tutorial.changelogHighlight.launch();
        
        parent.tutorial.changelogVersionShown.set(ChangeLogData.lastBigChange);
      }
    }
  }


  ///==========================================================================
  /// Private reacting methods to make the tutorial interactive ==========  

  void reactToGameAction(GameAction action) async {
    if(showingTutorial.value){
      if([
        GesturesTutorial.swipe,
        GesturesTutorial.delay,
        GesturesTutorial.repeat,
      ].contains(currentHint)){
        if(action is GALife){
          nextHint();
        } else if(action is GAComposite){
          if(action.actionList.values.any((e) => e is PALife)){
            nextHint();
          }
        }
      } else if(currentHint == GesturesTutorial.multiple) {
        if(action is GALife){
          int n=0;
          for(final s in action.selected.values){
            if(s != false) n++;
          }
          if(n>1){
            nextHint();
          }
        } else if(action is GAComposite){
          int n=0;
          for(final action in action.actionList.values){
            if(action is PALife && action.increment != 0){
              n++;
            }
          }
          if(n>1){
            nextHint();
          }
        }
      } else if(currentHint == GesturesTutorial.anti){
        if(action is GAComposite){
          final Set<int> increments = <int>{
            for(final a in action.actionList.values)
              if(a is PALife) if(a.increment != 0) a.increment,
          };
          if(increments.length > 1){
            await Future.delayed(const Duration(milliseconds: 750));
            if(currentHint == GesturesTutorial.anti){
              nextHint();
            }
          }
        } else if(action is GALife){
          if(action.selected.values.any((v) => v == null)){
            if(action.increment != 0){
              nextHint();
            }
          }
        }
      } else if(currentHint == CommanderTutorial.defender){
        if(action is GAComposite){
          for(final pa in action.actionList.values){
            if(pa is PADamage){
              if(pa.increment != 0){
                _commanderDamage++;
                if(_commanderDamage > 1){
                  nextHint();
                }
              }
            }
          }
        } else if(action is GADamage){
          if(action.increment != 0){
            _commanderDamage++;
            if(_commanderDamage > 1){
              nextHint();
            }
          }
        }
      }
    } 
  }

  
  void reactToRestartSnackbarShown() async {
    if(currentHint == HistoryTutorial.restartBottom){
      await Future.delayed(const Duration(milliseconds: 1000));
      if(currentHint == HistoryTutorial.restartBottom) nextHint();
    }
  }

  void reactToAttackingPlayerSelected(){
    if(currentHint == CommanderTutorial.attacker){
      nextHint();
    }
  }

  void reactToArenaAlertFromBottom() async {
    if(currentHint == ArenaTutorial.arenaBottom){
      await Future.delayed(const Duration(milliseconds: 300));
      if(currentHint == ArenaTutorial.arenaBottom) nextHint();
    }
  }

  void reactToArenaMenuShown() async {
    if(currentHint == ArenaTutorial.arenaMenu){
      await Future.delayed(const Duration(milliseconds: 300));
      if(currentHint == ArenaTutorial.arenaMenu) nextHint();
    }
  }

  void reactToRestartMenuShown() async {
    if(currentHint == HistoryTutorial.restartMenu){
      await Future.delayed(const Duration(milliseconds: 300));
      if(currentHint == HistoryTutorial.restartMenu) nextHint();
    }
  }

  void reactToHistoryBackOrForward() async {
    if(currentHint == HistoryTutorial.past){
      _backOrForward++;
      if(_backOrForward > 5){
        await Future.delayed(const Duration(milliseconds: 1000));
        if(currentHint == HistoryTutorial.past) nextHint();
      }
    }
  }


  void reactToPlaygroupEditedFromBottom() async {
    if(currentHint == PlaygroupTutorial.groupBottom){
      await Future.delayed(const Duration(milliseconds: 300));
      if(currentHint == PlaygroupTutorial.groupBottom) nextHint();
    }
  }
  void reactToPlaygroupMenuShown() async {
    if(currentHint == PlaygroupTutorial.groupMenu){
      await Future.delayed(const Duration(milliseconds: 300));
      if(currentHint == PlaygroupTutorial.groupMenu) nextHint();
    }
  }
  
  void reactToCounterBeingPicked() async {
    if(currentHint == CountersTutorial.pickCounter){
      _counterPick++;
      if(_counterPick > 2){
        await Future.delayed(const Duration(milliseconds: 1000));
        if(currentHint == CountersTutorial.pickCounter) nextHint();
      }
    }
  }

  
  void reactToHavingPartnerToggle(){
    if(currentHint == CommanderTutorial.split){
      nextHint();
    }
  }
  
  void reactToUsingPartnerToggle(){
    if(currentHint == CommanderTutorial.changePartner){
      _changedPartner++;
      if(_changedPartner > 3){
        nextHint();
      }
    }
  }

  void reactToSettingsViaLongPress(){
    if(currentHint == CommanderTutorial.playerOptionsLongPress){
      nextHint();
    }
  }

  
  void reactToSettingsViaCircle(){
    if(currentHint == CommanderTutorial.playerOptionsCircle){
      nextHint();
    }
  }


}

