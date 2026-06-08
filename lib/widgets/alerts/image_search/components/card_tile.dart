import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/components/project/artist_row.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CardTile extends StatelessWidget {
  const CardTile(
    this.card, {
    super.key,
    this.callback,
    this.trailing,
    this.autoClose = true,
    this.longPressOpenCard = true,
    this.tapOpenCard = false,
    this.withoutImage = false,
    this.onTap,
  });

  final MtgCard card;
  final void Function(MtgCard)? callback;
  final Widget? trailing;
  final bool autoClose;
  final bool longPressOpenCard;
  final bool tapOpenCard;
  final bool withoutImage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final style = context.panelFrameStyle;

    void openCard() {
      final width = MediaQuery.of(context).size.width;
      final cardWidth = width - style.alertsMargin.horizontal;
      frame.showAlert(
        SafeArea(
          child: PreferredSize(
            preferredSize: Size(cardWidth, cardWidth / MtgCard.cardAspectRatio),
            child: CardAlert(card),
          ),
        ),
      );
    }

    return ListTile(
      title: Text(card.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: trailing,
      leading: switch ((withoutImage, card.imageUrl())) {
        (true, _) || (_, null) => null,
        (false, final String url) => CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(url),
        ),
      },
      onTap:
          onTap ??
          (tapOpenCard
              ? openCard
              : () {
                  callback?.call(card);
                  if (autoClose) frame.previousAlert();
                }),
      onLongPress: (longPressOpenCard) ? openCard : null,
      subtitle: ArtistRow(card: card),
    );
  }
}

class CardAlert extends StatefulWidget {
  final MtgCard card;

  const CardAlert(this.card, {super.key});

  @override
  State<CardAlert> createState() => _CardAlertState();
}

class _CardAlertState extends State<CardAlert> {
  bool firstFace = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: InkResponse(
          onTap: widget.card.cardFaces != null
              ? () {
                  setState(() {
                    firstFace = !firstFace;
                  });
                }
              : null,
          child: CachedNetworkImage(
            errorWidget: (_, _, _) => const BiggestAspectRatio(
              aspectRatio: MtgCard.cardAspectRatio,
              child: Center(child: Icon(Icons.error_outline)),
            ),
            imageUrl: widget.card.imageUrl(
              faceIndex: firstFace ? 0 : 1,
              uri: ImageUris.BORDERCROP,
            )!,
            placeholder: (_, _) => const BiggestAspectRatio(
              aspectRatio: MtgCard.cardAspectRatio,
              child: Center(child: CircularProgressIndicator()),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
