import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';

class ImageOpacitySimple extends StatelessWidget {
  const ImageOpacitySimple();

  static const double _hTile = 140.0;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final settings = bloc.settings.imagesSettings;
    final opacity = settings.arenaImageOpacity;

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

    final Widget gradient = opacity.build((context, double? opacity) => Container(
      color: theme.canvasColor.withOpacity(opacity!),
    ));

    final Widget tile = InkWell(
      onTap: (){},
      child: Container(
        //to make the pan callback working, the color cannot be just null
        color: Colors.transparent,
        height: _hTile,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Checkbox(
                  activeColor: Stage.of(context)!.themeController
                    .derived.mainPageToPrimaryColor.value![CSPage.life],
                  value: true,
                  tristate: true,
                  onChanged: (b) {},
                ),
                Text("Example", style: TextStyle(
                  fontSize: 16,
                ),),
              ],
            ),
            Expanded(child: Center(
              child: Text(
                "40",
                style: TextStyle(
                  fontSize: _hTile*0.4,
                ),
              )
            ),),
          ],
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
        opacity.build((_,value) => FullSlider(
          value: value,
          divisions: 20,
          leading: Icon(Icons.opacity),
          onChanged: opacity.set,
          defaultValue: CSSettingsImages.defaultSimpleImageOpacity,
          titleBuilder: (val) => Text("Opacity: ${val.toStringAsFixed(2)}"),
        )),
      ],
    );
  }

  // @override
  // bool operator ==(Object other) => other.runtimeType == this.runtimeType;
  // @override
  // int get hashCode => super.hashCode;

}