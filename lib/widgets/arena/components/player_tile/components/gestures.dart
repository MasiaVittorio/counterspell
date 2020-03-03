import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile_gestures.dart';

class AptGestures extends StatelessWidget {

  AptGestures({
    @required this.bloc,
    @required this.name,
    @required this.isScrollingSomewhere,
    @required this.rawSelected,
    @required this.constraints,
  });

  //Business Logic
  final CSBloc bloc;

  //Actual Game State
  final String name;

  //Interaction information
  final bool isScrollingSomewhere;
  final bool rawSelected;
  //TODO: attacca / difendi

  //Layout information
  final BoxConstraints constraints;


  @override
  Widget build(BuildContext context) {

    final CSScroller scrollerBloc = bloc.scroller;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => PlayerGestures.tap(
          name,
          page: CSPage.life,
          attacking: false,
          rawSelected: rawSelected,
          bloc: bloc,
          isScrollingSomewhere: isScrollingSomewhere,
          hasPartnerB: false,
          usePartnerB: false, // just life lol
        ),
        child: VelocityPanDetector(
          onPanEnd: (_details) => scrollerBloc.onDragEnd(),
          onPanUpdate: (details) => PlayerGestures.pan(
            details,
            name,
            constraints.maxWidth,
            bloc: bloc,
            page: CSPage.life,
            vertical: bloc.settings.arenaScreenVerticalScroll.value,
          ),
          onPanCancel: scrollerBloc.onDragEnd,
          child: Container(
            // width: constraints.maxWidth - _margin*2,
            // height: constraints.maxHeight - _margin*2,
            //to make the pan callback working, the color cannot be just null
            color: Colors.transparent,
            child: SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}