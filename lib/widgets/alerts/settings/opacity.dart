import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile.dart';

class ImageOpacity extends StatelessWidget {
  const ImageOpacity();

  static const double height 
          = AlertTitle.height 
          + _hTile
          + _hDividers 
          + _hSectionTitle 
          + _hBigSlider*2
          + _hReset;

  static const double _hBigSlider = 72.0;
  static const double _hReset = 56.0;
  static const double _hDividers = 14.0;
  static const double _hSectionTitle = 30.0;
  static const double _hTile = 100.0;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings;
    final start = settings.imageGradientStart;
    final end = settings.imageGradientEnd;

    final theme = Theme.of(context);

    final Widget image = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            "https://img.scryfall.com/cards/art_crop/front/e/4/e4a2d2c6-8eaa-4760-b620-921b807baa2e.jpg?1557577142",
            //Feather
            //TODO:better link
          ),
          fit: BoxFit.cover,
          alignment: Alignment(0.0,0.0),
        ),
      ),
    );

    final Widget gradient = BlocVar.build2(
      bloc.settings.imageGradientStart,
      bloc.settings.imageGradientEnd,
      builder: (context, double startVal, double endVal) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              theme.canvasColor.withOpacity(startVal),
              theme.canvasColor.withOpacity(endVal),
            ],
          ),
        ),
      ),
    );

    final Widget tile = InkWell(
      onTap: (){},
      child: Container(
        //to make the pan callback working, the color cannot be just null
        color: Colors.transparent,
        height: _hTile,
        alignment: Alignment.center,
        child: SizedBox(
          height: CSConstants.minTileSize,
          child: Row(children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: CSConstants.minTileSize,
              height: CSConstants.minTileSize,
              child: Container(
                width: CSConstants.minTileSize*PlayerTile.circleFrac,
                height: CSConstants.minTileSize*PlayerTile.circleFrac,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(CSConstants.minTileSize),
                ),
                alignment: Alignment.center,
                child: Text(
                  "40",
                  style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 0.26 * CSConstants.minTileSize),
                ),
              ),
            ),
            Expanded(child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Example",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),),
            Container(
              alignment: Alignment.center,
              width: CSConstants.minTileSize,
              height: CSConstants.minTileSize,
              child: Checkbox(
                onChanged: (_){},
                value: true,
              ),
            ),
          ]),
        ),
      ),
    );

    final Widget playerTile = SizedBox(
      height: _hTile,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: image,
          ),
          Positioned.fill(
            child: gradient,
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: Theme(
                data: theme.copyWith(splashColor: Colors.white.withAlpha(0x66)),
                child: tile,
              ),
            ),
          ),
        ],
      ),
    );

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SizedBox(
        height: height,
        child: SingleChildScrollView(
          physics: Stage.of(context).panelScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: AlertTitle.height + _hTile + _hDividers,
                child: Section([
                  const AlertTitle("Commander image opacity"),
                  playerTile,
                ]),
              ),
              SizedBox(
                height: _hBigSlider*2 + _hSectionTitle,
                child: Section([
                  const SectionTitle("Opacity values"),
                  start.build((_,value)=>CSSlider(
                    value: value,
                    onChanged: start.set,
                    title: (val) => "Start: ${val.toStringAsFixed(2)}",
                  )),
                  end.build((_,value)=>CSSlider(
                    value: value,
                    onChanged: end.set,
                    title: (val) => "End: ${val.toStringAsFixed(2)}",
                  )),
                ], last: true),
              ),
              SizedBox(
                height: _hReset,
                child: ListTile(
                  title: const Text("Reset"),
                  leading: const Icon(McIcons.restart),
                  onTap: (){
                    settings.imageGradientEnd.set(CSSettings.defaultImageGradientEnd);
                    settings.imageGradientStart.set(CSSettings.defaultImageGradientStart);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // bool operator ==(Object other) => other.runtimeType == this.runtimeType;
  // @override
  // int get hashCode => super.hashCode;

}