import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/core.dart';
import 'package:rxdart/rxdart.dart';

class ImageSearch extends StatefulWidget {
  final void Function(MtgCard) onSelect;
  final Set<MtgCard> searchableCache;
  final Set<MtgCard>? readyCache;
  final void Function(MtgCard)? readyCacheDeleter;

  const ImageSearch(
    this.onSelect, {
    super.key,
    this.searchableCache = const <MtgCard>{},
    this.readyCache = const <MtgCard>{},
    this.readyCacheDeleter,
  });

  static const double height = _slider + _insert + _results;

  static const double _insert = 46.0;
  static const double _slider = 80.0;
  static const double _results = 250.0;

  @override
  State<ImageSearch> createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  TextEditingController? controller;
  late BehaviorSubject<String> behavior;
  late StreamSubscription subscription;
  List<MtgCard> results = [];
  bool searching = false;
  bool started = false;
  bool commander = true;
  Set<MtgCard> _readyCache = <MtgCard>{};

  @override
  void initState() {
    super.initState();
    _readyCache = widget.readyCache ?? <MtgCard>{};
    controller = TextEditingController();
    behavior = BehaviorSubject<String>();
    resetResults();
    subscription = behavior.stream
        // .distinct()
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 700)))
        // .debounce(const Duration(milliseconds: 500))
        .listen(startSearching);
  }

  void startSearching(String? name) async {
    if (name == null || name == "") {
      resetResults();
      return;
    }
    setState(() {
      searching = true;
    });
    List<MtgCard>? res = await ScryfallApi.searchArts(name, commander);
    res ??= <MtgCard>[];
    res = res.sublist(0, min(20, res.length));

    if (name == controller!.text) {
      //you may have changed the text since the search was launched, we do not want these results to overwrite
      // other results that may have been found quicker
      results = res;
    }
    if (mounted) {
      setState(() {
        searching = false;
      });
    }
  }

  void resetResults() {
    if (_readyCache.isNotEmpty) {
      results = <MtgCard>[...widget.readyCache!];
    } else {
      results = <MtgCard>[];
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    behavior.close();
    controller!.dispose();
    super.dispose();
  }

  void syncronousSearch() {
    if (widget.searchableCache.isEmpty) return;

    final List<MtgCard> matches = <MtgCard>[];

    for (final cached in widget.searchableCache) {
      if (cached.name.toLowerCase().contains(controller!.text.toLowerCase())) {
        matches.add(cached);
      }
    }

    if (matches.isNotEmpty) {
      setState(() {
        results = matches;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      title,
      bottom: bottom,
      alreadyScrollableChild: true,
      child: list,
    );
  }

  Widget get bottom => SizedBox(
        height: ImageSearch._insert + ImageSearch._slider,
        child: Column(
          children: <Widget>[
            insert,
            slider,
          ],
        ),
      );

  Widget get list {
    if (results.isNotEmpty) {
      return SingleChildScrollView(
        physics: Stage.of(context)!.panelController.panelScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PanelTitle.height,
            ),
            for (final result in results)
              CardTile(
                result,
                callback: widget.onSelect,
                trailing: (widget.readyCacheDeleter != null && isCached(result))
                    ? IconButton(
                        icon:
                            const Icon(Icons.clear_all, color: CSColors.delete),
                        onPressed: () {
                          widget.readyCacheDeleter!(result);
                          setState(() {
                            _readyCache.removeWhere((c) => c.id == result.id);
                          });
                        },
                      )
                    : null,
              ),
          ],
        ),
      );
    } else {
      if (searching) return const Center(child: CircularProgressIndicator());
      return const Center(
        child: Icon(
          McIcons.cards_outline,
          size: 80,
        ),
      );
    }
  }

  bool isCached(MtgCard c) => _readyCache.any((rc) => rc.id == c.id);

  Widget get insert => Container(
        height: ImageSearch._insert,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          keyboardType: TextInputType.text,
          autofocus: true,
          onSubmitted: startSearching,
          textAlign: TextAlign.center,
          controller: controller,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(inherit: true, fontSize: 18.0),
          onChanged: (s) {
            setState(() {
              started = true;
            });
            syncronousSearch();
            behavior.add(s);
          },
          decoration: const InputDecoration(
            labelText: "Card name",
          ),
        ),
      );

  String get title => !started
      ? commander
          ? "Commander Search"
          : "Card Search"
      : searching
          ? "Searching..."
          : <int, String>{
                0: "No match found",
                1: "Perfect match"
              }[results.length] ??
              "${results.length} results";

  Widget get slider => Container(
        height: ImageSearch._slider,
        alignment: Alignment.center,
        child: RadioSlider(
          selectedIndex: commander ? 0 : 1,
          onTap: (i) => setState(() {
            commander = (i == 0);
            if (controller!.text != "") {
              behavior.add(controller!.text);
            }
          }),
          items: const [
            RadioSliderItem(
              icon: Icon(CSIcons.damageOutlined),
              selectedIcon: Icon(CSIcons.damageFilled),
              title: Text("Commanders"),
            ),
            RadioSliderItem(
              icon: Icon(McIcons.cards_outline),
              selectedIcon: Icon(McIcons.cards),
              title: Text("Any card"),
            ),
          ],
        ),
      );
}

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
