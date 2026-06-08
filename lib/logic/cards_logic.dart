import 'package:counter_spell/models/scryfall/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

extension AlignmentX on Alignment {
  Map<String, double> toMap() => {'x': x, 'y': y};

  static Alignment fromMap(Map<String, dynamic> map) =>
      Alignment((map['x'] as num).toDouble(), (map['y'] as num).toDouble());
}

class CardsLogic extends LogicBase {
  final PersistentReactive<Map<String, Alignment>> cardsAlignments =
      PersistentReactive(
        {},
        key: 'cardsAlignments',
        toJsonEncodable: (value) => <String, dynamic>{
          for (final entry in value.entries) entry.key: entry.value.toMap(),
        },
        fromJsonDecoded: (jsonDecoded) => <String, Alignment>{
          for (final entry in (jsonDecoded as Map).entries)
            if (entry.value is Map) entry.key: AlignmentX.fromMap(entry.value),
        },
      );

  // card id to card data
  final PersistentReactive<Map<String, MtgCard>> cachedCards =
      PersistentReactive(
        {},
        key: 'cachedCards',
        toJsonEncodable: (value) => <String, dynamic>{
          for (final entry in value.entries) entry.key: entry.value.toMap(),
        },
        fromJsonDecoded: (jsonDecoded) => <String, MtgCard>{
          for (final entry in (jsonDecoded as Map).entries)
            if (entry.value is Map) entry.key: MtgCard.fromMap(entry.value),
        },
      );

  // player name to list of saved card ids
  final PersistentReactive<Map<String, Set<String>>>
  playerCards = PersistentReactive(
    {},
    key: 'playerCards',
    toJsonEncodable: (Map<String, Set<String>> value) => <String, List<String>>{
      for (final entry in value.entries) entry.key: entry.value.toList(),
    },
    fromJsonDecoded: (jsonDecoded) => <String, Set<String>>{
      for (final entry in (jsonDecoded as Map).entries)
        if (entry.key case String key)
          if (entry.value case List list)
            key: <String>{
              for (final e in list)
                if (e is String) e,
            },
    },
  );

  @override
  void dispose() {
    cachedCards.dispose();
    playerCards.dispose();
    super.dispose();
  }

  Widget buildWithcard({
    required String cardId,
    required Widget Function(BuildContext context, MtgCard? card) builder,
  }) => cachedCards.build((context, cache) => builder(context, cache[cardId]));
}
