import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stage/panel/collapsed_components/delayer.dart';



class LocalDelayer extends StatelessWidget {

  const LocalDelayer(this.localScroller, this.bloc, {super.key});

  final CSScroller? localScroller;
  final CSBloc? bloc;

  @override
  Widget build(BuildContext context) {

    final ThemeData themeData = Theme.of(context);

    final primaryContrast = themeData.colorScheme.onSurface;

    final StageData<CSPage,SettingsPage> stage = Stage.of(context) as StageData<CSPage, SettingsPage>;

    return BlocVar.build4<bool, int, Duration, Map<CSPage,Color?>?>(
      localScroller!.isScrolling,
      localScroller!.intValue,
      bloc!.settings.scrollSettings.confirmDelay,
      stage.themeController.derived.mainPageToPrimaryColor,
      distinct: true,
      builder: (
        BuildContext context, 
        bool? scrolling,
        int? increment,
        Duration? confirmDelay,
        Map<CSPage,Color?>? colors,
      ){
        final accentColor = colors![CSPage.life];

        return AnimatedOpacity(
          duration: CSAnimations.veryFast,
          curve: Curves.decelerate,
          opacity: scrolling! ? 1.0 : 0.0,
          child: IgnorePointer(
            ignoring: scrolling ? false : true,
            child: Delayer(
              half: false,
              message: increment! >= 0 ? '+ $increment' : '- ${- increment}',

              delayerController: localScroller!.delayerController,
              animationListener: localScroller!.delayerAnimationListener,
              onManualCancel: scrolling ? localScroller!.cancel : null,
              onManualConfirm: scrolling ? localScroller!.forceComplete : null,

              primaryColor: Colors.transparent,
              onPrimaryColor: primaryContrast,
              accentColor: accentColor,
              onAccentColor: themeData.colorScheme.onPrimary,
              style: themeData.primaryTextTheme.bodyMedium,

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