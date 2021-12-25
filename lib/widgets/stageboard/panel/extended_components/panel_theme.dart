import 'package:counter_spell_new/core.dart';
import 'theme_components/all.dart';


class PanelTheme extends StatelessWidget {
  const PanelTheme();

  static const Widget _overallTheme = const OverallTheme();
  static const Widget _themeColors = const ThemeColors();
  static const Widget _designPatterns = const DesignPatterns();
  static const Widget _presets = const ThemePResetter();

  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context)!;

    return SingleChildScrollView(
      physics: stage.panelController.panelScrollPhysics(),
      child: CSBloc.of(context)!.payments.unlocked.build((_,unlocked) => Column(
        children: <Widget>[
          _overallTheme,
          if(!unlocked) ListTile(
            title: const Text("Unlock theme engine"),
            subtitle: const Text("Support the developer"),
            leading: const Icon(McIcons.palette_outline),
            onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
          ),
          _designPatterns,
          _themeColors,
          if(unlocked) _presets,
        ],
      ),),
    );
  }
}


