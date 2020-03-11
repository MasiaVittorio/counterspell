import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_gestures.dart';

class LocalNumber extends StatelessWidget {

  LocalNumber(this.localScroller, this.bloc, this.value, this.callback);

  final CSScroller localScroller;
  final CSBloc bloc;
  final int value;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {

    final StageData stage = Stage.of(context);

    return LayoutBuilder(
      builder: (_, constraints) => VelocityPanDetector(
        onPanEnd: (_details) => localScroller.onDragEnd(),
        onPanUpdate: (details) {
          this.callback();
          PlayerGestures.pan(
            details,
            "",
            constraints.maxWidth,
            bloc: bloc,
            page: CSPage.life,
            dummyScroller: localScroller,
          );
        },
        onPanCancel: localScroller.onDragEnd,
        child: BlocVar.build3(
          localScroller.isScrolling,
          localScroller.intValue,
          stage.themeController.primaryColorsMap, 
          builder: (_, scrolling, increment, pageColors){
            final Color color = pageColors[CSPage.life];
            final colorBright = ThemeData.estimateBrightnessForColor(color);
            final Color textColor = colorBright == Brightness.light ? Colors.black : Colors.white;
            final textStyle = TextStyle(color: textColor, fontSize: 0.26 * CSSizes.minTileSize);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_left),
                  Expanded(child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: CircleNumber(
                      size: 56,
                      value: value,
                      numberOpacity: 1.0,
                      open: scrolling,
                      style: textStyle,
                      duration: CSAnimations.fast,
                      color: color,
                      increment: scrolling ? increment : 0,
                      borderRadiusFraction: 1.0,
                    ),
                  ),),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            );
          },
        ),
      ),
    );    
  }
}