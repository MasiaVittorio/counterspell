import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/alerts/cached_cards/cached_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class CachedCardsAlert extends StatelessWidget
    with PanelAlert, FullScreenPanelAlert {
  const CachedCardsAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final cardsLogic = counterSpell.cardsLogic;
    return cardsLogic.cachedCards.build((context, cachedCards) {
      final entries = cachedCards.entries.toList()
        ..sort((a, b) => -b.value.name.compareTo(a.value.name));
      return PanelList.builder(
        title: const Text('Cached cards'),
        bottom: CallToAction.danger.filled(
          label: const Text('Clear cached cards'),
          icon: const Icon(Icons.delete_forever_outlined),
          action: () => context.panelFrame.showAlert(
            ConfirmPanelAlert.delete(
              title: const Text('Clear ALL cached cards?'),
              onConfirmed: () {
                cardsLogic.cachedCards.value.clear();
                cardsLogic.cachedCards.refresh();
              },
            ),
          ),
        ),
        itemCount: entries.length,
        itemBuilder: (context, i) => CachedCardTile(
          id: entries[i].key,
          card: entries[i].value,
          isFirst: i == 0,
          isLast: i == entries.length - 1,
        ),
      );
    });
  }
}
