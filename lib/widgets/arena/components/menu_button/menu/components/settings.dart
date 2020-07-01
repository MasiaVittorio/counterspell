import 'package:counter_spell_new/core.dart';

class ArenaMenuSettings extends StatelessWidget {

  const ArenaMenuSettings({
    @required this.players,
    @required this.squadLayout,
  });

  final int players;
  final bool squadLayout;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if(players > 2) // for two players there is only one layout
          Section(<Widget>[
            const PanelTitle("Layout"),
            ArenaLayoutSelector(squadLayout),
          ],),

        Section(<Widget>[
          if(players > 2)
            const SectionTitle("Gestures")
          else 
            const PanelTitle("Gestures"),
          const Gestures(),
        ],),

        const Section(<Widget>[
          SectionTitle("Appearance"),
          ArenaFullScreenToggle(true),
          ArenaHideNamesWithImageToggle(),
          ArenaOpacity(),
        ],),

      ],
    );
  }
}


class ArenaLayoutSelector extends StatelessWidget {

  ArenaLayoutSelector(this.squadLayout);
  final bool squadLayout;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings;
    return RadioSlider(
      selectedIndex: squadLayout ? 0 : 1,
      onTap: (i) => settings.arenaSettings.squadLayout.set(i==0),
      items: [
        RadioSliderItem(
          icon: Icon(McIcons.account_multiple_outline),
          title: Text("Squad"),
        ),
        RadioSliderItem(
          icon: Icon(McIcons.account_outline),
          title: Text("Free for all"),
        ),
      ],
    );
  }
}

class ArenaOpacity extends StatelessWidget {
  const ArenaOpacity();
  @override
  Widget build(BuildContext context) {
    final opacity = CSBloc.of(context).settings.imagesSettings.arenaImageOpacity;
    return opacity.build((_,value) => FullSlider(
      value: value,
      divisions: 20,
      leading: Icon(Icons.opacity),
      onChanged: opacity.set,
      defaultValue: CSSettingsImages.defaultSimpleImageOpacity,
      titleBuilder: (val) => Text("Opacity: ${val.toStringAsFixed(2)}"),
    ));
  }
}