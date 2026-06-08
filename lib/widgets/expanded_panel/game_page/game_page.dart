// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/data/icon/all.dart';
import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/alerts/commanders_edit/edit_commanders_alert.dart';
import 'package:counter_spell/widgets/alerts/game_edit_alert/history_tile.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/leaderboards_alert.dart';
import 'package:counter_spell/widgets/alerts/mana_pool/mana_pool_alert.dart';
import 'package:counter_spell/widgets/alerts/playgroup_edit_alert/playgroup_edit_alert.dart';
import 'package:counter_spell/widgets/alerts/random_alert/random_alert.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/restart_button.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:counter_spell/widgets/expanded_panel/game_page/expanded_page_list.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final gameRecords = context.counterSpell.leaderboardsLogic.gameRecords;

    return gameRecords.build(
      (context, records) => ExpandedPageList(
        bottom: const NewGameCta(),
        children: [
          const SectionTitle(
            title: Text('Game options'),
            leading: Icon(CounterSpellIcons.counterspell),
          ),
          ...[
            const EditPlaygroupTile(),
            const EditComandersTile(),
            const HistoryTile(),
          ].groupedCards(lastPadding: 0),
          SectionTitle(
            title: const Text('Tools'),
            leading: Icon(MdiIcons.toolboxOutline),
          ),
          ...[
            const RandomTile(),
            if (records.isNotEmpty) const LeaderboardsTile(),
            const ManaPoolTile(),
          ].groupedCards(lastPadding: layout.spacing.smaller),
        ],
      ),
    );
  }
}

class ManaPoolTile extends StatelessWidget {
  const ManaPoolTile({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    return ColoredTile(
      title: const Text('Mana pool'),
      subtitle: const Text('Navigate complex scenarios'),
      leading: const Icon(ManaIcons.c),
      onTap: () => frame.showAlert(const ManaPoolAlert()),
    );
  }
}

class LeaderboardsTile extends StatelessWidget {
  const LeaderboardsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    return ColoredTile(
      title: const Text('Leaderboards'),
      subtitle: const Text('Past games stats and win rates'),
      leading: Icon(MdiIcons.license),
      onTap: () => frame.showAlert(const LeaderboardsAlert()),
    );
  }
}

class NewGameCta extends StatelessWidget {
  const NewGameCta({super.key, this.replaceAlert = false});

  final bool replaceAlert;

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final counterSpell = context.counterSpell;

    return CallToAction(
      action: () {
        if (replaceAlert) frame.previousAlert();
        frame.promptRestart(context: context, counterSpell: counterSpell);
      },
      label: const Text('New game'),
      icon: const Icon(Icons.restart_alt),
    );
  }
}

class EditPlaygroupTile extends StatelessWidget {
  const EditPlaygroupTile({super.key, this.beforeAction});
  final VoidCallback? beforeAction;

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;

    return ColoredTile(
      title: const Text('Edit playgroup'),
      subtitle: const Text('Add, rename or remove players'),
      onTap: () {
        beforeAction?.call();
        frame.showAlert(const PlaygroupEditAlert());
      },
      leading: Icon(MdiIcons.accountMultipleOutline),
    );
  }
}

class EditComandersTile extends StatelessWidget {
  const EditComandersTile({super.key, this.beforeAction});
  final VoidCallback? beforeAction;

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;

    return ColoredTile(
      title: const Text('Edit commanders'),
      subtitle: const Text("Find any card's art, enable partners"),
      onTap: () {
        beforeAction?.call();
        frame.showAlert(const EditCommandersAlert());
      },
      leading: const Icon(CounterSpellIcons.cast_outlined),
    );
  }
}

class RandomTile extends StatelessWidget {
  const RandomTile({super.key, this.beforeAction});

  final VoidCallback? beforeAction;

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;

    return ColoredTile(
      title: const Text('Random'),
      subtitle: const Text('Throw dice, flip coins, pick random players'),
      leading: Icon(MdiIcons.diceMultipleOutline),
      onTap: () {
        beforeAction?.call();
        frame.showAlert(const RandomAlert());
      },
    );
  }
}
