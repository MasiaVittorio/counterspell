import 'dart:convert';

import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/models/scryfall/scryfall_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef AdvancedCardBuilder =
    Widget Function(
      BuildContext context,
      MtgCard? card,
      bool isLoading,
      String? error,
      Widget? child,
    );

typedef CardValueBuilder =
    Widget Function(BuildContext context, MtgCard? card, Widget? child);

class CardBuilder extends StatelessWidget {
  const CardBuilder.advanced({
    super.key,
    required this.id,
    required AdvancedCardBuilder this.advancedBuilder,
    this.child,
  }) : builder = null;
  const CardBuilder({
    super.key,
    required this.id,
    required CardValueBuilder this.builder,
    this.child,
  }) : advancedBuilder = null;

  final String? id;
  final AdvancedCardBuilder? advancedBuilder;
  final CardValueBuilder? builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    var cardsLogic = context.counterSpell.cardsLogic;
    return switch (id) {
      null || '' =>
        advancedBuilder?.call(context, null, false, null, child) ??
            builder?.call(context, null, child) ??
            const SizedBox.shrink(),
      final String id => cardsLogic.cachedCards.build(
        (context, cache) => switch (cache[id]) {
          final MtgCard card =>
            advancedBuilder?.call(context, card, false, null, child) ??
                builder?.call(context, card, child) ??
                const SizedBox.shrink(),
          null => _CardBuilder(
            id: id,
            builder: builder,
            advancedBuilder: advancedBuilder,
            child: child,
            onCache: (card) {
              cardsLogic.cachedCards.value[id] = card;
              cardsLogic.cachedCards.refresh();
            },
          ),
        },
      ),
    };
  }
}

class _CardBuilder extends StatefulWidget {
  const _CardBuilder({
    required this.id,
    required this.builder,
    required this.advancedBuilder,
    required this.child,
    required this.onCache,
  });

  final String id;
  final AdvancedCardBuilder? advancedBuilder;
  final CardValueBuilder? builder;
  final Widget? child;
  final void Function(MtgCard card) onCache;

  @override
  State<_CardBuilder> createState() => _CardBuilderState();
}

class _CardBuilderState extends State<_CardBuilder> {
  bool isLoading = true;
  String? error;
  MtgCard? card;

  @override
  void initState() {
    super.initState();
    getCard();
  }

  @override
  void didUpdateWidget(covariant _CardBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      isLoading = true;
      error = null;
      card = null;
      getCard();
    }
  }

  int _id = 0;
  Future<void> getCard() async {
    _id++;
    final int id = _id + 0;
    try {
      final response = await http.get(
        Uri.parse('https://api.scryfall.com/cards/${widget.id.percentEncode}'),
        headers: {
          'User-Agent': 'Limited/1.0',
          'Accept': 'application/json;q=0.9,*/*;q=0.8',
        },
      );
      if (id != _id) return;
      if (!mounted) return;
      setState(() {
        card = _processResponse(response);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'error: $e';
        isLoading = false;
        card = null;
      });
    }
  }

  MtgCard? _processResponse(http.Response response) {
    dynamic map;

    switch (response.statusCode) {
      case 200:
        map = jsonDecode(response.body);
        break;
      case 404:
        error = 'Card not found';
        return null;
      default:
    }

    if (map == null) {
      error = 'Error: ${response.statusCode}';
      return null;
    }

    if (map is! Map<String, dynamic>) {
      error = 'Unexpected response format';
      return null;
    }

    if (map['object'] == 'error') {
      if (map['code'] == 'not_found') {
        error = 'Card not found';
        return null;
      } else {
        error = 'Error: ${map["code"]}';
        return null;
      }
    }

    if (map['object'] != 'card') {
      error = 'Unexpected response';
      return null;
    }

    try {
      final card = MtgCard.fromMap(map);
      error = null;
      widget.onCache(card);
      return card;
    } catch (e) {
      debugPrint('//// error parsing card: $e, card: $map');
      error = 'Error parsing card data';
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.advancedBuilder?.call(
          context,
          card,
          isLoading,
          error,
          widget.child,
        ) ??
        widget.builder?.call(context, card, widget.child) ??
        const SizedBox.shrink();
  }
}
