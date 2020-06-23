import 'package:counter_spell_new/core.dart';


class ArenaSettings extends StatelessWidget {
  const ArenaSettings();

  static const double height = 440;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert("Arena Settings",
      child: Column(children: const <Widget>[
        Section(<Widget>[
          SectionTitle("Behavior"),
          ArenaVerticalScrollToggle(),
        ]),
        Section(<Widget>[
          SectionTitle("Appearance"),
          ArenaOpacityTile(),
          ArenaHideNamesWithImageToggle(),
          ArenaFullScreenToggle(),
        ]),
      ],),
    );
  }
}

class ArenaOpacityTile extends StatelessWidget {
  const ArenaOpacityTile();
  @override
  Widget build(BuildContext context) {
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);
    return ListTile(
      title: const Text("Image Opacity"),
      leading: const Icon(Icons.invert_colors),
      onTap: () => stage.showAlert(
        ImageOpacity(true),
        size: ImageOpacity.height,
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
    );
  }
}

class ArenaFullScreenToggle extends StatelessWidget {
  const ArenaFullScreenToggle([this.disclaimer = false]);

  final bool disclaimer; 

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings.arenaSettings;
    return settings.fullScreen.build((_, fullScreen) => SwitchListTile(
      onChanged: settings.fullScreen.set,
      value: fullScreen,
      title: const Text("Full screen"),
      subtitle: (disclaimer ?? false) ? const Text("Exit and re-enter to apply") : null,
      secondary: const Icon(McIcons.fullscreen),
    ),);
  }
}

class ArenaHideNamesWithImageToggle extends StatelessWidget {
  const ArenaHideNamesWithImageToggle();
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings.arenaSettings;
    return settings.hideNameWhenImages.build((_, hide) => SwitchListTile(
      onChanged: settings.hideNameWhenImages.set,
      value: hide,
      title: const Text("Hide names with images"),
      secondary: const Icon(McIcons.account_minus_outline),
    ),);
  }
}

class ArenaVerticalScrollToggle extends StatelessWidget {
  const ArenaVerticalScrollToggle();
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings.arenaSettings;
    return settings.verticalScroll.build((_, vertical)
      => SwitchListTile(
        value: vertical,
        onChanged: settings.verticalScroll.set,
        title: const Text("Vertical Scroll"),
        secondary: const Icon(McIcons.gesture_swipe_down),
      ),
    );
  }
}