import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/scroller/scroller_detector.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_gestures.dart';
import 'package:division/division.dart';
import 'extra_info.dart';


class SimplePlayerTile extends StatelessWidget {

  //Business Logic
  final CSGameGroup group;

  //Actual Game State
  final GameState gameState;

  //Interaction information
  final Map<String, bool> selectedNames;
  final bool isScrollingSomewhere;
  final int increment;
  final Map<String,PlayerAction> normalizedPlayerActions;

  //Theming
  final Map<CSPage,Color> pageColors;

  //Layout information
  final BoxConstraints constraints;
  final Alignment buttonAlignment;
  final Size buttonSize;

  //Reordering stuff
  final Map<int,String> indexToName;
  final int index;
  final VoidCallback onPosition;
  final String firstUnpositionedName;

  //Route enter / exit animation
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
    @required this.firstUnpositionedName,
  }): assert(indexToName[index] != null || firstUnpositionedName != null);

  static const double _margin = 6.0;

  @override
  Widget build(BuildContext context) {
    final bloc = group.parent.parent;
    final scrollerBloc = bloc.scroller;
    final themeData = Theme.of(context);

    final String name = indexToName[index];
    if(name == null) return buildPositioner(themeData);

    final bool rawSelected = selectedNames[name];
    final bool highlighted = selectedNames[name] != false;

    final bool scrolling = highlighted && isScrollingSomewhere;

    final playerState = gameState.players[name].states.last;

    // final bool hasAnnotations = false;
    final Widget info = buildExtraInfo(context, themeData);

    final bool buttonToTheRight = (buttonAlignment?.x ?? 0) >= 0;
    //account for the button position and size to avoid it!!
    final Widget tile = SizedBox(
      height: constraints.maxHeight,// - 2*_margin,
      width: constraints.maxWidth,
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
              vertical: bloc.settings.arenaScreenVerticalScroll.value,
            ),
            onPanCancel: scrollerBloc.onDragEnd,
            child: Container(
              // width: constraints.maxWidth - _margin*2,
              // height: constraints.maxHeight - _margin*2,
              //to make the pan callback working, the color cannot be just null
              color: Colors.transparent,
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
                    showNameWithImage: !bloc.settings.arenaHideNameWhenImages.value,
                  )),
                  if(info != null && !buttonToTheRight)
                    info,
                ],
              ),
            ),
          ),
        ),
      ),
    );

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
                ..margin(all: highlighted ? _margin : 0.0)
                // ..margin(all: highlighted ? _margin : 0.0)
                ..overflow.hidden()
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
              child: group.cards(!this.gameState.players[name].usePartnerB).build((_, cards){
                final MtgCard card = cards[name];
                if(card == null){
                  return Stack(
                    fit: StackFit.expand,
                    overflow: Overflow.clip,
                    alignment: Alignment.center,
                    children: <Widget>[tile],
                  );
                } else {
                  final String imageUrl = card.imageUrl();

                  final Widget image = bloc.settings.imageAlignments.build((_,alignments) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          imageUrl,
                          errorListener: (){},
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment(0,alignments[imageUrl] ?? -0.5),
                      ),
                    ),
                  ),);

                  final Widget gradient = bloc.settings.simpleImageOpacity.build((context, double opacity) => Container(
                    color: themeData.canvasColor.withOpacity(opacity),
                  ));

                  return Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    overflow: Overflow.clip,
                    children: <Widget>[
                      Positioned.fill(
                        child: image,
                      ),
                      Positioned.fill(
                        child: gradient,
                      ),
                      Theme(
                        data: themeData.copyWith(splashColor: Colors.white.withAlpha(0x66)),
                        child: tile,
                      ),
                    ],
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildName(CSGameAction actionBloc, bool rawSelected, bool showNameWithImage){

    final String name = indexToName[index];
    bool showName = true;
    if(!showNameWithImage){
      final bool cardThere = group.cards(!this.gameState.players[name].usePartnerB).value[name] != null;
      showName = !cardThere;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onLongPress: (){
              actionBloc.selected.value[name]= rawSelected == null ? true : null;
              actionBloc.selected.refresh();
            },
            child: Checkbox(
              activeColor: pageColors[CSPage.life],
              value: rawSelected,
              tristate: true,
              onChanged: (b) {
                actionBloc.selected.value[name] = rawSelected == false ? true : false;
                actionBloc.selected.refresh();
              },
            ),
          ),
          Text("${showName ? name : ""}", style: TextStyle(
            fontSize: 16,
          ),),
        ],
      ),
    );
  }

  Widget buildExtraInfo(BuildContext context, ThemeData themeData){

    final String name = indexToName[index];
    final StageData<CSPage,SettingsPage> stage = Stage.of<CSPage,SettingsPage>(context);

    return BlocVar.build3(
      group.parent.parent.themer.defenceColor,
      group.parent.gameAction.counterSet.variable,
      stage.pagesController.enabledPages,
      builder: (context, defenceColor, _, enabledPages){
        final list = ExtraInfo.fromPlayer(name,
          ofGroup: gameState.lastPlayerStates,
          pageColors: pageColors,
          havingPartnerB: <String,bool>{
            for(final entry in this.gameState.players.entries)
              entry.key: entry.value.havePartnerB,
          },
          defenceColor: defenceColor,
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: themeData.colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(SidChip.height/2),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: children.separateWith(SizedBox(height: 4,)),
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
    @required bool showNameWithImage,
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
            Expanded(child: Center(child: buildName(actionBloc, rawSelected, showNameWithImage))),
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
    final int increment = rawSelected == null ? - this.increment : this.increment;
    final incrementString = increment >= 0 ? "+ $increment" : "- ${increment.abs()}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        AnimatedScale(
          alsoAlign: true,
          scale: scrolling ? scale : 1.0,
          duration: CSAnimations.fast,
          child: AnimatedCount(
            duration: CSAnimations.medium,
            count: playerState.life,
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        ),
        AnimatedListed(
          listed: scrolling ? true : false,
          duration: CSAnimations.fast,
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


  Widget buildPositioner(ThemeData themeData) => Material(
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
