import 'package:counter_spell_new/core.dart';


class ArenaSettings extends StatelessWidget {
  const ArenaSettings();

  static const double height = 440;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert("Arena Settings",
      child: Column(children: const <Widget>[
        Section(<Widget>[
          SectionTitle("Gestures"),
          ArenaScrollOverTap(),
          ArenaScrollDirectionSelector(),
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

class ArenaScrollOverTap extends StatelessWidget {
  
  const ArenaScrollOverTap();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings.arenaSettings;

    return settings.scrollOverTap.build((context, scrollOverTap) 
      => RadioSliderOf<bool>(
        selectedItem: scrollOverTap, 
        items: const <bool,RadioSliderItem>{
          true: RadioSliderItem(title: Text("Scroll"), icon: Icon(Icons.gesture)),
          false: RadioSliderItem(title: Text("Tap"), icon: Icon(McIcons.gesture_tap)),
        }, 
        onSelect: settings.scrollOverTap.set,
      ),
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

class ArenaScrollDirectionSelector extends StatelessWidget {
  const ArenaScrollDirectionSelector();
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings.arenaSettings;

    final content = settings.verticalScroll.build((_, vertical)
      => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadioSliderOf<bool>(
            selectedItem: vertical,
            onSelect: settings.verticalScroll.set,
            title: const Text("Axis"),
            items: const <bool,RadioSliderItem>{
              true: RadioSliderItem(title: Text("Vertical"), icon: Icon(McIcons.gesture_swipe_vertical)),
              false: RadioSliderItem(title: Text("Horizontal"), icon: Icon(McIcons.gesture_swipe_horizontal)),
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: AnimatedText(
              vertical ? "(down to up to increase)" : "(left to right to increase)",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );

    return settings.scrollOverTap.build((context, scroll) => AnimatedListed(
      listed: scroll,
      child: content,
    ));

  }
}