import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/arena_widget.dart';
import 'button.dart';
import 'menu/menu.dart';

class ArenaMenuButton extends StatelessWidget {

  //button
  final CSBloc logic;
  final Map<int,String> indexToName;
  final bool isScrollingSomewhere;
  final bool open;
  final VoidCallback openMenu;
  final VoidCallback closeMenu;
  final double buttonSize;
  final VoidCallback exit;
  final CSPage page;

  //menu
  final bool squadLayout;
  final VoidCallback reorderPlayers;
  final BoxConstraints screenConstraints;
  final List<String> names;

  ArenaMenuButton({
    @required this.page,
    @required this.logic,
    @required this.indexToName,
    @required this.isScrollingSomewhere,
    @required this.open,
    @required this.openMenu,
    @required this.closeMenu,
    @required this.buttonSize,
    @required this.exit,
    @required this.reorderPlayers,
    @required this.squadLayout,
    @required this.screenConstraints,
    @required this.names,
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
          squadLayout: squadLayout, 
          reorderPlayers: reorderPlayers, 
          exit: exit, 
          close: closeMenu,
        ),
      ),
    );

    final Widget button = ArenaButton(
      page: page,
      isScrollingSomewhere: isScrollingSomewhere,
      exit: exit,
      openMenu: openMenu,
      indexToName: indexToName,
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



class ArenaUndo extends StatelessWidget {

  const ArenaUndo(this.undoRedoAxis, this.open);
  
  final Axis undoRedoAxis;
  final bool open;

  static const double size = ArenaWidget.buttonDim;
  static const double halfSize = size / 2;
  static const icons = [Icons.undo, Icons.redo];

  @override
  Widget build(BuildContext context) {
    final bool horizontal = undoRedoAxis == Axis.horizontal;
    final bool vertical = !horizontal;

    final logic = CSBloc.of(context).game.gameState;

    final radius = Radius.circular(halfSize);

    final actives = [logic.backable, logic.forwardable];
    final taps = [logic.back, logic.forward];

    final radiuses = [
      BorderRadius.only(
        topLeft: radius, 
        topRight: vertical ? radius : Radius.zero, 
        bottomLeft: horizontal ? radius : Radius.zero, 
      ),
      BorderRadius.only(
        bottomRight: radius, 
        topRight: horizontal ? radius : Radius.zero, 
        bottomLeft: vertical ? radius : Radius.zero,
      ),
    ];

    final margins = [
      EdgeInsets.only(
        bottom: vertical ? halfSize : 0,
        right: horizontal ? halfSize : 0, 
      ),
      EdgeInsets.only(
        top: vertical ? halfSize : 0,
        left: horizontal ? halfSize : 0, 
      ),
    ];
    final alignments = vertical 
      ? [Alignment.bottomCenter, Alignment.topCenter] 
      : [Alignment.centerRight, Alignment.centerLeft];

    const axisAlignments = [-1.0, 1.0];

    final startingTheme = Theme.of(context);
    final materialColor = Color.alphaBlend(
      SubSection.getColor(startingTheme), 
      startingTheme.canvasColor,
    );

    final paddings = horizontal /// To show shadow around the material
      ? [EdgeInsets.fromLTRB(8, 8, 0, 8), EdgeInsets.fromLTRB(0, 8, 8, 8)]
      : [EdgeInsets.fromLTRB(8, 8, 8, 0), EdgeInsets.fromLTRB(8, 0, 8, 8)];

    return logic.gameState.build((_, __) => Flex(
      direction: undoRedoAxis,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for(final n in [0,1])
          Container(
            width: size * 2,
            height: size * 2,
            alignment: alignments[n],
            child: AnimatedListed(
              listed: !open,
              axis: undoRedoAxis,
              overlapSizeAndOpacity: 1.0,
              axisAlignment: axisAlignments[n],
              child: Padding(
                padding: paddings[n],
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  color: materialColor,
                  elevation: 4,
                  borderRadius: radiuses[n],
                  child: Container(
                    width: size,
                    height: size,
                    margin: margins[n],
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(icons[n], size: 20),
                      onPressed: actives[n] ? taps[n] : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),);
  }
}