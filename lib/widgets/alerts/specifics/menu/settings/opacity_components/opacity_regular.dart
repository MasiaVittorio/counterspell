import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stage/body/group/player_tile.dart';




class ImageOpacityRegular extends StatelessWidget {
  const ImageOpacityRegular();

  static const double _hTile = 100.0;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings.imagesSettings;
    final start = settings.imageGradientStart;
    final end = settings.imageGradientEnd;

    final theme = Theme.of(context);

    final Widget image = Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(CSUris.featherArt),
          fit: BoxFit.cover,
          alignment: Alignment(0.0,0.0),
        ),
      ),
    );

    final Widget gradient = BlocVar.build2(
      start,
      end,
      builder: (context, double? startVal, double? endVal) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              theme.canvasColor.withOpacity(startVal!),
              theme.canvasColor.withOpacity(endVal!),
            ],
          ),
        ),
      ),
    );

    final lifeColor = Stage.of(context)!.themeController
        .derived.mainPageToPrimaryColor.value![CSPage.life]!;

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
                  color: Color.alphaBlend(
                    lifeColor.withOpacity(0.55),
                    theme.canvasColor,
                  ).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(CSSizes.minTileSize),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "40",
                  style: TextStyle(fontSize: 0.26 * CSSizes.minTileSize),
                ),
              ),
            ),
            const Expanded(child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
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
                activeColor: lifeColor,
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
          defaultValue: CSSettingsImages.defaultImageGradientStart,
          leading: const Icon(Icons.keyboard_arrow_left),
          titleBuilder: (val) => Text("Start: ${val.toStringAsFixed(2)}"),
        )),
        end.build((_,value) => FullSlider(
          value: value,
          onChanged: end.set,
          divisions: 20,
          defaultValue: CSSettingsImages.defaultImageGradientEnd,
          leading: const Icon(Icons.keyboard_arrow_right),
          titleBuilder: (val) => Text("End: ${val.toStringAsFixed(2)}"),
        )),
      ],
    );
  }

}