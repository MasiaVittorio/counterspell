import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/scroller/scroller_detector.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_gestures.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_utilities.dart';

class PlayerTile extends StatelessWidget {
  final String name;

  final double tileSize;
  final double bottom;
  final double coreTileSize;
  final CSPage page;
  final bool selected;
  final bool isScrollingSomewhere;
  final String whoIsAttacking;
  final String whoIsDefending;
  final Counter counter;
  final PlayerState playerState;
  final Color defenceColor;
  final int increment;
  final PlayerAction normalizedPlayerAction;
  final double maxWidth;
  final Color pageColor;
  final bool usingPartnerB;
  final bool isAttackerUsingPartnerB;
  final bool havingPartnerB;
  final bool isAttackerHavingPartnerB;

  String get encoded => jsonEncode(<String,dynamic>{
    "name": name,
    "tileSize": tileSize,
    "bottom": bottom,
    "coreTileSize": coreTileSize,
    "page": CSPages.nameOf(page),
    "selected": selected,
    "isScrollingSomewhere": isScrollingSomewhere,
    "whoIsAttacking": whoIsAttacking,
    "whoIsDefending": whoIsDefending,
    "counter": counter.longName,
    "playerState": playerState.toJson(),
    "defenceColor": defenceColor.value,
    "increment": increment,
    "nextState": normalizedPlayerAction.apply(playerState).toJson(),
    "maxWidth": maxWidth,
    "pageColor": pageColor.value,
    "usingPartnerB": usingPartnerB,
    "havingPartnerB": havingPartnerB,
    "isAttackerHavingPartnerB": isAttackerHavingPartnerB,
    "isAttackerUsingPartnerB": isAttackerUsingPartnerB,
  });

  @override
  int get hashCode => this.encoded.hashCode;

  @override 
  bool operator ==(Object other){
    if(identical(other, this)) return true;
    if(other.runtimeType != this.runtimeType) return false;
    if(other is PlayerTile){
      if(other.name != this.name) return false;
      if(other.increment != this.increment) return false;
      if(other.selected != this.selected) return false;
      if(other.isScrollingSomewhere != this.isScrollingSomewhere) return false;
      if(other.whoIsAttacking != this.whoIsAttacking) return false;
      if(other.whoIsDefending != this.whoIsDefending) return false;
      if(other.playerState != this.playerState) return false;

      if(other.pageColor != this.pageColor) return false;
      if(other.usingPartnerB != this.usingPartnerB) return false;
      if(other.havingPartnerB != this.havingPartnerB) return false;
      if(other.isAttackerHavingPartnerB != this.isAttackerHavingPartnerB) return false;
      if(other.isAttackerUsingPartnerB != this.isAttackerUsingPartnerB) return false;

      if(other.normalizedPlayerAction.apply(other.playerState).toJson() 
      != this.normalizedPlayerAction.apply(this.playerState).toJson()) return false;

      if(other.counter.longName != this.counter.longName) return false;

      if(other.maxWidth != this.maxWidth) return false;
      if(other.defenceColor != this.defenceColor) return false;
      if(other.tileSize != this.tileSize) return false;
      if(other.bottom != this.bottom) return false;
      if(other.coreTileSize != this.coreTileSize) return false;

      return true;
    } else return false;
  }

  const PlayerTile(this.name, {
    @required this.usingPartnerB,
    @required this.isAttackerUsingPartnerB,
    @required this.havingPartnerB,
    @required this.isAttackerHavingPartnerB,
    @required this.maxWidth,
    @required this.tileSize,
    @required this.bottom,
    @required this.coreTileSize,
    @required this.page,
    @required this.pageColor,
    @required this.selected,
    @required this.isScrollingSomewhere,
    @required this.whoIsAttacking,
    @required this.whoIsDefending,
    @required this.counter,
    @required this.playerState,
    @required this.defenceColor,
    @required this.increment,
    @required this.normalizedPlayerAction,
  }): 
    assert(!(
      page == CSPage.counters
      && counter == null
    ));



  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;
    final stateBloc = bloc.game.gameState;
    final scrollerBloc = bloc.scroller;
    final actionBloc = bloc.game.gameAction;
    final StageData<CSPage,SettingsPage> stage = Stage.of<CSPage,SettingsPage>(context);
    final ThemeData theme = Theme.of(context);

