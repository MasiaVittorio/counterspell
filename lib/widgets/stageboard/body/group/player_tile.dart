import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/scroller/scroller_detector.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_gestures.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_utilities.dart';

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
  final Map<String,bool> usingPartnerB;
  final Map<String,bool> havingPartnerB;

  const PlayerTile(this.name, {
    @required this.usingPartnerB,
    @required this.havingPartnerB,
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
    final StageData<CSPage,SettingsPage> stage = Stage.of<CSPage,SettingsPage>(context);
    final ThemeData theme = Theme.of(context);

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

    final playerState = gameState.players[name].states.last;
 
    //from now on we will act like the page will always be life,
    //we will abstract the player tile later to manage other pages
    //like commander damage / casts / counters

    final Widget tile = InkWell(
      onTap: () => PlayerGestures.tap(
        name,
        page: page,
        attacking: attacking,
        rawSelected: rawSelected,
        bloc: bloc,
        isScrollingSomewhere: isScrollingSomewhere,
        hasPartnerB: havingPartnerB[name],
        usePartnerB: usingPartnerB[name],
      ),
      onLongPress: () => stage.showAlert(
        PlayerDetails(bloc.game.gameGroup.names.value.indexOf(name)), 
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
                  rawSelected: rawSelected,
                  scrolling: scrolling,
                  attacking: attacking,
                  playerState: playerState,
                  defending: defending,
                  stage: stage,
                  someoneAttacking: whoIsAttacking!="" && whoIsAttacking!=null,
                ),
                Expanded(child: buildBody(rawSelected)),
                buildTrailing(rawSelected, actionBloc),
              ]),
            ),
          ),
        ),
      ),
    );

    return group.images.build((_, images){
      final String imageUrl = images[name];
      if(imageUrl == null){
        return Material(child: tile);
      } else {

        final Widget image = bloc.settings.imageAlignment.build((_,alignment) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                imageUrl,
                errorListener: (){},
              ),
              fit: BoxFit.cover,
              alignment: Alignment(0,alignment),
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
          height: tileSize,
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
                child: Material(
                  type: MaterialType.transparency,
                  child: tile,
                ),
              ),
            ],
          ),
        );
      }
    });

  }

  static const _circleFrac = 0.7;
  Widget buildLeading({
    @required PlayerState playerState,
    @required bool rawSelected,
    @required bool scrolling,
    @required bool attacking,
    @required bool defending,
    @required StageData<CSPage,SettingsPage> stage,
    @required bool someoneAttacking,
  }){
    Widget child;

    final Color color = PTileUtils.cnColor(page, attacking, defending, pageColors, theme, someoneAttacking);

    final colorBright = ThemeData.estimateBrightnessForColor(color);
    final Color textColor = colorBright == Brightness.light ? Colors.black : Colors.white;
    final textStyle = TextStyle(color: textColor, fontSize: 0.26 * coreTileSize);

    if(page == CSPage.history){

      child = Container(
        key: ValueKey("circle name"),
        width: coreTileSize*_circleFrac,
        height: coreTileSize*_circleFrac,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(coreTileSize),
        ),
        alignment: Alignment.center,
        child: Text(
          name.length > 2 ? name.substring(0,2) : name,
          style: textStyle,
        ),
      );

    } else {

      final normalizedPlayerAction = normalizedPlayerActions[name];
      final int _increment = PTileUtils.cnIncrement(normalizedPlayerAction);

      child = CircleNumber(
        key: ValueKey("circle number"),
        size: coreTileSize * _circleFrac,
        value: PTileUtils.cnValue(
          name, 
          page, 
          whoIsAttacking, 
          whoIsDefending,
          usingPartnerB[name] ?? false,
          playerState,
          usingPartnerB[whoIsAttacking] ?? false,
          counter,
        ),
        numberOpacity: PTileUtils.cnNumberOpacity(page, whoIsAttacking),
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
          //double partner // single partner for cast screen
          Positioned.fill(child: AnimatedPresented(
            duration: MyDurations.fast,
            presented: page == CSPage.commanderCast,
            child: InkWell(
              onTap: () => group.toggleHavePartner(name),
              child: Container(
                width: coreTileSize,
                height: coreTileSize,
                child: Icon(
                  havingPartnerB[name]==true
                    ? McIcons.account_multiple_outline
                    : McIcons.account_outline,
                ),
              ),
            ),
          ),),
          //attacking icon for commander damage screen
          Positioned.fill(child: AnimatedPresented(
            duration: MyDurations.fast,
            presented: page == CSPage.commanderDamage && whoIsAttacking==name,
            child: InkWell(
              onTap: () => group.toggleHavePartner(name),
              child: Container(
                width: coreTileSize,
                height: coreTileSize,
                child: Icon(
                  havingPartnerB[name]==true
                    ? CSTypesUI.attackIconTwo
                    : CSTypesUI.attackIconOne,
                ),
              ),
            ),
          ),),
          //defending icon for commander damage screen
          Positioned.fill(child: AnimatedPresented(
            duration: MyDurations.fast,
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
                  ? CSTypesUI.defenceIconFilled
                  : CSTypesUI.defenceIconOutline,
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
      havingPartnerB[name]??false,    usingPartnerB[name]??false, 
      havingPartnerB[whoIsAttacking]??false,    usingPartnerB[whoIsAttacking]??false,
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
