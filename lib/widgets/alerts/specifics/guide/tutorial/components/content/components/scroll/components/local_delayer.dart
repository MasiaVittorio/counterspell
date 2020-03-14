import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/panel/collapsed_components/delayer.dart';



class LocalDelayer extends StatelessWidget {

  LocalDelayer(this.localScroller, this.bloc);

  final CSScroller localScroller;
  final CSBloc bloc;

  @override
  Widget build(BuildContext context) {

    final ThemeData themeData = Theme.of(context);
    final primary = Color.alphaBlend(
      SubSection.getColor(themeData), 
      themeData.canvasColor
    );
    final primaryContrast = themeData.colorScheme.onSurface;

    final StageData<CSPage,SettingsPage> stage = Stage.of(context);

    return BlocVar.build4(
      localScroller.isScrolling,
      localScroller.intValue,
      bloc.settings.confirmDelay,
      stage.themeController.primaryColor,
      distinct: true,
      builder: (
        BuildContext context, 
        bool scrolling,
        int increment,
        Duration confirmDelay,
        Color currentPrimaryColor,
      ){
        final accentColor = Color.alphaBlend(
          currentPrimaryColor,
          primary,
        );
        return AnimatedOpacity(
          duration: CSAnimations.veryFast,
          curve: Curves.decelerate,
          opacity: scrolling ? 1.0 : 0.0,
          child: IgnorePointer(
            ignoring: scrolling ? false : true,
            child: Delayer(
              half: false,
              message: increment >= 0 ? '+ $increment' : '- ${- increment}',

              delayerController: localScroller.delayerController,
              animationListener: localScroller.delayerAnimationListener,
              onManualCancel: scrolling ? localScroller.cancel : null,
              onManualConfirm: scrolling ? localScroller.forceComplete : null,

              primaryColor: Colors.transparent,
              onPrimaryColor: primaryContrast,
              accentColor: accentColor,
              onAccentColor: themeData.colorScheme.onPrimary,
              style: themeData.primaryTextTheme.body1,

              height: CSSizes.barSize,
              duration: confirmDelay,
              circleOffset: 44, //Floating Action Button
            ),
          ),
        );
      },
    );

  }
}