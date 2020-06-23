import 'package:counter_spell_new/core.dart';
import 'button.dart';
import 'menu.dart';

class ArenaMenuButton extends StatelessWidget {

  //button
  final CSBloc bloc;
  final Map<int,String> indexToName;
  final bool isScrollingSomewhere;
  final bool open;
  final VoidCallback openMenu;
  final VoidCallback closeMenu;
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
    @required this.openMenu,
    @required this.closeMenu,
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
        child: ArenaMenu(
          gameState: gameState, 
          squadLayout: squadLayout, 
          reorderPlayers: reorderPlayers, 
          exit: exit, 
          close: closeMenu,
        ),
      ),
    );

    final Widget button = ArenaButton(
      routeAnimationValue: routeAnimationValue,
      isScrollingSomewhere: isScrollingSomewhere,
      exit: exit,
      openMenu: openMenu,
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
              AnimatedDouble( //clamping the [-1, 0] part in order to cross fade between the two objects implicitly
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

