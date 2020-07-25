import 'package:counter_spell_new/core.dart';
import 'button.dart';
import 'menu/menu.dart';

class ArenaMenuButton extends StatelessWidget {

  //button
  final CSBloc logic;
  final Map<int,String> positions;
  final bool isScrollingSomewhere;
  final bool open;
  final VoidCallback openMenu;
  final VoidCallback closeMenu;
  final double buttonSize;
  final VoidCallback exit;
  final CSPage page;
  final ArenaLayoutType layoutType;

  //menu
  final VoidCallback reorderPlayers;
  final BoxConstraints screenConstraints;
  final List<String> names;
  final Map<ArenaLayoutType,bool> flipped;

  ArenaMenuButton({
    @required this.page,
    @required this.logic,
    @required this.positions,
    @required this.isScrollingSomewhere,
    @required this.open,
    @required this.openMenu,
    @required this.closeMenu,
    @required this.buttonSize,
    @required this.exit,
    @required this.reorderPlayers,
    @required this.screenConstraints,
    @required this.names,
    @required this.layoutType,
    @required this.flipped,
  });

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    final horizontalView = screenConstraints.maxHeight < screenConstraints.maxWidth;

    final double menuWidth = screenConstraints.maxWidth * (horizontalView ? 0.5 : 0.85);
    final double menuHeight = screenConstraints.maxHeight * (horizontalView ? 0.85 : 0.65);


    final Widget menu = SizedBox(
      width: menuWidth,
      height: menuHeight,
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: ArenaMenu(
          names: names, 
          reorderPlayers: reorderPlayers, 
          exit: exit, 
          close: closeMenu,
          height: menuHeight,
          layoutType: layoutType,
          flipped: flipped,
          positions: positions,
        ),
      ),
    );

    final Widget button = ArenaButton(
      page: page,
      isScrollingSomewhere: isScrollingSomewhere,
      exit: exit,
      openMenu: openMenu,
      indexToName: positions,
      buttonSize: buttonSize,
      open: open,
    );



    return Material(
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
              builder:(_, val) => Opacity(
                // clamping the [-1, 0] part in order to 
                // cross fade between the two objects implicitly
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
                builder:(_, val) => Opacity(
                  // clamping the [-1, 0] part in order to 
                  // cross fade between the two objects implicitly
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
    );
  }
}


