import 'dart:math';

import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/models/scryfall/scryfall_api.dart';
import 'package:counter_spell/widgets/alerts/image_search/components/card_tile.dart';
import 'package:counter_spell/widgets/alerts/image_search/components/image_search_commander_filter_toggle.dart';
import 'package:counter_spell/widgets/alerts/image_search/components/image_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ImageSearchAlert extends StatelessWidget
    with PanelAlert, FullScreenPanelAlert {
  const ImageSearchAlert({
    super.key,
    required this.playerName,
    required this.onSelect,
  });

  final String playerName;
  final ValueChanged<MtgCard> onSelect;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final cachedCards = counterSpell.cardsLogic.cachedCards;
    final playerCards = counterSpell.cardsLogic.playerCards;

    return _ImageSearchAlert(
      onSelect: onSelect,
      cache: switch (playerName) {
        '' => null,
        String name => (
          cachedCards: <String, MtgCard>{
            for (final e in cachedCards.value.entries)
              e.key: e.value.deepCopy(),
          },
          onDelete: (cardId) {
            playerCards.value[name]?.removeWhere((c) => c == cardId);
            playerCards.refresh();
            cachedCards.value.remove(cardId);
            cachedCards.refresh();
          },
        ),
      },
      initialResults: switch (playerName) {
        '' => [],
        String name => [
          for (final id in (playerCards.value[name] ?? {}).toList().reversed)
            if (cachedCards.value[id] case final MtgCard card) card.deepCopy(),
        ],
      },
    );
  }
}

class _ImageSearchAlert extends StatefulWidget {
  const _ImageSearchAlert({
    required this.onSelect,
    this.initialResults = const [],
    this.cache,
  });

  final ValueChanged<MtgCard> onSelect;
  final List<MtgCard> initialResults;
  final ({Map<String, MtgCard> cachedCards, ValueChanged<String> onDelete})?
  cache;

  @override
  State<_ImageSearchAlert> createState() => _ImageSearchAlertState();
}

class _ImageSearchAlertState extends State<_ImageSearchAlert> {
  bool filterForCommanders = true;

  late TextEditingController controller;

  bool isSearching = false;

  late Map<String, MtgCard> searchableCache;

  // query to results
  Map<String, List<MtgCard>> searchResults = {};

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    searchableCache = {...?widget.cache?.cachedCards};
    controller.addListener(textListener);
  }

  @override
  void dispose() {
    controller.removeListener(textListener);
    controller.dispose();
    super.dispose();
  }

  void deleteCachedCard(String cardId) {
    if (!mounted) return;
    widget.cache?.onDelete(cardId);
    setState(() {
      searchableCache.remove(cardId);
    });
  }

  void onChangeCommandersFilter(bool value) {
    setState(() {
      filterForCommanders = value;
    });
    textListener();
  }

  void textListener() => debounceSearch(controller.text.trim());

  static const Duration debounceDuration = Duration(milliseconds: 700);

  int _debounceId = 0;
  void debounceSearch(String trimmedText) async {
    if (!mounted) return;
    if (trimmedText.isEmpty) {
      setState(() {
        isSearching = false;
      });
      return;
    }
    ++_debounceId;
    final currentSearchId = _debounceId;
    await Future.delayed(debounceDuration);
    if (!mounted) return;
    if (currentSearchId == _debounceId) {
      startSearching(trimmedText);
    }
  }

  void forceSubmitSearch(String text) {
    if (!mounted) return;
    startSearching(text.trim());
  }

  List<MtgCard> filteredCachedCards(String trimmedText) {
    if (trimmedText.isEmpty) {
      return [];
    }
    return [
      for (final cachedCard in searchableCache.values)
        if (cachedCard.name.toLowerCase().isFiltered(trimmedText.toLowerCase()))
          cachedCard,
      for (final entry in searchResults.entries)
        for (final card in entry.value)
          if (card.name.toLowerCase().isFiltered(trimmedText.toLowerCase()))
            card,
    ]..removeDuplicates();
  }

  void startSearching(String trimmedText) async {
    if (!mounted) return;
    final thisQuery = composeQuery(trimmedText);
    if (searchResults.containsKey(thisQuery)) {
      setState(() {
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    final result = await ScryfallApi.search(thisQuery);

    final List<MtgCard> foundCards = result ?? [];
    if (!mounted) return;
    setState(() {
      if (result != null) {
        searchResults[thisQuery] = foundCards;
      }
      isSearching = false;
    });
  }

  String composeQuery(String trimmedText) {
    if (filterForCommanders) {
      return '$trimmedText is:commander order:edhrec unique:art';
    } else {
      return '$trimmedText unique:art';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        final trimmedText = controller.text.trim();
        final currentQuery = composeQuery(trimmedText);

        final List<MtgCard> filteredCache = filteredCachedCards(trimmedText);

        final List<MtgCard> results = switch (trimmedText) {
          '' => widget.initialResults,
          _ => [
            ...?searchResults[currentQuery],
            ...filteredCache,
          ]..removeDuplicates(),
        };

        return PanelList.expand(
          title: Text(title),
          floatingBottom: false,
          addVerticalMarginAroundBottomChild: false,
          bottom: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ImageSearchTextField(
                onSubmitSearch: forceSubmitSearch,
                controller: controller,
              ),
              Space.vertical(layout.spacing.medium),
              ImageSearchCommanderFilterToggle(
                filterForCommanders: filterForCommanders,
                onChanged: onChangeCommandersFilter,
              ),
              Space.vertical(layout.margin.medium),
              FixedKeyboardHeight(
                builder: (context, keyboardHeight, child) =>
                    Space.vertical(keyboardHeight),
              ),
            ],
          ),
          children: <Widget>[
            AnimatedListed(
              listed: isSearching,
              child: const LinearProgressIndicator(),
            ),
            if (results.isEmpty && searchResults.containsKey(currentQuery))
              ListTile(
                leading: Icon(MdiIcons.alertOutline),
                title: Text('No results found for "$currentQuery"'),
              ),
            for (final result in results)
              CardTile(
                result,
                callback: widget.onSelect,
                trailing: switch ((
                  widget.cache?.onDelete,
                  searchableCache.containsKey(result.id),
                )) {
                  (null, _) || (_, false) => null,
                  (_, true) => IconButton(
                    icon: Icon(
                      Icons.clear_all,
                      color: context.theme.colorScheme.error,
                    ),
                    onPressed: () => deleteCachedCard(result.id),
                  ),
                },
              ),
          ],
        );
      },
    );
  }

  String get title => switch (isSearching) {
    false => filterForCommanders ? 'Commander Search' : 'Card Search',
    true => 'Searching...',
  };
}

extension on String {
  bool isFiltered(String filter) {
    String remainingText = this;
    for (final character in filter.split('')) {
      final index = remainingText.indexOf(character);
      if (index == -1) return false;
      remainingText = remainingText.substring(index + 1);
    }
    return true;
  }
}

extension on List<MtgCard> {
  void removeDuplicates() {
    final seenIds = <String>{};
    removeWhere((card) => !seenIds.add(card.id));
  }
}
