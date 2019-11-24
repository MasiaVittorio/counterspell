import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';

class ImageOpacitySimple extends StatelessWidget {
  const ImageOpacitySimple();

  static const double height 
          = AlertTitle.height 
          + _hTile
          + _hDividers 
          + _hSlider
          + _hReset;

  static const double _hSlider = 66.0;
  static const double _hReset = 56.0;
  static const double _hDividers = 14.0;
  static const double _hTile = 100.0;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings;
    final opacity = settings.simpleImageOpacity;

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

    final Widget gradient = bloc.settings.simpleImageOpacity.build((context, double opacity) => Container(
      color: theme.canvasColor.withOpacity(opacity),
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
                  activeColor: theme.primaryColor,
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
                height: _hSlider,
                child: Section([
                  opacity.build((_,value)=>CSSlider(
                    value: value,
                    onChanged: opacity.set,
                    title: (val) => "Opacity: ${val.toStringAsFixed(2)}",
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