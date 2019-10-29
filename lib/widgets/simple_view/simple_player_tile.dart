import 'package:counter_spell_new/business_logic/sub_blocs/game/sub_game_blocs/game_action.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/game/sub_game_blocs/game_group.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/scroller/scroller_detector.dart';
import 'package:counter_spell_new/game_model/model.dart';
import 'package:counter_spell_new/game_model/types/damage_type.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/ui_model/ui_model.dart';
import 'package:counter_spell_new/widgets/resources/chip.dart';
import 'package:counter_spell_new/widgets/simple_view/extra_info.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_gestures.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';

class SimplePlayerTile extends StatelessWidget {
  final CSGameGroup group;
  final Map<String, bool> selectedNames;
  final bool isScrollingSomewhere;
  final GameState gameState;
  final Map<CSPage,Color> pageColors;
  final int increment;
  final Map<String,PlayerAction> normalizedPlayerActions;
  final BoxConstraints constraints;
  final Alignment buttonAlignment;
  final Size buttonSize;
  final Map<int,String> indexToName;
  final int index;
  final VoidCallback onPosition;
  final String firstUnpositionedName;
  final double routeAnimationValue;

  SimplePlayerTile(this.index, {
    @required this.pageColors,
    @required this.indexToName,
    @required this.onPosition,
    @required this.buttonAlignment,
    @required this.buttonSize,
    @required this.constraints,
    @required this.group,
    @required this.selectedNames,
    @required this.isScrollingSomewhere,
    @required this.gameState,
    @required this.increment,
    @required this.normalizedPlayerActions,
    @required this.routeAnimationValue,
    this.firstUnpositionedName,
  }): assert(indexToName[index] != null || firstUnpositionedName != null);

  String get name => indexToName[index];
  static const _margin = 6.0;

