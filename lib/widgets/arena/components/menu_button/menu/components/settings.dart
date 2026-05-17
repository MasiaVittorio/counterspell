import 'package:counter_spell/core.dart';

class ArenaMenuSettings extends StatelessWidget {
  const ArenaMenuSettings({super.key, required this.players});

  final int players;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Section(<Widget>[PanelTitle("Gestures"), Gestures()]),
        CSBloc.of(context).themer.flatDesign.build(
          (context, flatDesign) => Section(<Widget>[
            SectionTitle("Appearance"),
            if (!flatDesign) ArenaFullScreenToggle(disclaimer: true),
            // with flat design, arena is opened in the stage panel, not with the OpenContainer thing
            ArenaHideNamesWithImageToggle(),
            ArenaOpacity(),
          ]),
        ),
      ],
    );
  }
}

class ArenaOpacity extends StatelessWidget {
  const ArenaOpacity({super.key});
  @override
  Widget build(BuildContext context) {
    final opacity = CSBloc.of(
      context,
    ).settings.imagesSettings.arenaImageOpacity;
    return opacity.build(
      (_, value) => FullSlider(
        value: value,
        divisions: 20,
        leading: const Icon(Icons.opacity),
        onChanged: opacity.set,
        defaultValue: CSSettingsImages.defaultSimpleImageOpacity,
        titleBuilder: (val) => Text("Opacity: ${val.toStringAsFixed(2)}"),
      ),
    );
  }
}
