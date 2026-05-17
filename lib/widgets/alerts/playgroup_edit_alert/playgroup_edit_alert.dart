import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/widgets/alerts/playgroup_edit_alert/player_renaming_tile.dart';
import 'package:counter_spell/widgets/components/builders/can_use_arena_view_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class PlaygroupEditAlert extends StatelessWidget {
  const PlaygroupEditAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final gameLogic = counterSpell.gameLogic;
    final playgroupLogic = counterSpell.playgroupLogic;
    final theme = context.theme;
    final layout = theme.layout;
    final frame = context.panelFrame;
    final bottomSafe = context.safe.bottom;

    final spacing = layout.spacing.tiny;

    return (gameLogic.gameReactive, playgroupLogic.listSeatOrder).build((
      context,
      game,
      indexes,
    ) {
      void onRename(int index, String newName) => gameLogic.editGame(
        (game) => game.renamePlayer(playerIndex: index, newName: newName),
      );
      void onDelete(int index) =>
          gameLogic.editGame((game) => game.removePlayer(index));
      final onReorder = playgroupLogic.reorderListSeatOrder;
      final names = game.settings.playerSettings.map((e) => e.name).toList();
      final count = names.length;

      void onNewName(String value) {
        final newName = value.trim();
        for (final name in names) {
          if (name.toLowerCase() == newName.toLowerCase()) return;
        }
        gameLogic.editGame(
          (game) => game.addPlayer(PlayerSettings(name: newName)),
        );
      }

      void onAddPlayer() {
        frame.showAlert(
          InsertPanelAlert(label: "New player's name", onSubmit: onNewName),
        );
      }

      void showRenameAlert(int playerIndex, String name) {
        frame.showAlert<String>(
          InsertPanelAlert(
            label: 'Rename $name',
            initialValue: name,
            onSubmit: (value) => onRename(playerIndex, value),
          ),
        );
      }

      const header = PanelHeader(title: Text('Edit playgroup'));
      final bool canGoBack = context.canGoBackInPanelAlert;

      final footer = PanelListBottomElement(
        overrideTopMargin: layout.margin.medium - spacing / 2,
        child: CallToAction(
          action: onAddPlayer,
          label: const Text('Add player'),
          icon: const Icon(Icons.add),
        ),
      );

      return SizedBox(
        height:
            56 +
            layout.margin.medium * 2 +
            PlayerRenamingTile.height * count +
            spacing * (count > 0 ? count - 1 : 0) +
            54 +
            (canGoBack ? layout.padding.smaller * 2 : 0) +
            (bottomSafe == 0 ? layout.margin.medium : bottomSafe),
        child: Stack(
          children: [
            UsesArenaViewBuilder(
              builder: (context, arenaView, _) {
                return ReorderableListView.builder(
                  onReorder: onReorder,
                  buildDefaultDragHandles: false,
                  clipBehavior: Clip.hardEdge,
                  dragStartBehavior: DragStartBehavior.start,
                  itemExtent: PlayerRenamingTile.height + spacing,
                  itemCount: names.length,
                  header: const Opacity(
                    opacity: 0,
                    child: IgnorePointer(ignoring: true, child: header),
                  ),
                  physics: CallbackScrollPhysics(
                    topBounceCallback: () => frame.closePanel(),
                    topBounce: true,
                    alwaysScrollable: false,
                  ),
                  footer: Opacity(
                    opacity: 0,
                    child: IgnorePointer(ignoring: true, child: footer),
                  ),
                  itemBuilder: (context, uiIndex) {
                    final int playerIndex = indexes[uiIndex];
                    final String name = names[playerIndex];
                    return PlayerRenamingTile(
                      canReorder: !arenaView,
                      canDelete: indexes.length > 2,
                      key: ValueKey('player_renaming_tile_$playerIndex'),
                      spacing: spacing,
                      frame: frame,
                      name: name,
                      index: uiIndex,
                      length: names.length,
                      onDelete: () => onDelete(playerIndex),
                      onRename: () => showRenameAlert(playerIndex, name),
                    );
                  },
                );
              },
            ),
            const Positioned(top: 0, right: 0, left: 0, child: header),
            Positioned(bottom: 0, right: 0, left: 0, child: footer),
          ],
        ),
      );
    });
  }
}