  @override
  Widget build(BuildContext context) {
    final bloc = group.parent.parent;
    final scrollerBloc = bloc.scroller;
    final themeData = Theme.of(context);

    if(name == null){
      return Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPosition,
          child: Container(
            color: Colors.transparent,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Center(child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Tap to put $firstUnpositionedName here",
                style: themeData.textTheme.button,
              ),
            ),),
          ),
        ),
      );
    }

    final bool rawSelected = selectedNames[name];
    final bool highlighted = selectedNames[name] != false;

    final bool scrolling = highlighted && isScrollingSomewhere;

    final playerState = gameState.players[name].states.last;

    // final bool hasAnnotations = false;
    final Widget info = buildExtraInfo(context, themeData);

    final bool buttonToTheRight = (buttonAlignment?.x ?? 0) >= 0;

    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            left: 0.0,
            top: (1-routeAnimationValue) * constraints.maxHeight,
            child: Division(
              style: StyleClass()
                ..animate(250)
                ..margin(all: _margin) 
                ..overflow.hidden()
                // ..margin(all: highlighted 
                //   ? 8
                //   : 0)
                // ..padding(all: highlighted 
                //   ? 0
                //   : 8)
                ..background.color(highlighted 
                  ? themeData.canvasColor 
                  : themeData.scaffoldBackgroundColor
                )
                ..borderRadius(all: highlighted 
                  ? 8
                  : 0
                )
                ..boxShadow(
                  color: highlighted 
                    ? const Color(0x59000000)
                    : Colors.transparent, 
                  blur: highlighted
                    ? 2
                    : 0,
                  offset: [0,0]
                ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () => PlayerGestures.tap(
                    name,
                    page: CSPage.life,
                    attacking: false,
                    rawSelected: rawSelected,
                    bloc: bloc,
                    isScrollingSomewhere: isScrollingSomewhere,
                    hasPartnerB: false,
                    usePartnerB: false, // just life lol
                  ),
                  child: VelocityPanDetector(
                    onPanEnd: (_details) => scrollerBloc.onDragEnd(),
                    onPanUpdate: (details) => PlayerGestures.pan(
                      details,
                      name,
                      constraints.maxWidth,
                      bloc: bloc,
                      page: CSPage.life,
                    ),
                    onPanCancel: scrollerBloc.onDragEnd,
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      //to make the pan callback working, the color cannot be just null
                      color: Colors.transparent,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          //account for the button position and size to avoid it!!
                          //name,
                          Positioned.fill(
                            child: Row(
                              children: <Widget>[
                                if(info != null && buttonToTheRight)
                                  info,
                                Expanded(child: buildLifeAndName(
                                  annotationsToTheRight: !buttonToTheRight,
                                  rawSelected: rawSelected,
                                  scrolling: scrolling,
                                  playerState: playerState,
                                  actionBloc: bloc.game.gameAction,
                                )),
                                if(info != null && !buttonToTheRight)
                                  info,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildName(CSGameAction actionBloc, bool rawSelected){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Checkbox(
            activeColor: pageColors[CSPage.life],
            value: rawSelected,
            tristate: true,
            onChanged: (b) {
              actionBloc.selected.value[name] = rawSelected == false ? true : false;
              actionBloc.selected.refresh();
            },
          ),
          Text("$name", style: TextStyle(
            fontSize: 16,
          ),),
        ],
      ),
    );
  }

  Widget buildExtraInfo(BuildContext context, ThemeData themeData){
    final StageData<CSPage,SettingsPage> stage = Stage.of<CSPage,SettingsPage>(context);
    return BlocVar.build4(
      group.havingPartnerB,
      group.parent.parent.themer.theme,
      group.parent.gameAction.counterSet.variable,
      stage.pagesController.enabledPages,
      builder: (context, havingPartnerB, theme, _, enabledPages){
        final list = ExtraInfo.fromPlayer(name,
          ofGroup: gameState.lastPlayerStates,
          pageColors: pageColors,
          havingPartnerB: havingPartnerB,
          theme: theme,
          types: DamageTypes.fromPages(enabledPages),
          counterMap: group.parent.gameAction.currentCounterMap,
        );
        final children = <Widget>[
          for(final info in list)
            SidChip(
              icon: info.icon,
              text: info.value.toString(),
              subText: info.note,
              color: info.color,
            ),
        ];
        if(list.isEmpty) return SizedBox();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:4.0),
          child: Container(
            decoration: BoxDecoration(
              color: themeData.colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(SidChip.height/2),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: divideList(children, SizedBox(height: 4,)),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget buildLifeAndName({
    @required PlayerState playerState,
    @required bool rawSelected,
    @required bool scrolling,
    @required bool annotationsToTheRight,
    @required CSGameAction actionBloc,
  }){
    return LayoutBuilder(builder: (context, intConstraints){
      double offset;
      bool betterRightSide;
      if(buttonAlignment == null){
        offset = 0;
        betterRightSide = true;
      } else {
        final localWidth = intConstraints.maxWidth;
        final globalWidth = constraints.maxWidth;
        final globalButtonOffsetX = globalWidth / 2 * (1 + buttonAlignment.x);
        final deltaWidth = globalWidth - localWidth;
        final annotationDelta = deltaWidth - _margin * 2;
        double localButtonOffsetX;
        if(annotationsToTheRight){
          //we are aligned to the left
          localButtonOffsetX = globalButtonOffsetX - _margin;
        } else {
          //we are aligned to the right
          localButtonOffsetX = globalButtonOffsetX - _margin - annotationDelta;
        }
        assert(localButtonOffsetX != null);
        final leftButtonSide = localButtonOffsetX - buttonSize.width/2;
        final rightButtonSide = localButtonOffsetX + buttonSize.width/2;
        betterRightSide = localWidth - rightButtonSide > leftButtonSide;
        offset = betterRightSide 
          ? rightButtonSide
          : localWidth - leftButtonSide;
      }
      assert(betterRightSide != null);
      assert(offset != null);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(children: <Widget>[
            if(betterRightSide)
              SizedBox(width: offset),
            Expanded(child: Center(child: buildName(actionBloc, rawSelected))),
            if(!betterRightSide)
              SizedBox(width: offset),
          ],),
          Expanded(child: Center(
            child: buildLife(
              playerState: playerState,
              rawSelected: rawSelected,
              scrolling: scrolling,
            ),
          ),),
        ],
      );
    });
  }

  Widget buildLife({
    @required PlayerState playerState,
    @required bool rawSelected,
    @required bool scrolling,
  }){
    final fontSize = constraints.maxHeight * 0.4;
    final scale = 0.45;
    final incrementString = increment >= 0 ? "+ $increment" : "- ${increment.abs()}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        AnimatedScale(
          alsoAlign: true,
          scale: scrolling ? scale : 1.0,
          duration: MyDurations.fast,
          child: AnimatedCount(
            duration: MyDurations.medium,
            count: playerState.life,
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        ),
        AnimatedListed(
          listed: scrolling ? true : false,
          duration: MyDurations.fast,
          axis: Axis.horizontal,
          child: Text(
            "$incrementString = ${playerState.life + increment}",
            style: TextStyle(
              fontSize: fontSize * scale,
            ),
          ),
        ),
      ],
    );
  }


  
  // Widget buildTrailing(bool rawSelected, CSGameAction actionBloc, StageData stage){
  //   return SizedBox(
  //     // width: coreTileSize,
  //     // height: coreTileSize,
  //     child: Stack(
  //       fit: StackFit.expand,
  //       children: <Widget>[
  //         //normal selector (+anti selector) for life screen
  //         Positioned.fill(child: AnimatedPresented(
  //           duration: MyDurations.fast,
  //           presented: true, 
  //           child: InkWell(
  //             onLongPress: (){
  //               actionBloc.selected.value[name]= rawSelected == null ? true : null;
  //               actionBloc.selected.refresh();
  //             },
  //             child: Container(
  //               // width: coreTileSize,
  //               // height: coreTileSize,
  //               child: Checkbox(
  //                 value: rawSelected,
  //                 activeColor: pageColors[CSPage.life],
  //                 tristate: true,
  //                 onChanged: (b) {
  //                   actionBloc.selected.value[name] = rawSelected == false ? true : false;
  //                   actionBloc.selected.refresh();
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),),
  //       ],
  //     ),
  //   );
  // }

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
