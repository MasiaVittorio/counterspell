import 'package:counter_spell_new/core.dart';


class ArenaSettings extends StatelessWidget {
  const ArenaSettings();

  static const double height = 440;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);
    final settings = bloc.settings;

    return HeaderedAlert("Arena Settings",
      child: Column(children: <Widget>[

        Section(<Widget>[
          SectionTitle("Behavior"),
          settings.arenaScreenVerticalScroll.build((_, vertical)
            => SwitchListTile(
              value: vertical,
              onChanged: settings.arenaScreenVerticalScroll.set,
              title: const Text("Vertical Scroll"),
              secondary: const Icon(McIcons.gesture_swipe_down),
            ),
          ),
        ]),
        Section(<Widget>[
          SectionTitle("Appearance"),
          ListTile(
            title: Text("Image Opacity"),
            leading: Icon(Icons.invert_colors),
            onTap: () => stage.showAlert(
              ImageOpacity(true),
              size: ImageOpacity.height,
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          settings.arenaHideNameWhenImages.build((_, hide) => SwitchListTile(
            onChanged: settings.arenaHideNameWhenImages.set,
            value: hide,
            title: Text("Hide names with images"),
            secondary: Icon(McIcons.account_minus_outline),
          ),),
          settings.arenaFullScreen.build((_, fullScreen) => SwitchListTile(
            onChanged: settings.arenaFullScreen.set,
            value: fullScreen,
            title: Text("Full screen"),
            secondary: Icon(McIcons.fullscreen),
          ),),
        ]),
      ],),
    );
  }
}