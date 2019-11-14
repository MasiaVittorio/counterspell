import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';
import 'package:rxdart/rxdart.dart';

class ImageSearch extends StatefulWidget {

  final void Function(MtgCard) onSelect;

  const ImageSearch(this.onSelect);

  static const double height = _slider + _insert + _results;

  static const double _insert = 72.0;
  static const double _slider = 72.0;
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
    subscription = behavior.stream
        .distinct()
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 500)))
        .listen((name) async {
          this.results = await ScryfallApi.searchArts(name);
          this.setState((){});
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    behavior.close();
    controller.dispose();
    results.clear();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) 
    => Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        height: ImageSearch.height,
        child: Stack(children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            height: ImageSearch._results,
            child: list,
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: title,
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: UpShadower(child: SizedBox(
              height: ImageSearch._insert + ImageSearch._slider,
              child: Column(children: <Widget>[
                slider,
                insert,
              ],),
            )),
          ),
        ],),
      ),
    );

  Widget get list => results.isNotEmpty ? SingleChildScrollView(
    physics: Stage.of(context).panelScrollPhysics(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for(final result in results)
          CardTile(result, callback: widget.onSelect),
      ],
    ),
  ) : Center(child: Icon(McIcons.cards_outline, size: 80,),);

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
        this.behavior.add(s);
      },
      decoration: InputDecoration(
        hintText: "Card name",
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
      }),
      items: [
        RadioSliderItem(
          icon: Icon(CSTypesUI.damageIconOutlined),
          selectedIcon: Icon(CSTypesUI.damageIconFilled),
          title: Text("Only commanders"),
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

  const CardTile(this.card,{
    @required this.callback,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(card.name),
      trailing: trailing,
      leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(card.imageUrl(),),),
      onTap: (){
        callback(card);
        Stage.of(context).panelController.closePanel();

      },
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if( card.name != "")
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: const Icon(Icons.brush, size: 15.0),
            ),
          Text("By: " + card.artist),
        ],
      ),
    );
  }
}