    final bool attacking = whoIsAttacking == name;
    final bool defending = whoIsDefending == name;
    final bool highlighted = selected != false;

    bool scrolling;
    switch (page) {
      case CSPage.history:
        scrolling = false;
        break;
      case CSPage.counters:
      case CSPage.commanderCast:
      case CSPage.life:
        scrolling = highlighted && isScrollingSomewhere;
        break;
      case CSPage.commanderDamage:
        scrolling = defending;
        break;
      default:
    }
    assert(scrolling != null);

    final Widget tile = InkWell(
      onTap: () => PlayerGestures.tap(
        name,
        page: page,
        attacking: attacking,
        rawSelected: selected,
        bloc: bloc,
        isScrollingSomewhere: isScrollingSomewhere,
        hasPartnerB: havingPartnerB,
        usePartnerB: usingPartnerB,
      ),
      onLongPress: () => stage.showAlert(
        PlayerDetails(bloc.game.gameGroup.names.value.indexOf(name), this.maxWidth/(this.tileSize + this.bottom)), 
        size: PlayerDetails.height,
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
          child: Opacity(
            opacity: playerState.isAlive ? 1.0 : 0.7,
            child: SizedBox(
              height: coreTileSize,
              child: Row(children: <Widget>[
                buildLeading(
                  rawSelected: selected,
                  scrolling: scrolling,
                  attacking: attacking,
                  playerState: playerState,
                  defending: defending,
                  stage: stage,
                  someoneAttacking: whoIsAttacking!="" && whoIsAttacking!=null,
                  group: group,
                ),
                Expanded(child: buildBody(selected)),
                buildTrailing(selected, actionBloc, stateBloc),
              ]),
            ),
          ),
        ),
      ),
    );

    return group.cards(!(usingPartnerB ?? false)).build((_, cards){
      final MtgCard card = cards[name];
      if(card == null){
        return Material(child: tile);
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

        final Widget gradient = BlocVar.build2(
          bloc.settings.imageGradientStart,
          bloc.settings.imageGradientEnd,
          builder: (context, double startVal, double endVal) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  theme.canvasColor.withOpacity(startVal),
                  theme.canvasColor.withOpacity(endVal),
                ],
              ),
            ),
          ),
        );

        return SizedBox(
          height: tileSize + bottom,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: image,
              ),
              Positioned.fill(
                child: gradient,
              ),
              Positioned.fill(
                bottom: bottom,
                child: Material(
                  type: MaterialType.transparency,
                  child: Theme(
                    data: theme.copyWith(splashColor: Colors.white.withAlpha(0x66)),
                    child: tile,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });

  }

  static const circleFrac = 0.7;
  Widget buildLeading({
    @required PlayerState playerState,
    @required bool rawSelected,
    @required bool scrolling,
    @required bool attacking,
    @required bool defending,
    @required StageData<CSPage,SettingsPage> stage,
    @required bool someoneAttacking,
    @required CSGameGroup group,
  }){
    Widget child;

    final Color color = PTileUtils.cnColor(page, attacking, defending, pageColor, defenceColor, someoneAttacking);

    final colorBright = ThemeData.estimateBrightnessForColor(color);
    final Color textColor = colorBright == Brightness.light ? Colors.black : Colors.white;
    final textStyle = TextStyle(color: textColor, fontSize: 0.26 * coreTileSize);

    if(page == CSPage.history){

      child = Material(
        key: ValueKey("circle name"),
        color: color,
        elevation: playerState.isAlive ? 2.0 : 0.0,
        borderRadius: BorderRadius.circular(coreTileSize),
        child: Container(
          width: coreTileSize*circleFrac,
          height: coreTileSize*circleFrac,
          alignment: Alignment.center,
          child: Text(
            name.length > 2 ? name.substring(0,2) : name,
            style: textStyle,
          ),
        ),
      );

    } else {

      final int _increment = PTileUtils.cnIncrement(normalizedPlayerAction);

      child = InkWell(
        key: ValueKey("circle number"),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () => stage.showAlert(
          PlayerDetails(group.names.value.indexOf(name), this.maxWidth/(this.tileSize + this.bottom)), 
          size: PlayerDetails.height,
        ),
        child: Material(
          color: color,
          elevation: playerState.isAlive ? (2.0) : 0.0,
          borderRadius: BorderRadius.circular(coreTileSize * circleFrac * (attacking ? 0.1 : 1.0)),
          child: CircleNumber(
            size: coreTileSize * circleFrac,
            value: PTileUtils.cnValue(
              name, 
              page, 
              whoIsAttacking, 
              whoIsDefending,
              usingPartnerB ?? false,
              playerState,
              isAttackerUsingPartnerB ?? false,
              counter,
            ),
            numberOpacity: PTileUtils.cnNumberOpacity(page, whoIsAttacking),
            open: scrolling,
            style: textStyle,
            duration: CSAnimations.fast,
            color: color,
            increment: _increment,
            borderRadiusFraction: attacking ? 0.1 : 1.0,
          ),
        ),
      );

    }

    assert(child != null);

    return Padding(
      padding: EdgeInsets.all(coreTileSize * (1 - circleFrac)/2),
      child: child
    );
  }
  
  Widget buildTrailing(bool rawSelected, CSGameAction actionBloc, CSGameState stateBloc){
    return SizedBox(
      width: coreTileSize,
      height: coreTileSize,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //normal selector (+anti selector) for life screen
          Positioned.fill(child: AnimatedPresented(
            duration: CSAnimations.fast,
            presented: page == CSPage.life || page == CSPage.counters,
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
                  activeColor: pageColor,
                  tristate: true,
                  onChanged: (b) {
                    actionBloc.selected.value[name] = rawSelected == false ? true : false;
                    actionBloc.selected.refresh();
                  },
                ),
              ),
            ),
          ),),
          //double partner // single partner for cast screen
          Positioned.fill(child: AnimatedPresented(
            duration: CSAnimations.fast,
            presented: page == CSPage.commanderCast,
            child: InkWell(
              onTap: () => stateBloc.toggleHavePartner(name),
              child: Container(
                width: coreTileSize,
                height: coreTileSize,
                child: Icon(
                  havingPartnerB==true
                    ? McIcons.account_multiple_outline
                    : McIcons.account_outline,
                ),
              ),
            ),
          ),),
          //attacking icon for commander damage screen
          Positioned.fill(child: AnimatedPresented(
            duration: CSAnimations.fast,
            presented: page == CSPage.commanderDamage && whoIsAttacking==name,
            child: InkWell(
              onTap: () => stateBloc.toggleHavePartner(name),
              child: Container(
                width: coreTileSize,
                height: coreTileSize,
                child: Icon(
                  havingPartnerB==true
                    ? CSIcons.attackIconTwo
                    : CSIcons.attackIconOne,
                ),
              ),
            ),
          ),),
          //defending icon for commander damage screen
          Positioned.fill(child: AnimatedPresented(
            duration: CSAnimations.fast,
            presented: 
              page == CSPage.commanderDamage && 
              whoIsAttacking!=name && 
              whoIsAttacking!=null && 
              whoIsAttacking!="",
            child: Container(
              width: coreTileSize,
              height: coreTileSize,
              child: Icon(
                whoIsDefending == name
                  ? CSIcons.defenceIconFilled
                  : CSIcons.defenceIconOutline,
              ),
            ),
          ),),
        ],
      ),
    );
  }

  Widget buildBody(bool rawSelected){
    final annotation = PTileUtils.tileAnnotation(
      name,    page,    rawSelected,    whoIsAttacking,
      havingPartnerB??false,    usingPartnerB ??false, 
      isAttackerHavingPartnerB??false,    isAttackerUsingPartnerB??false,
    ) ?? "";
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(
                fontSize: 19,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
            AnimatedListed(
              listed: annotation!="", 
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: AnimatedText(
                  text:annotation,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
