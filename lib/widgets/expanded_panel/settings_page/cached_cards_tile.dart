import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/alerts/cached_cards/cached_cards_alert.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CachedCardsTile extends StatelessWidget {
  const CachedCardsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final cardsLogic = counterSpell.cardsLogic;
    final frame = context.panelFrame;

    return cardsLogic.cachedCards.build((context, cachedCards) {
      return ColoredTile(
        title: const Text('Cached cards'),
        leading: Icon(MdiIcons.cardsOutline),
        subtitle: Text(
          cachedCards.isEmpty
              ? 'No cached cards found yet.'
              : 'View cache and edit card alignments.',
        ),
        containTrailing: false,
        lowLeading: cachedCards.isEmpty,
        onTap: cachedCards.isEmpty
            ? null
            : () {
                frame.showAlert(const CachedCardsAlert());
              },
        trailing: cachedCards.isNotEmpty
            ? const Icon(Icons.keyboard_arrow_right_outlined)
            : null,
      );
    });
  }
}
