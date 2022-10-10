import 'package:counter_spell_new/core.dart';
import 'theme_components/all.dart';


class PanelTheme extends StatelessWidget {
  const PanelTheme();

  @override
  Widget build(BuildContext context) {

    final stage = Stage.of(context)!;

    return CSBloc.of(context).payments.unlocked.build((_,unlocked) 
      => ModalBottomList(
        physics: stage.panelController.panelScrollPhysics(),
        bottom: unlocked ? const ThemePResetter() : Container(),
        bottomHeight: 100,
        children: <Widget>[
          const OverallTheme(),
          if(!unlocked) ListTile(
            title: const Text("Unlock theme engine"),
            subtitle: const Text("Support the developer"),
            leading: const Icon(McIcons.palette_outline),
            onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
          ),
          if(CSStage.allowPickDesign) ...[
            const Divider(height: 1,),
            const Space.vertical(8),
            const DesignPattern(),
            const Space.vertical(8),
            const Divider(height: 1,),
            const Space.vertical(10),
          ],
          const ThemeColors(),
          const Space.vertical(10),
        ],
      ),
    );
  }
}


