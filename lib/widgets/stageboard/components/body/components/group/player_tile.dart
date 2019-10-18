import 'package:counter_spell_new/blocs/sub_blocs/blocs.dart';
import 'package:counter_spell_new/blocs/sub_blocs/scroller/scroller_detector.dart';
import 'package:counter_spell_new/models/game/model.dart';
import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:counter_spell_new/widgets/stageboard/components/body/components/group/player_tile_gestures.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';
import 'package:stage_board/stage_board.dart';

class PlayerTile extends StatelessWidget {
  final String name;
  final CSGameGroup group;
  final double tileSize;
  final double coreTileSize;
  final CSPage page;
  final Map<String, bool> selectedNames;
  final bool isScrollingSomewhere;
  final String whoIsAttacking;
  final String whoIsDefending;
  // final bool casting;
  final Counter counter;
  final GameState gameState;
  final CSTheme theme;
  final int increment;
  final Map<String,PlayerAction> normalizedPlayerActions;
  final double maxWidth;
  final Map<CSPage,Color> pageColors;

  const PlayerTile(this.name, {
    @required this.maxWidth,
    @required this.group,
    @required this.tileSize,
    @required this.coreTileSize,
    @required this.page,
    @required this.pageColors,
    @required this.selectedNames,
    @required this.isScrollingSomewhere,
    @required this.whoIsAttacking,
    @required this.whoIsDefending,
    @required this.counter,
    @required this.gameState,
    @required this.theme,
    @required this.increment,
    @required this.normalizedPlayerActions,
  }): 
    assert(!(
      page == CSPage.counters
      && counter == null
    ));

  @override
  Widget build(BuildContext context) {
    final bloc = group.parent.parent;
    final scrollerBloc = bloc.scroller;
    final actionBloc = bloc.game.gameAction;
    final stageBoard = StageBoard.of<CSPage,SettingsPage>(context);

    final bool attacking = whoIsAttacking == name;
    final bool defending = whoIsDefending == name;
    final bool rawSelected = selectedNames[name];
    final bool highlighted = selectedNames[name] != false;

    bool scrolling;
    switch (page) {
      case CSPage.history:
        scrolling = false;
        break;
      case CSPage.counters:
      case CSPage.commanderCast: //TODO: controlla cast
      case CSPage.life:
        scrolling = highlighted && isScrollingSomewhere;
        break;
      case CSPage.commanderDamage:
        scrolling = defending;
        break;
      default:
    }
    assert(scrolling != null);

    final playerState = gameState.players[name].states.last;
 
    //from now on we will act like the page will always be life,
    //we will abstract the player tile later to manage other pages
    //like commander damage / casts / counters

    return Material(
      child: InkWell(
        onTap: () => PlayerGestures.tap(
          name,
          page: page,
          attacking: attacking,
          rawSelected: rawSelected,
          bloc: bloc,
          isScrollingSomewhere: isScrollingSomewhere,
        ),
        child: VelocityPanDetector(
          onPanEnd: (_details) => scrollerBloc.onDragEnd(),
          onPanUpdate: (details) => PlayerGestures.pan(
            details,
            name,
            maxWidth,
            bloc: bloc,
            page: page,
          ),
          onPanCancel: scrollerBloc.onDragEnd,
          child: Container(
            //to make the pan callback working, the color cannot be just null
            color: Colors.transparent,
            height: tileSize,
            alignment: Alignment.center,
            child: SizedBox(
              height: coreTileSize,
              child: Row(children: <Widget>[
                buildLeading(
                  rawSelected: rawSelected,
                  scrolling: scrolling,
                  attacking: attacking,
                  playerState: playerState,
                  page: page,
                  defending: defending,
                  stageBoard: stageBoard,
                ),
                Expanded(child: buildBody()),
                buildTrailing(rawSelected, actionBloc),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  static const _circleFrac = 0.7;
  Widget buildLeading({
    @required PlayerState playerState,
    @required CSPage page,
    @required bool rawSelected,
    @required bool scrolling,
    @required bool attacking,
    @required bool defending,
    @required StageBoardData<CSPage,SettingsPage> stageBoard,
  }){
    Widget child;

    final currentColor = pageColors[page];
    final colorBrightness = ThemeData.estimateBrightnessForColor(currentColor);
    final Color textColor = colorBrightness == Brightness.light
      ? Colors.black 
      : Colors.white;
    final textStyle = TextStyle(
      color: textColor,
      fontSize: 0.26 * coreTileSize,
    );

    if(page == CSPage.history){

      child = Container(
        key: ValueKey("circle name"),
        width: coreTileSize*_circleFrac,
        height: coreTileSize*_circleFrac,
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(coreTileSize),
        ),
        alignment: Alignment.center,
        child: Text(
          name.length > 2 ? name.substring(0,2) : name,
          style: textStyle,
        ),
      );

    } else {

      Color color;
      if(page == CSPage.commanderDamage){
        if(attacking){
          color = pageColors[CSPage.commanderDamage];
        } else if(defending){
          color = theme.commanderDefence;
        } else {
          color = pageColors[CSPage.commanderDamage]
              .withOpacity(0.5);
        }
      } else {
        color = pageColors[page];
      }
      assert(color != null);

      final normalizedPlayerAction = normalizedPlayerActions[name];
      int _increment;
      if(normalizedPlayerAction is PALife){
        _increment = normalizedPlayerAction.increment;         
      } else if(normalizedPlayerAction is PANull){
        _increment = 0;
      }
      assert(_increment != null);

      child = CircleNumber(
        key: ValueKey("circle number"),
        size: coreTileSize * _circleFrac,
        value: playerState.life,
        numberOpacity: 1.0, //LOW PRIORITY: PLAYERSTATE -> ISDED
        open: scrolling,
        style: textStyle,
        duration: MyDurations.fast,
        color: color,
        increment: _increment,
        borderRadiusFraction: attacking ? 0.1 : 1.0,
      );

    }

    assert(child != null);

    return Padding(
      padding: EdgeInsets.all(coreTileSize * (1 - _circleFrac)/2),
      child: child
    );
  }
  
  Widget buildTrailing(bool rawSelected, CSGameAction actionBloc){
    return SizedBox(
      width: coreTileSize,
      height: coreTileSize,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //normal selector (+anti selector) for life screen
          Positioned.fill(child: AnimatedPresented(
            duration: MyDurations.fast,
            presented: true, //LOW PRIORITY: other trailing widgets to be defined
            child: InkWell(
              onLongPress: (){
                actionBloc.selected.value[name]= rawSelected == null ? true : null;
                actionBloc.selected.refresh();
              },
              child: Container(
                width: coreTileSize,
                height: coreTileSize,
                child: Checkbox(
                  value: rawSelected,
                  activeColor: pageColors[page],
                  tristate: true,
                  onChanged: (b) {
                    actionBloc.selected.value[name] = rawSelected == false ? true : false;
                    actionBloc.selected.refresh();
                  },
                ),
              ),
            ),
          ),),
        ],
      ),
    );
  }

  Widget buildBody(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
            ),
            AnimatedListed(
              listed: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("annotations to be defined"),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
