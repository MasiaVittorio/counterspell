import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/game/image_search/components/card_tile.dart';
import 'package:counter_spell/widgets/alerts/specifics/game/image_search/components/image_search_commander_filter_toggle.dart';
import 'package:counter_spell/widgets/alerts/specifics/game/image_search/components/image_search_text_field.dart';

class ImageSearchAlert extends StatelessWidget {
  const ImageSearchAlert({
    super.key,
    required this.onSelect,
    this.playerName = '',
  });

  final ValueChanged<MtgCard> onSelect;
  final String playerName;
  static const double height = sliderHeight + insertHeight + resultsHeight;

  static const double insertHeight = 46.0;
  static const double sliderHeight = 80.0;
  static const double resultsHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;

    return _ImageSearchAlert(
      onSelect: onSelect,
      cache: switch (playerName) {
        '' => null,
        String name => (
          cachedCards: <String, MtgCard>{
            for (final playerCards in group.savedCards.value.values)
              for (final card in (playerCards ?? <MtgCard>[])) card.id: card,
          },
          onDelete: (cardId) {
            group.savedCards.value[name]!.removeWhere((c) => c.id == cardId);
            group.savedCards.refresh(key: name);
          },
        ),
      },
      initialResults: switch (playerName) {
        '' => [],
        String name => [...?group.savedCards.value[name]],
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
      return "$trimmedText is:commander order:edhrec";
    } else {
      return trimmedText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      title,
      alreadyScrollableChild: true,
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ImageSearchTextField(
            onSubmitSearch: forceSubmitSearch,
            controller: controller,
          ),
          ImageSearchCommanderFilterToggle(
            filterForCommanders: filterForCommanders,
            onChanged: onChangeCommandersFilter,
          ),
        ],
      ),
      child: ValueListenableBuilder(
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

          return ListView(
            physics: Stage.of(context)!.panelController.panelScrollPhysics(),
            children: <Widget>[
              AnimatedListed(
                listed: isSearching,
                child: LinearProgressIndicator(),
              ),
              if (results.isEmpty && searchResults.containsKey(currentQuery))
                ListTile(
                  leading: Icon(McIcons.alert_outline),
                  title: Text("No results found for \"$currentQuery\""),
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
                      icon: const Icon(Icons.clear_all, color: CSColors.delete),
                      onPressed: () => deleteCachedCard(result.id),
                    ),
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  String get title => switch (isSearching) {
    false => filterForCommanders ? "Commander Search" : "Card Search",
    true => "Searching...",
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
