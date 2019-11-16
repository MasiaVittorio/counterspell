import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';
import 'package:rxdart/rxdart.dart';

class ImageSearch extends StatefulWidget {

  final void Function(MtgCard) onSelect;
  final Set<MtgCard> searchableCache;
  final Set<MtgCard> readyCache;

  const ImageSearch(this.onSelect, {
    this.searchableCache = const <MtgCard>{},
    this.readyCache = const <MtgCard>{},
  });

  static const double height = _slider + _insert + _results;

  static const double _insert = 46.0;
  static const double _slider = 80.0;
  static const double _results = 250.0;

  @override
  _ImageSearchState createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {

  TextEditingController controller;
  BehaviorSubject<String> behavior;
  StreamSubscription subscription;
  List<MtgCard> results = [];
  bool searching = false;
  bool started = false;
  bool commander = true;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    behavior = BehaviorSubject<String>();
    resetResults();
    subscription = behavior.stream
        // .distinct()
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 500)))
        // .debounce(const Duration(milliseconds: 500))
        .listen((name) async {
          if(name == null || name ==  ""){
            resetResults();
            return;
          }
          this.setState((){
            this.searching = true;
          });
          List<MtgCard> res = await ScryfallApi.searchArts(name, commander);
          if(res == null){
            res = <MtgCard>[];
            print("results were null lol, error that should not happen");
          } 
          res = res.sublist(0,min(20, res.length));
          this.results = res;
          this.setState((){
            this.searching = false;
          });
        });
  }

  void resetResults(){
    if(widget.readyCache != null && widget.readyCache.isNotEmpty){
      results = widget.readyCache.toList();
    } else {
      results = <MtgCard>[];
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    behavior.close();
    controller.dispose();
    super.dispose();
  }

  void syncronousSearch(){
    if(widget.searchableCache == null) return;
    if(widget.searchableCache.isEmpty) return;

    final List<MtgCard> matches = <MtgCard>[];

    for(final cached in widget.searchableCache){
      if(cached.name.toLowerCase().contains(controller.text.toLowerCase())){
        matches.add(cached);
      }
    }

    if(matches.isNotEmpty){
      this.setState((){
        this.results = matches;
      });
    }
  }
  
  @override
  Widget build(BuildContext context){
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SizedBox(
        height: ImageSearch.height,
        child: Stack(children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: ImageSearch._insert + ImageSearch._slider,
            child: list,
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: theme.scaffoldBackgroundColor.withOpacity(0.7),
              child: title
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: UpShadower(child: SizedBox(
              height: ImageSearch._insert + ImageSearch._slider,
              child: Column(children: <Widget>[
                insert,
                slider,
              ],),
            )),
          ),
        ],),
      ),
    );
  }

  Widget get list {
    if (results.isNotEmpty) {
      return SingleChildScrollView(
        physics: Stage.of(context).panelScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: AlertTitle.height,),
            for(final result in results)
              CardTile(result, callback: widget.onSelect),
          ],
        ),
      );
    } else {
      if(searching) return Center(child: CircularProgressIndicator());
      return Center(child: Icon(McIcons.cards_outline, size: 80,),);
    }
  }

  Widget get insert => Container(
    height: ImageSearch._insert,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: TextField(
      keyboardType: TextInputType.text,
      autofocus: true,
      textAlign: TextAlign.center,
      // maxLength: 30,
      controller: controller,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(inherit:true, fontSize: 18.0),
      onChanged: (s){
        this.setState((){
          this.started = true;
        });
        this.syncronousSearch();
        this.behavior.add(s);
      },
      decoration: InputDecoration(
        labelText: "Card name",
      ),
    ),
  );

  Widget get title => AlertTitle(
    !this.started 
      ? this.commander ? "Commander Search" : "Card Search"
      : this.searching 
        ? "Searching..."
        : <int,String>{
          0:"No match found",
          1:"Perfect match"
        }[this.results.length] ?? "${this.results.length} results"
  );

  Widget get slider => Container(
    height: ImageSearch._slider,
    alignment: Alignment.center,
    child: RadioSlider(
      selectedIndex: commander ? 0 : 1,
      onTap: (i)=>this.setState((){
        commander = (i == 0);
        if(controller.text!=""){
          this.behavior.add(this.controller.text);
        }
      }),
      items: [
        RadioSliderItem(
          icon: Icon(CSTypesUI.damageIconOutlined),
          selectedIcon: Icon(CSTypesUI.damageIconFilled),
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
  final void Function(MtgCard) callback;
  final Widget trailing;
  final bool autoClose;

  const CardTile(this.card,{
    @required this.callback,
    this.trailing,
    this.autoClose=true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(card.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing,
      leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(card.imageUrl(),),),
      onTap: (){
        callback(card);
        if(this.autoClose??true) Stage.of(context).panelController.closePanel();
      },
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.brush, size: 15.0),
          Expanded(child: Text(card.artist, overflow: TextOverflow.ellipsis, maxLines: 1,),),
        ],
      ),
    );
  }
}