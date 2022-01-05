import 'package:counter_spell_new/core.dart';


class ArenaButton extends StatelessWidget {

  ArenaButton({
    required this.indexToName,
    required this.isScrollingSomewhere,
    required this.open,
    required this.openMenu,
    required this.buttonSize,
    required this.exit,
    required this.page,
  });

  final CSPage page;
  final Map<int,String?> indexToName;
  final bool isScrollingSomewhere;
  final bool open;
  final VoidCallback openMenu;
  final double buttonSize;
  final VoidCallback exit;

  @override
  Widget build(BuildContext context) {

    final CSBloc? bloc = CSBloc.of(context);

    VoidCallback centerTap;
    bool buttonCross;

    if(indexToName.values.any((v) => v == null)){
      // reorder waiting to happen
      buttonCross = true;
      centerTap = exit;
    } else if(this.isScrollingSomewhere){
      // action pending to be cancelled
      buttonCross = true;
      centerTap = bloc!.scroller.cancel;
    } 
    else if(page != CSPage.life){
      buttonCross = true;
      centerTap = () => bloc!.stage.mainPagesController.goToPage(CSPage.life);
    } 
    else {
      buttonCross = open;
      centerTap = openMenu;
    }

    return InkWell(
      onTap: centerTap,
      onLongPress: exit,
      borderRadius: BorderRadius.circular(this.buttonSize/2),
      child: Container(
        key: ValueKey("arena_button_animated_icon"),
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