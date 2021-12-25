import 'package:counter_spell_new/core.dart';

class ArenaMenuSettings extends StatelessWidget {

  const ArenaMenuSettings({
    required this.players,
  });

  final int players;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Section(<Widget>[
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


// class ArenaLayoutSelector extends StatelessWidget {

//   ArenaLayoutSelector(this.squadLayout);
//   final bool squadLayout;

//   @override
//   Widget build(BuildContext context) {
//     final bloc = CSBloc.of(context);
//     final settings = bloc.settings;
//     return RadioSliderOf<ArenaLayoutType>(
//       selectedItem: squadLayout ? ArenaLayoutType.squad : ArenaLayoutType.ffa,
//       onSelect: settings.arenaSettings.layoutType.set,
//       items: {
//         ArenaLayoutType.ffa: RadioSliderItem(
//           icon: Icon(McIcons.account_outline),
//           title: Text("Free for all"),
//         ),
//         ArenaLayoutType.squad: RadioSliderItem(
//           icon: Icon(McIcons.account_multiple_outline),
//           title: Text("Squad"),
//         ),
//       },
//     );
//   }
// }

class ArenaOpacity extends StatelessWidget {
  const ArenaOpacity();
  @override
  Widget build(BuildContext context) {
    final opacity = CSBloc.of(context)!.settings!.imagesSettings.arenaImageOpacity;
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