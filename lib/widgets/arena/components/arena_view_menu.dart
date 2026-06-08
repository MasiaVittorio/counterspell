import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/interaction/arena_layout_mode.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/arena/components/arena_direction_slider.dart';
import 'package:counter_spell/widgets/arena/layouts_picker/arena_layouts_view.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:counter_spell/widgets/expanded_panel/game_page/game_page.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ArenaViewMenu extends StatelessWidget {
  const ArenaViewMenu({super.key, required this.mode, required this.open});

  final ArenaLayoutMode mode;
  final Reactive<bool> open;

  @override
  Widget build(BuildContext context) {
    final panelFrame = context.panelFrame;
    final theme = context.theme;
    final layout = theme.layout;
    final counterSpell = context.counterSpell;

    void changeLayout() => panelFrame.showAlert(
      ArenaLayoutsView(
        filterForPlayerCount: counterSpell
            .gameLogic
            .gameReactive
            .value
            .currentState
            .playerStates
            .length,
        initialMode: mode,
      ),
    );

    void close() => open.update(false);

    return PanelList.expand(
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CallToAction.secondary.outlined(
            action: () => open.update(false),
            label: const Text('Resume game'),
            icon: Icon(MdiIcons.arrowULeftTop),
          ),
          Space.vertical(layout.spacing.medium),
          const NewGameCta(),
        ],
      ),
      title: const Text('Arena view'),
      children: [
        ...[
          ColoredTile(
            title: const Text('History page'),
            subtitle: const Text('Check recent actions to sort things out'),
            onTap: () {
              panelFrame.closePanel();
              counterSpell.pagesLogic.bodyPage.update(BodyPage.history);
            },
            leading: Icon(BodyPage.history.outlinedIcon),
          ),
          EditPlaygroupTile(beforeAction: close),
          EditComandersTile(beforeAction: close),
          RandomTile(beforeAction: close),
        ].groupedCards(),
        const SectionTitle(
          title: Text('Increase / decrease tap orientation'),
          leading: Icon(Icons.settings_outlined),
        ),
        const ArenaDirectionSlider(),
        Space.vertical(layout.spacing.medium),
        ...[
          ColoredTile(
            title: const Text('Edit layout'),
            subtitle: const Text('Change seat positions and swap players'),
            onTap: () {
              close();
              changeLayout();
            },
            leading: const Icon(Icons.view_quilt_outlined),
          ),
        ].groupedCards(),
      ],
    );
  }
}
