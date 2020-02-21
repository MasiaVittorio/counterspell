import 'package:counter_spell_new/core.dart';


class ArenaMenuButton extends StatelessWidget {

  //button
  final CSBloc bloc;
  final Map<int,String> indexToName;
  final bool isScrollingSomewhere;
  final bool open;
  final VoidCallback toggleOpen;
  final double routeAnimationValue;
  final double buttonSize;
  final VoidCallback exit;

  //menu
  final GameState gameState;
  final bool squadLayout;
  final VoidCallback reorderPlayers;
  final BoxConstraints screenConstraints;


  ArenaMenuButton({
    @required this.bloc,
    @required this.indexToName,
    @required this.isScrollingSomewhere,
    @required this.open,
    @required this.toggleOpen,
    @required this.routeAnimationValue,
    @required this.buttonSize,
    @required this.exit,
    @required this.gameState,
    @required this.reorderPlayers,
    @required this.squadLayout,
    @required this.screenConstraints,
  });

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    final horizontalView = screenConstraints.maxHeight < screenConstraints.maxWidth;

    final double menuWidth = screenConstraints.maxWidth * (horizontalView ? 0.5 : 0.85);
    final double menuHeight = screenConstraints.maxHeight * (horizontalView ? 0.85 : 0.5);
    final Widget menu = SizedBox(
      width: menuWidth,
      height: menuHeight,
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: _ArenaMenu(
          gameState: gameState, 
          squadLayout: squadLayout, 
          reorderPlayers: reorderPlayers, 
          exit: exit, 
          close: toggleOpen,
        ),
      ),
    );

    final Widget button = _ArenaButton(
      routeAnimationValue: routeAnimationValue,
      isScrollingSomewhere: isScrollingSomewhere,
      exit: exit,
      toggleOpen: toggleOpen,
      indexToName: indexToName,
      buttonSize: buttonSize,
      open: open,
    );



    return Opacity(
      opacity: this.routeAnimationValue,
      child: Material(
        clipBehavior: Clip.antiAlias,
        animationDuration: CSAnimations.medium,
        elevation: open ? 10 : 4,
        borderRadius: BorderRadius.circular(open ? 16 : this.buttonSize/2),
        child: AnimatedContainer(
          duration: CSAnimations.medium,
          width: open ? menuWidth : buttonSize,
          height: open ? menuHeight : buttonSize,
          curve: Curves.fastOutSlowIn,
          child: Stack(
            alignment: Alignment.center, 
            children: <Widget>[
              AnimatedDouble(
                duration: CSAnimations.medium,
                value: !open ? 1.0 : -1.0,
                builder:(_, val)=> Opacity(
                  opacity: val.clamp(0.0, 1.0),
                  child: IgnorePointer(
                    ignoring: open,
                    child: button,
                  ),
                ),
              ),
              Positioned(
                top: 0.0,
                width: menuWidth,
                height: menuHeight,
                child: AnimatedDouble(
                  duration: CSAnimations.medium,
                  value: open ? 1.0 : -1.0,
                  builder:(_, val)=> Opacity(
                    opacity: val.clamp(0.0, 1.0),
                    child: IgnorePointer(
                      ignoring: !open,
                      child: menu,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArenaButton extends StatelessWidget {

  _ArenaButton({
    @required this.indexToName,
    @required this.isScrollingSomewhere,
    @required this.open,
    @required this.toggleOpen,
    @required this.routeAnimationValue,
    @required this.buttonSize,
    @required this.exit,
  });

  final Map<int,String> indexToName;
  final bool isScrollingSomewhere;
  final bool open;
  final VoidCallback toggleOpen;
  final double routeAnimationValue;
  final double buttonSize;
  final VoidCallback exit;

  @override
  Widget build(BuildContext context) {

    final CSBloc bloc = CSBloc.of(context);

    VoidCallback centerTap;
    bool buttonCross;

    if(indexToName.values.any((v) => v == null)){
      buttonCross = true;
      centerTap = exit;
    } else if(this.isScrollingSomewhere){
      buttonCross = true;
      centerTap = bloc.scroller.cancel;
    } else {
      buttonCross = open;
      centerTap = toggleOpen;
    }
    assert(buttonCross != null);
    assert(centerTap != null);

    return InkWell(
      onTap: centerTap,
      onLongPress: exit,
      borderRadius: BorderRadius.circular(this.buttonSize/2),
      child: Container(
        alignment: Alignment.center,
        width: this.buttonSize,
        height: this.buttonSize,
        child: ImplicitlyAnimatedIcon(
          key: ValueKey("simplegroup_button_animated_icon"),
          state: buttonCross,
          icon: AnimatedIcons.menu_close,
          duration: CSAnimations.medium,
        ),
      ),
    );

  }
}


class _ArenaMenu extends StatelessWidget {

  const _ArenaMenu({
    @required this.gameState,
    @required this.squadLayout,
    @required this.reorderPlayers,
    @required this.exit,
    @required this.close,
  });

  final GameState gameState;
  final bool squadLayout;
  final VoidCallback reorderPlayers;
  final VoidCallback exit;
  final VoidCallback close;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings;

    return ListView(
      physics: SidereusScrollPhysics(
        topBounce: true,
        topBounceCallback: close,
        alwaysScrollable: true,
        neverScrollable: false,
      ),
      children: <Widget>[
        if(gameState.players.length != 2)
          Section(<Widget>[
            const AlertTitle("Layout"),
            RadioSlider(
              selectedIndex: squadLayout ? 0 : 1,
              onTap: (i) => settings.arenaSquadLayout.set(i==0),
              items: [
                RadioSliderItem(
                  icon: Icon(McIcons.account_multiple_outline),
                  title: Text("Squad"),
                ),
                RadioSliderItem(
                  icon: Icon(McIcons.account_outline),
                  title: Text("Free for all"),
                ),
              ],
            ),
          ]),
          Section(<Widget>[
            const SectionTitle("Actions"),
            ListTile(
              leading: Icon(McIcons.account_group_outline),
              title: Text("Reorder players"),
              onTap: reorderPlayers,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              FlatButton(
                onPressed: exit,
                child: Text("Exit Arena mode"),
              ),
            ],),
          ],),
      ],
    );
  }
}