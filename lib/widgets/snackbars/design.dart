import 'package:counter_spell_new/core.dart';


class DesignSnackBar extends StatelessWidget {

  const DesignSnackBar();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final bloc = CSBloc.of(context)!;
    final placeVar = stage.themeController.colorPlace;
    final themer = bloc.themer!;
    // final pageColorsVar = stage.themeController.derived.mainPageToPrimaryColor;
    // final color = theme.accentColor;

    return StageSnackBar(
      contentPadding: EdgeInsets.zero,
      title: Row(children: [
        Expanded(child: placeVar.build((_, place) => CenteredTile(
          leading: const Icon(McIcons.palette_outline),
          title: const Text("Color on:"),
          subtitle: Text(place.isTexts ? "Text" : "Background"),
          onTap: themer.toggleGoogleLikeColors,
        ),),),
        CSWidgets.collapsedPanelDivider,
        Expanded(child: themer.flatDesign!.build((_, flat) => CenteredTile(
          leading: const Icon(McIcons.android_studio),
          title: const Text("Design:"),
          subtitle: Text(flat! ? "Flat" : "Solid"),
          onTap: themer.toggleFlatDesign,
        ),),),
      ],),
      onTap: null,
    );

  }
}

