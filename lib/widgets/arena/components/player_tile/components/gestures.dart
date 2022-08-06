import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/components/player_tile/components/all.dart';
import 'package:counter_spell_new/widgets/stage/body/group/player_tile_gestures.dart';

class AptGestures extends StatelessWidget {

  const AptGestures({
    required this.content,
    required this.bloc,
    required this.name,
    required this.isScrollingSomewhere,
    required this.rawSelected,
    required this.constraints,
    required this.page,
    required this.whoIsAttacking,
    required this.whoIsDefending,
    required this.havingPartnerB,
    required this.usingPartnerB,
    required this.buttonAlignment,
  });

  final Alignment buttonAlignment;
  //child
  final Widget content;

  //Business Logic
  final CSBloc bloc;

  //Actual Game State
  final String name;

  //Interaction information
  final bool isScrollingSomewhere;
  final bool? rawSelected;
  final CSPage page;
  final String? whoIsAttacking;
  final String? whoIsDefending;
  final bool? havingPartnerB;
  final bool? usingPartnerB;

  //Layout information
  final BoxConstraints constraints;

  static const double aptCmdrDamageExtraPadding = 20;

  @override
  Widget build(BuildContext context) {

    final StageData<CSPage,SettingsPage> stage = Stage.of(context)!;

    final bloc = CSBloc.of(context)!;
    final settings = bloc.settings.arenaSettings;

    return Material(
      type: MaterialType.transparency,
      child: StageBuild.offMainEnabledPages((_, enabled) 
        => bloc.settings.arenaSettings.scrollOverTap.build((context, scrollOverTap) {

          if(scrollOverTap){
            final Widget interactiveContent = InkResponse(
              onTap:() => tapWithScrollSettings(stage), 
              onLongPress: enabled[CSPage.commanderDamage]! 
                ? () => longPressWithScrollSettings(stage)
                : null,
              child: VelocityPanDetector(
                onPanUpdate: onPanUpdate,
                onPanEnd: onPanEnd,
                onPanCancel: bloc.scroller.onDragEnd,
                child: Container(
                  /// Transparent color (not just null) unless the empty part would not be interactive
                  color: Colors.transparent,
                  child: content,
                ),
              ),
            );

            final Widget arrows = settings.verticalScroll.build((context, verticalScroll) {
              final Map<bool,Widget> children = <bool,Widget>{
                for(bool plus in const <bool>[true,false])
                  plus: Expanded(child: Container(
                    /// color: null because it should not be interactive
                    child: buildArrow(verticalScroll, plus),
                  ),),
              };
              
              return Flex(
                direction: verticalScroll ? Axis.vertical : Axis.horizontal,
                children: <Widget>[
                  if(verticalScroll) ...[children[true]!, children[false]!] /// top + bottom -
                  else ...[children[false]!, children[true]!], /// left - right +
                ],
              );
            },);


            return Stack(children: <Widget>[
              Positioned.fill(child: arrows),
              Positioned.fill(child: interactiveContent),
            ],);
          } 

          final Widget buttons = settings.verticalTap.build((context, verticalTap) {

            final Map<bool,Widget> children = <bool,Widget>{
              for(bool plus in const <bool>[true,false])
                plus: Expanded(child: ContinuousPressInkResponse(
                  containedInkWell: true,
                  onTap: (){}, /// not null because the inkwell must be seen as enabled
                  onTapDown: (_) => tapOnly(plus, stage),
                  whileLongPress: () => tapOnly(plus, stage),
                  interval: const Duration(milliseconds: 250),
                  child: Container(
                    color: Colors.transparent,
                    child: buildArrow(verticalTap, plus),
                  ),
                ),),
            };

            return Flex(
              direction: verticalTap ? Axis.vertical : Axis.horizontal,
              children: <Widget>[
                if(verticalTap) ...[children[true]!, children[false]!] /// top + bottom -
                else ...[children[false]!, children[true]!], /// left - right +
              ],
            );
          },);

          return Stack(children: <Widget>[

            Positioned.fill(child: buttons),

            Positioned.fill(child: content),

            if(enabled[CSPage.commanderDamage]!)
              Positioned(
                bottom: - aptCmdrDamageExtraPadding,
                right: - aptCmdrDamageExtraPadding,
                left: - aptCmdrDamageExtraPadding,
                top: 0,
                child: Align(
                  alignment: AptContent.rightInfoFromButtonAlignment(buttonAlignment)
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                  child: AptCmdrDmg(
                    bloc: this.bloc, 
                    name: name, 
                    page: page, 
                    whoIsAttacking: whoIsAttacking,
                    whoIsDefending: whoIsDefending,
                    usePartnerB: usingPartnerB,
                    hasPartnerB: havingPartnerB,
                  ),
                ),
              ),
          ],);
        },),
      ),
    );
  }



