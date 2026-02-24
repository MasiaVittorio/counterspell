import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/arena/arena_widget.dart';

class ArenaUndo extends StatelessWidget {
  const ArenaUndo({
    super.key,
    required this.undoRedoAxis,
    required this.open,
    required this.scrollingSomewhere,
  });

  final Axis undoRedoAxis;
  final bool open;
  final bool scrollingSomewhere;

  static const double size = ArenaWidget.buttonDim;
  static const double halfSize = size / 2;
  static const icons = [Icons.undo, Icons.redo];

  @override
  Widget build(BuildContext context) {
    final bool horizontal = undoRedoAxis == Axis.horizontal;
    final bool vertical = !horizontal;

    final logic = CSBloc.of(context).game.gameState;

    const radius = Radius.circular(halfSize);

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

    final paddings = horizontal
        /// To show shadow around the material
        ? [
            const EdgeInsets.fromLTRB(8, 8, 0, 8),
            const EdgeInsets.fromLTRB(0, 8, 8, 8),
          ]
        : [
            const EdgeInsets.fromLTRB(8, 8, 8, 0),
            const EdgeInsets.fromLTRB(8, 0, 8, 8),
          ];

    return logic.gameState.build(
      (_, _) => Flex(
        direction: undoRedoAxis,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (final n in [0, 1])
            Container(
              width: size * 2,
              height: size * 2,
              alignment: alignments[n],
              child: AnimatedListed(
                listed: !open && !scrollingSomewhere,
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
      ),
    );
  }
}
