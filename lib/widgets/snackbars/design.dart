import 'package:counter_spell_new/core.dart';


class DesignSnackBar extends StatelessWidget {

  const DesignSnackBar();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final bloc = CSBloc.of(context);
    final placeVar = stage.themeController.colorPlace;
    final CSThemer themer = bloc.themer;
    // final pageColorsVar = stage.themeController.derived.mainPageToPrimaryColor;
    // final color = theme.accentColor;

    if(!CSThemer.flatLinkedToColorPlace){
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
          Expanded(child: themer.flatDesign.build((_, flat) => CenteredTile(
            leading: const Icon(McIcons.android_studio),
            title: const Text("Design:"),
            subtitle: Text(flat? "Flat" : "Solid"),
            onTap: themer.toggleFlatDesign,
          ),),),
        ],),
        onTap: null,
      );
    } else {
      return StageSnackBar(
        secondary: const Icon(McIcons.android_studio),
        title: themer.flatDesign.build((_, flat) => Text(
          flat ? "Flat design" : "Solid design",
        )),
        subtitle: const Text(
          "Tap to toggle", 
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        onTap: themer.toggleFlatDesign,
        scrollable: true,
      );
    }

  }
}

