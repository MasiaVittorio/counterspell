// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/alerts/commanders_edit/edit_commanders_alert.dart';
import 'package:counter_spell/widgets/alerts/image_search/components/card_tile.dart';
import 'package:counter_spell/widgets/alerts/leaderboards_view/games/past_game_tile.dart';
import 'package:counter_spell/widgets/alerts/winner_picker/winner_picker.dart';
import 'package:counter_spell/widgets/components/builders/card_builder.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class PastGameAlert extends StatelessWidget
    with PanelAlert, FullScreenPanelAlert {
  const PastGameAlert({super.key, required this.gameIndex});

  final int gameIndex;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final frame = context.panelFrame;
    final theme = context.theme;
    final layout = theme.layout;
    final gameRecords = counterSpell.leaderboardsLogic.gameRecords;

    return gameRecords.build((context, value) {
      final game = value[gameIndex];

      final bool sameYear = DateTime.now().year == game.startTime.year;

      void onDelete() {
        frame.previousAlert();
        gameRecords.value.removeAt(gameIndex);
        gameRecords.refresh();
      }

      void promptDelete() async {
        final result = await frame.showAlert(
          const ConfirmPanelAlert.delete(
            title: Text('Delete this game record?'),
            content: Text('This action cannot be undone.'),
          ),
        );
        if (result == true) onDelete();
      }

      void changeWinner() => frame.showAlert(
        WinnerPicker(
          initialIndex: game.winner,
          names: [for (final p in game.settings.playerSettings) p.name],
          includeDontSaveOption: false,
          onSubmit: (winnerIndex) {
            switch (winnerIndex) {
              case -1: // draw
                gameRecords.value[gameIndex] = game.copyWithoutWinner();
                gameRecords.refresh();
                return;
              case int winnerIndex:
                if (winnerIndex >= 0 &&
                    winnerIndex < game.settings.playerSettings.length) {
                  gameRecords.value[gameIndex] = game.copyWith(
                    winner: winnerIndex,
                  );
                  gameRecords.refresh();
                }
              default:
            }
          },
        ),
      );

      void onEditCommanders() {
        frame.showAlert(PastGameEditCommandersAlert(gameIndex: gameIndex));
      }

      return PanelList.expand(
        title: Text(
          game.startTime.format("${sameYear ? '' : 'yyyy '}MMMM dd - HH:mm"),
        ),
        bottom: CallToAction.filled.danger(
          action: promptDelete,
          label: const Text('Delete this game record'),
          icon: const Icon(Icons.delete_forever_outlined),
        ),
        children: [
          GroupedCard(
            isFirst: true,
            isLast: true,
            child: ListTile(
              title: Text(
                'Duration: ${game.duration.formattedString(context, tersity: DurationTersity.minute)}',
              ),
              leading: const Icon(Icons.timer_outlined),
              subtitle: Text('Ended at ${game.endTime.format("HH:mm")}'),
            ),
          ),
          SectionTitle(
            leading: const Icon(Icons.people_outline),
            title: const Text('Players'),
            trailing: FilledButton.tonalIcon(
              onPressed: changeWinner,
              label: const Text('Edit winner'),
              icon: const Icon(Icons.emoji_events),
            ),
          ),
          Pad(
            horizontal: layout.margin.medium,
            top: layout.spacing.small,
            bottom: layout.spacing.medium + layout.margin.medium,
            child: GamePlayersWrap(game: game),
          ),
          SectionTitle(
            leading: const Icon(CounterSpellIcons.cast_outlined),
            title: const Text('Commanders'),
            trailing: FilledButton.tonalIcon(
              onPressed: onEditCommanders,
              label: const Text('Edit commanders'),
              icon: const Icon(Icons.edit_outlined),
            ),
          ),
          for (final player in game.settings.playerSettings) ...[
            SectionTitle(title: Text(player.name), topMargin: 0),
            for (final c in [
              (id: player.commanders.partnerA, a: true),
              if (player.runsTwoPartners)
                (id: player.commanders.partnerB, a: false),
            ])
              GroupedCard(
                isFirst: c.a,
                isLast: !c.a || !player.runsTwoPartners,
                lastPadding: 0,
                child: CardBuilder(
                  id: c.id,
                  builder: (context, card, child) {
                    if (card == null) {
                      return ListTile(
                        leading: Icon(MdiIcons.cardsOutline),
                        title: const Text('Commander'),
                        subtitle: const Text('Not set'),
                      );
                    }
                    return CardTile(card);
                  },
                ),
              ),
          ],
        ],
      );
    });
  }
}

class PastGameEditCommandersAlert extends StatelessWidget {
  const PastGameEditCommandersAlert({super.key, required this.gameIndex});

  final int gameIndex;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final gameRecords = counterSpell.leaderboardsLogic.gameRecords;

    return gameRecords.build((context, value) {
      final game = value[gameIndex];
      final gameSettings = game.settings;
      return RawEditCommandersAlert(
        gameSettings: game.settings,
        seatOrder: List.generate(
          gameSettings.playerSettings.length,
          (index) => index,
        ),
        onChanged: (newSettings) {
          gameRecords.value[gameIndex] = game.copyWith(settings: newSettings);
          gameRecords.refresh();
        },
      );
    });
  }
}
