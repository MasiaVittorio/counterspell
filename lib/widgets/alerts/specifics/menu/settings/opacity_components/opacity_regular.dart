import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/group/player_tile.dart';




class ImageOpacityRegular extends StatelessWidget {
  const ImageOpacityRegular();

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
          image: CachedNetworkImageProvider(CSUris.featherArt),
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
          height: CSSizes.minTileSize,
          child: Row(children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: CSSizes.minTileSize,
              height: CSSizes.minTileSize,
              child: Container(
                width: CSSizes.minTileSize*PlayerTile.circleFrac,
                height: CSSizes.minTileSize*PlayerTile.circleFrac,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(CSSizes.minTileSize),
                ),
                alignment: Alignment.center,
                child: Text(
                  "40",
                  style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 0.26 * CSSizes.minTileSize),
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
              width: CSSizes.minTileSize,
              height: CSSizes.minTileSize,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        playerTile,
        const SizedBox(height: 8,),
        start.build((_,value) => FullSlider(
          value: value,
          onChanged: start.set,
          divisions: 20,
          defaultValue: CSSettings.defaultImageGradientStart,
          leading: Icon(Icons.keyboard_arrow_left),
          titleBuilder: (val) => Text("Start: ${val.toStringAsFixed(2)}"),
        )),
        end.build((_,value) => FullSlider(
          value: value,
          onChanged: end.set,
          divisions: 20,
          defaultValue: CSSettings.defaultImageGradientEnd,
          leading: Icon(Icons.keyboard_arrow_right),
          titleBuilder: (val) => Text("End: ${val.toStringAsFixed(2)}"),
        )),
      ],
    );
  }

}