  Widget buildArrow(bool vertical, bool plus) => Align(
    alignment: _alignments[vertical]![plus]!,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(_icons[vertical]![plus]),
    ),
  );

  static const Map<bool, Map<bool,IconData>> _icons = <bool,Map<bool,IconData>>{
    true: <bool,IconData>{
      true: Icons.keyboard_arrow_up,
      false: Icons.keyboard_arrow_down,
    },
    false: <bool,IconData>{
      true: Icons.keyboard_arrow_right,
      false: Icons.keyboard_arrow_left,
    },
  };

  static const Map<bool, Map<bool,Alignment>> _alignments = <bool,Map<bool,Alignment>>{
    true: <bool,Alignment>{
      true: Alignment.topCenter,
      false: Alignment.bottomCenter,
    },
    false: <bool,Alignment>{
      true: Alignment.centerRight,
      false: Alignment.centerLeft,
    },
  };



  /// With scroll settings, taps are used to select
  void tapWithScrollSettings(StageData stage) {
    if(
      page == CSPage.commanderDamage 
      // && !(whoIsAttacking == name && havingPartnerB!)
    ){
      bloc.game.gameAction.clearSelection();
      stage.mainPagesController.goToPage(CSPage.life);
    } else {
      PlayerGestures.tap(
        name,
        page: page,
        attacking: whoIsAttacking == name,
        rawSelected: rawSelected,
        bloc: bloc,
        isScrollingSomewhere: isScrollingSomewhere,
        hasPartnerB: havingPartnerB,
        usePartnerB: usingPartnerB,
      );
    }
  }


  /// With scroll settings, a long press will trigger commander damage
  /// (without scroll settings, it wont be there altogether)
  void longPressWithScrollSettings(StageData? stage){
    if(page == CSPage.commanderDamage && whoIsAttacking == name){
      stage!.mainPagesController.goToPage(CSPage.life);
    } else {
      stage!.mainPagesController.goToPage(CSPage.commanderDamage);
      bloc.game.gameAction.attackingPlayer.set(name);
      bloc.game.gameAction.defendingPlayer.set("");
    } 
  }

  void onPanUpdate(CSDragUpdateDetails details) => PlayerGestures.pan(
    details,
    name,
    constraints.maxWidth,
    bloc: bloc,
    page: page,
    vertical: bloc.settings.arenaSettings.verticalScroll.value,
  );

  void onPanEnd(DragEndDetails _) => bloc.scroller.onDragEnd();


  /// with only taps, we need the relative position to be able to determimne if the
  /// tap happened on the top or bottom half of the player tile, so we will need to use
  /// the onTapUp callback instead of the normal onTap one.
  void tapOnly(bool topHalf, StageData? stage){
    PlayerGestures.tapOnlyArena(
      name, 
      bloc: bloc, 
      page: page, 
      whoIsAttacking: whoIsAttacking,
      topHalf: topHalf,
      whoIsDefending: whoIsDefending, 
    );
  }

}




enum _CmdrMode {
  outOfCommanderDamage,
  isAttacking, 
  isWaitingForAttack,
  isDefending,
}


class AptCmdrDmg extends StatelessWidget {
  const AptCmdrDmg({
    required this.bloc,
    required this.name,
    required this.page,
    required this.whoIsAttacking,
    required this.whoIsDefending,
    required this.hasPartnerB,
    required this.usePartnerB,
  });

  final CSBloc? bloc;
  final String name;
  final CSPage page;
  final String? whoIsAttacking;
  final String? whoIsDefending;
  final bool? hasPartnerB;
  final bool? usePartnerB;

  static const double _size = 56.0 
    + 2 * AptGestures.aptCmdrDamageExtraPadding;
  // + 40 because it's used on a positioned(
  // left: -20, right: -20, bottom: -20
  // ) and makes the tappable part bigger 
  // without affecting the layout

  static const Map<_CmdrMode,IconData> _icons= <_CmdrMode,IconData>{
    _CmdrMode.outOfCommanderDamage: CSIcons.damageOutlined,
    _CmdrMode.isAttacking: CSIcons.attackTwo,
    _CmdrMode.isWaitingForAttack: CSIcons.defenceOutline,
    _CmdrMode.isDefending: CSIcons.defenceFilled,
  };

  @override
  Widget build(BuildContext context) {
    _CmdrMode mode;
    if(page != CSPage.commanderDamage){
      mode = _CmdrMode.outOfCommanderDamage;
    } else if(whoIsAttacking == name) {
      mode = _CmdrMode.isAttacking;
    } else if(whoIsDefending == name){
      mode = _CmdrMode.isDefending;
    } else {
      mode = _CmdrMode.isWaitingForAttack;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(_size / 2),
      onTap: (){
        switch (mode) {
          case _CmdrMode.outOfCommanderDamage:
            bloc!.stage.mainPagesController.goToPage(CSPage.commanderDamage);
            bloc!.game.gameAction.attackingPlayer.set(name);
            bloc!.game.gameAction.defendingPlayer.set("");
            break;
          default:
            bloc!.stage.mainPagesController.goToPage(CSPage.life);
        }
      },
      onLongPress: mode == _CmdrMode.isAttacking && hasPartnerB!
        ? (){
          //toggling used partners
          bloc!.game.gameState.gameState.value.players[name]!.usePartnerB = !usePartnerB!;
          bloc!.game.gameState.gameState.refresh();
        }
        : null,
      child: Container(
        alignment: Alignment.center,
        width: _size,
        height: _size,
        child: Icon(_icons[mode]),
      ),
    );
  }
}