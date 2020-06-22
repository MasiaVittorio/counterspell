import 'package:counter_spell_new/core.dart';


class ArenaButton extends StatelessWidget {

  ArenaButton({
    @required this.indexToName,
    @required this.isScrollingSomewhere,
    @required this.open,
    @required this.openMenu,
    @required this.routeAnimationValue,
    @required this.buttonSize,
    @required this.exit,
  });

  final Map<int,String> indexToName;
  final bool isScrollingSomewhere;
  final bool open;
  final VoidCallback openMenu;
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
      centerTap = openMenu;
    }
    assert(buttonCross != null);
    assert(centerTap != null);

    return InkWell(
      onTap: centerTap,
      onLongPress: exit,
      borderRadius: BorderRadius.circular(this.buttonSize/2),
      child: Container(
        key: ValueKey("simplegroup_button_animated_icon"),
        alignment: Alignment.center,
        width: this.buttonSize,
        height: this.buttonSize,
        child: ImplicitlyAnimatedIcon(
          progress: buttonCross ? 1.0 : 0.0,
          icon: AnimatedIcons.menu_close,
          duration: CSAnimations.medium,
        ),
      ),
    );

  }
}