
import 'package:counter_spell_new/core.dart';


class ArenaMenuLayout extends StatelessWidget {

  const ArenaMenuLayout({
    required this.names,
    required this.height,
    required this.layoutType,
    required this.flipped,
    required this.positions,
  });

  final double height;
  final List<String> names;
  final ArenaLayoutType? layoutType;
  final Map<ArenaLayoutType?,bool> flipped;
  final Map<int,String?> positions;

  @override
  Widget build(BuildContext context) {

    final bloc = CSBloc.of(context)!;
    final arenaBloc = bloc.settings.arenaSettings;
    final groupBloc = bloc.game.gameGroup;
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height - CSSizes.barSize,
      ),
      child: Material(
        child: Column(
          children: <Widget>[
            const PanelTitle("Players' layout"),
            Expanded(
              child: ArenaLayoutPicker(
                type: layoutType, 
                onTypeChanged: arenaBloc.layoutType.set,
                flipped: flipped, 
                onFlippedChanged: (type, val){
                  arenaBloc.flipped.value[type] = val;
                  arenaBloc.flipped.refresh();
                }, 
                names: names.toSet(), 
                positions: positions, 
                onPositionsChange: groupBloc.arenaNameOrder.set,
              ),
            ),
          ],
        ),
      ),
    );

  }
}


