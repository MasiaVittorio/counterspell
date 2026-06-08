import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/alerts/card_alignment/card_alignment_alert.dart';
import 'package:counter_spell/widgets/alerts/image_search/components/card_tile.dart';
import 'package:counter_spell/widgets/components/project/artist_row.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CachedCardTile extends StatelessWidget {
  const CachedCardTile({
    super.key,
    required this.id,
    required this.card,
    required this.isFirst,
    required this.isLast,
  });

  final String id;
  final MtgCard card;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final frame = context.panelFrame;
    final theme = context.theme;

    void onAlign() {
      frame.showAlert(CardAlignmentAlert(id: id, card: card));
    }

    void onDelete() {
      frame.showAlert(
        ConfirmPanelAlert.delete(
          title: Text('Delete ${card.name} from cache?'),
          onConfirmed: () {
            counterSpell.cardsLogic.cachedCards.value.remove(id);
            counterSpell.cardsLogic.cachedCards.refresh();
          },
        ),
      );
    }

    void onOpen() => frame.showAlert(CardAlert(card));

    final layout = theme.layout;

    return GroupedCard(
      isFirst: isFirst,
      isLast: isLast,
      child: ListTile(
        title: Text(card.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: switch (card.imageUrl()) {
          final String url => CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(url),
          ),
          _ => null,
        },
        contentPadding: EdgeInsets.only(
          left: layout.margin.medium,
          right: layout.margin.medium - 8,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onAlign, icon: const Icon(Icons.crop)),
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_forever_outlined,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        onTap: onOpen,
        onLongPress: onAlign,
        subtitle: ArtistRow(card: card),
      ),
    );
  }
}
