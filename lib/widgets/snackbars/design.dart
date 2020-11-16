import 'package:counter_spell_new/core.dart';


class DesignSnackBar extends StatelessWidget {

  const DesignSnackBar();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);
    final theme = Theme.of(context);
    final placeVar = stage.themeController.colorPlace;
    final themer = bloc.themer;
    // final pageColorsVar = stage.themeController.derived.mainPageToPrimaryColor;
    // final color = theme.accentColor;

    return StageSnackBar(
      contentPadding: EdgeInsets.zero,
      title: Row(children: [
        Expanded(child: placeVar.build((_, place) => _SaneTile(
          icon: const Icon(McIcons.palette_outline),
          title: const Text("Color on:"),
          subtitle: Text(place.isTexts ? "Text" : "Background"),
          onTap: themer.toggleGoogleLikeColors,
        ),),),
        Container(
          height: CSSizes.collapsedPanelSize * 0.65,
          width: 1.0,
          color: theme.textTheme.bodyText1.color
            .withOpacity(0.5),
        ),
        Expanded(child: themer.flatDesign.build((_, flat) => _SaneTile(
          icon: const Icon(McIcons.android_studio),
          title: const Text("Design:"),
          subtitle: Text(flat ? "Flat" : "Solid"),
          onTap: themer.toggleFlatDesign,
        ),),),
      ],),
      onTap: null,
    );

  }
}

class _SaneTile extends StatelessWidget {
  const _SaneTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    @required this.onTap,
  });

  final Widget title;
  final Widget subtitle;
  final Widget icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: CSSizes.collapsedPanelSize,
          alignment: Alignment.center,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              height: CSSizes.collapsedPanelSize,
              width: CSSizes.collapsedPanelSize,
              alignment: Alignment.center,
              child: icon,
            ),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: theme.textTheme.subtitle1,
                  child: title,
                ),
                DefaultTextStyle(
                  style: theme.textTheme.bodyText2
                    .copyWith(color: theme.textTheme.caption.color),
                  child: subtitle,
                ),
              ],
            ),),
          ],),
        ),
      ),
    );
  }
}