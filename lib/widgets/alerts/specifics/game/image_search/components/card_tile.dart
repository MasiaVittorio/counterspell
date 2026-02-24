import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/core.dart';

class CardTile extends StatelessWidget {
  final MtgCard card;
  final void Function(MtgCard)? callback;
  final Widget? trailing;
  final bool autoClose;
  final bool longPressOpenCard;
  final bool tapOpenCard;
  final bool withoutImage;

  const CardTile(
    this.card, {
    super.key,
    this.callback,
    this.trailing,
    this.autoClose = true,
    this.longPressOpenCard = true,
    this.tapOpenCard = false,
    this.withoutImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    void openCard() {
      final dimensions = stage!.dimensionsController.dimensions.value;
      final width = MediaQuery.of(context).size.width;
      final cardWidth = width - dimensions.panelHorizontalPaddingOpened * 2;
      stage.showAlert(
        CardAlert(card),
        size: cardWidth / MtgCard.cardAspectRatio,
      );
    }

    return ListTile(
      title: Text(
        card.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing,
      leading: (withoutImage)
          ? null
          : CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                card.imageUrl()!,
              ),
            ),
      onTap: (tapOpenCard)
          ? openCard
          : () {
              callback?.call(card);
              if (autoClose) stage!.closePanel();
            },
      onLongPress: (longPressOpenCard) ? openCard : null,
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(CSIcons.artist, size: 15.0),
          Expanded(
            child: Text(
              card.artist!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
