import 'package:counter_spell/data/icon/all.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ArtistRow extends StatelessWidget {
  const ArtistRow({super.key, required this.card});

  final MtgCard card;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(ManaIcons.artist_nib, size: 15.0),
        const Space.horizontal(6),
        Expanded(
          child: Text(
            card.artist ?? '-',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
