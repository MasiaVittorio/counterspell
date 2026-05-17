import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/logic/playgroup_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/components/common/my_chip.dart';
import 'package:counter_spell/widgets/expanded_panel/game_page/starting_life_slider.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class NewGameAlert extends StatelessWidget {
  const NewGameAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final gameLogic = counterSpell.gameLogic;
    final playgroupLogic = counterSpell.playgroupLogic;
    final panelFrame = context.panelFrame;

    return playgroupLogic.pastNameRecords.build(
      (context, records) => _NewGameAlert(
        sortedNames: records.sortedNames,
        onStart: (names) {
          gameLogic.newGame(names: names, playgroupLogic: playgroupLogic);
          panelFrame.closePanel();
          counterSpell.pagesLogic.bodyPage.update(BodyPage.life);
        },
        currentPlaygroup: gameLogic.gameReactive.value.settings.playerSettings
            .map((s) => s.name)
            .toList(),
        onDeletePastName: (name) {
          playgroupLogic.pastNameRecords.value.remove(name);
          playgroupLogic.pastNameRecords.refresh();
        },
      ),
    );
  }
}

class _NewGameAlert extends StatefulWidget {
  const _NewGameAlert({
    required this.currentPlaygroup,
    required this.sortedNames,
    required this.onStart,
    required this.onDeletePastName,
  });

  final List<String> currentPlaygroup;
  final List<String> sortedNames;
  final ValueChanged<List<String>> onStart;
  final ValueChanged<String> onDeletePastName;

  @override
  State<_NewGameAlert> createState() => __NewGameAlertState();
}

class __NewGameAlertState extends State<_NewGameAlert> {
  late List<String> players;

  @override
  void initState() {
    super.initState();
    players = [...widget.currentPlaygroup];
  }

  void remove(String player) {
    setState(() {
      players.remove(player);
    });
  }

  void add(String player) {
    if (players.contains(player)) return;
    setState(() {
      players.add(player);
    });
  }

  void rename(String oldName, String newName) {
    if (players.contains(newName)) return;
    setState(() {
      final int index = players.indexOf(oldName);
      players[index] = newName;
    });
  }

  void clear() {
    setState(() {
      players.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    final autoNames = [for (final letter in letters) 'Player $letter'];

    final pastNames = [...widget.sortedNames];
    pastNames.removeWhere((name) => autoNames.contains(name));
    pastNames.removeWhere((name) => players.contains(name));

    final theme = context.theme;
    final layout = theme.layout;

    void newAutoName() {
      for (final autoName in autoNames) {
        if (!players.contains(autoName)) {
          add(autoName);
          return;
        }
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PanelHeader(title: Text('New game')),
        const StartingLifeSlider(),
        SectionTitle(
          title: const Text('New playgroup'),
          leading: Icon(MdiIcons.accountMultipleOutline),
          trailing: FilledButton.tonalIcon(
            onPressed: players.isEmpty ? null : clear,
            label: const Text('Clear'),
            icon: const Icon(Icons.clear_all),
          ),
        ),
        Pad(
          horizontal: layout.margin.medium,
          child: Material(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(layout.radius.medium),
            child: Pad(
              all: layout.padding.medium,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: layout.spacing.medium,
                    runSpacing: layout.spacing.medium,
                    children: [
                      for (final player in players)
                        MyChip(
                          label: player,
                          onDelete: () => remove(player),
                          selected: true,
                          onPressed: () => frame.showAlert(
                            InsertPanelAlert(
                              label: 'Rename $player',
                              onSubmit: (value) => rename(player, value),
                            ),
                          ),
                          overrideDeleteIcon: Icons.close,
                        ),
                    ],
                  ),
                  Space.vertical(layout.spacing.medium),
                  Al.centerRight(
                    child: MyChip(
                      label: 'Add',
                      icon: Icons.add,
                      selected: players.length < 2,
                      rounded: true,
                      onPressed: newAutoName,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SectionTitle(
          title: const Text('Past players'),
          leading: const Icon(Icons.history),
          trailing: Text('(${pastNames.length})'),
        ),
        SizedBox(
          height: MyChip.height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: layout.margin.medium),
            physics: context.provide<ScrollPhysics>(),
            separatorBuilder: (_, _) => Space.horizontal(layout.spacing.medium),
            itemCount: pastNames.isEmpty ? 1 : pastNames.length,
            itemBuilder: (context, index) {
              if (pastNames.isEmpty) {
                return MyChip(
                  label: widget.sortedNames.isEmpty ? 'Empty' : 'None left',
                  onPressed: null,
                  selected: false,
                );
              } else {
                final name = pastNames[index];
                return MyChip(
                  label: name,
                  icon: Icons.add,
                  selected: null,
                  onPressed: () => add(name),
                  onDelete: () => widget.onDeletePastName(name),
                );
              }
            },
          ),
        ),
        Space.vertical(layout.spacing.medium + layout.padding.medium),
        CallToAction(
          action: players.length < 2 ? null : () => widget.onStart(players),
          label: Text('New ${players.length} players game'),
          icon: const Icon(Icons.restart_alt),
        ),
        Space.vertical(layout.margin.medium + context.safe.bottom),
      ],
    );
  }
}
