// import 'dart:convert';

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/scroller/scroller_detector.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_gestures.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_utilities.dart';

class PlayerTile extends StatelessWidget {
  final String name;

  final double tileSize;
  final double bottom;
  final bool first;
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

  const PlayerTile(this.name, {
    @required this.usingPartnerB,
    @required this.isAttackerUsingPartnerB,
    @required this.havingPartnerB,
    @required this.isAttackerHavingPartnerB,
    @required this.maxWidth,
    @required this.tileSize,
    @required this.bottom,
    @required this.first,
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

  static const double coreTileSize = CSSizes.minTileSize;


  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;
    final stateBloc = bloc.game.gameState;
    final scrollerBloc = bloc.scroller;
    final actionBloc = bloc.game.gameAction;
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);
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
        PlayerDetails(
          bloc.game.gameGroup.names.value.indexOf(name), 
          this.maxWidth/(this.tileSize + this.bottom),
        ), 
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
                bloc.settings.appSettings.numberFontSizeFraction.build(
                  (context, val) => buildLeading(
                    numberFontSizeFraction: val,
                    theme: theme,
                    rawSelected: selected,
                    scrolling: scrolling,
                    attacking: attacking,
                    playerState: playerState,
                    defending: defending,
                    stage: stage,
                    someoneAttacking: whoIsAttacking!="" && whoIsAttacking!=null,
                    group: group,
                  ),
                ),
                Expanded(child: buildBody(selected, theme)),
                buildTrailing(selected, actionBloc, stateBloc),
              ]),
            ),
          ),
        ),
      ),
    );

    return group.cardsA.build((_, cardsA) => group.cardsB.build((_, cardsB) {
      final MtgCard cardA = cardsA[name];
      final MtgCard cardB = havingPartnerB ? cardsB[name] : null;

      if(cardB == null && cardA == null){
        return Material(
          child: tile,
          borderRadius: BorderRadius.circular(12),
        );
      } else {
        final String urlA = cardA?.imageUrl();
        final String urlB = cardB?.imageUrl();

        return bloc.settings.imagesSettings.imageAlignments.build((_,alignments){
          
          final Decoration decorationA = urlA == null 
            ? null 
            : BoxDecoration(image: DecorationImage(
              image: CachedNetworkImageProvider(
                urlA,
              ),
              fit: BoxFit.cover,
              alignment: Alignment(0, alignments[urlA] ?? -0.5),
            ),);

          Widget image;

          if(havingPartnerB){
            final Decoration decorationB = urlB == null 
              ? null 
              : BoxDecoration(image: DecorationImage(
                image: CachedNetworkImageProvider(
                  urlB,
                  // errorListener: (){},
                ),
                fit: BoxFit.cover,
                alignment: Alignment(0, alignments[urlB] ?? -0.5),
              ),);

            image = Row(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                  width: maxWidth * (usingPartnerB ? 0.25 : 0.75),
                  decoration: decorationA,
                ),
                Expanded(child: Container(
                  decoration: decorationB,
                ),),
              ],
            );
          } else {
            image =  Container(decoration: decorationA);
          }

          final Widget gradient = BlocVar.build2(
            bloc.settings.imagesSettings.imageGradientStart,
            bloc.settings.imagesSettings.imageGradientEnd,
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
            child: bloc.themer.flatDesign.build((context, flat) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(flat ? 12 : 0.0),
              ),
              clipBehavior: Clip.antiAlias,
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
            ),),
          );
        });
      }
    },),);

  }

  static const circleFrac = 0.7;
  Widget buildLeading({
    @required ThemeData theme,
    @required PlayerState playerState,
    @required bool rawSelected,
    @required bool scrolling,
    @required bool attacking,
    @required bool defending,
    @required StageData<CSPage,SettingsPage> stage,
    @required bool someoneAttacking,
    @required CSGameGroup group,
    @required double numberFontSizeFraction,
  }){
    Widget child;
    final Color color = PTileUtils.cnColor(
      page, 
      attacking, 
      defending, 
      pageColor, 
      defenceColor, 
      someoneAttacking,
    );

    // final colorBright = ThemeData.estimateBrightnessForColor(color);
    // final Color textColor = colorBright == Brightness.light ? Colors.black : Colors.white;
    final textStyle = TextStyle(
      color: theme.brightness.contrast,
      fontSize: numberFontSizeFraction * coreTileSize,
    );

    final Color subColor = Color.alphaBlend(
      theme.scaffoldBackgroundColor.withOpacity(1.0),
      // theme.colorScheme.onSurface.withOpacity(.1),
      theme.canvasColor,
    ).withOpacity(0.6);
    final Color selectedColor = Color.alphaBlend(
      color.withOpacity(0.55),
      theme.canvasColor,
    ).withOpacity(0.8);

    if(page == CSPage.history){

      child = Material(
        key: ValueKey("$name circle name"),
        color: selectedColor,
        // elevation: playerState.isAlive ? 2.0 : 0.0,
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

      final bool selected = page == CSPage.commanderDamage 
        ? attacking || defending
        : rawSelected != false;

      child = InkWell(
        key: ValueKey("$name circle number"),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () => stage.showAlert(
          PlayerDetails(
            group.names.value.indexOf(name), 
            this.maxWidth/(this.tileSize + this.bottom),
          ), 
          size: PlayerDetails.height,
        ),
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
          duration: const Duration(milliseconds: 360),
          color: selected 
            ? selectedColor
            : subColor,
          increment: _increment,
          borderRadiusFraction: attacking ? 0.1 : 1.0,
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
              onLongPress: () => stateBloc.toggleHavePartner(name),
              onTap: () => stateBloc.toggleUsePartner(name, force: true),
              child: Container(
                width: coreTileSize,
                height: coreTileSize,
                child: Transform(
                  transform: Matrix4.rotationY(usingPartnerB  
                    ? pi
                    : 0.0
                  ),
                  origin: Offset(
                    coreTileSize / 2,
                    coreTileSize / 2,
                  ),
                  child: Icon(
                    havingPartnerB==true
                      ? rawSelected == true 
                        ? McIcons.account_multiple
                        : McIcons.account_multiple_outline
                      : rawSelected == true 
                        ? McIcons.account
                        : McIcons.account_outline,
                  ),
                ),
              ),
            ),
          ),),
          //attacking icon for commander damage screen
          Positioned.fill(child: AnimatedPresented(
            duration: CSAnimations.fast,
            presented: page == CSPage.commanderDamage && whoIsAttacking==name,
            child: InkWell(
              onLongPress: () => stateBloc.toggleHavePartner(name),
              onTap: () => stateBloc.toggleUsePartner(name, force: true),
              child: Container(
                width: coreTileSize,
                height: coreTileSize,
                child: Transform(
                  transform: Matrix4.rotationY(usingPartnerB  
                    ? pi
                    : 0.0
                  ),
                  origin: Offset(
                    coreTileSize / 2,
                    coreTileSize / 2,
                  ),
                  child: Icon(
                    havingPartnerB==true
                      ? CSIcons.attackTwo
                      : CSIcons.attackOne,
                  ),
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
                  ? CSIcons.defenceFilled
                  : CSIcons.defenceOutline,
              ),
            ),
          ),),
        ],
      ),
    );
  }

  Widget buildBody(bool rawSelected, ThemeData theme){
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
                color: theme.brightness.contrast,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
            AnimatedListed(
              listed: annotation!="", 
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: AnimatedText(
                  annotation,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: theme.brightness.contrast,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
