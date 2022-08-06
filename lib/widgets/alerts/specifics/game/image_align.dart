import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart'; 


class ImageAlign extends StatelessWidget {
  final String? imageUrl;
  final double aspectRatio;

  const ImageAlign(this.imageUrl, {required this.aspectRatio});

  static const double _imageSize = 120.0;
  static const double _sliderSize = 56.0;

  static const double height = PanelTitle.height + _imageSize + _sliderSize;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final settings = bloc.settings.imagesSettings;
    // final theme = Theme.of(context);
    
    return Material(
      child: SingleChildScrollView(
        physics: Stage.of(context)!.panelController.panelScrollPhysics(),
        child: settings.imageAlignments.build((_,alignments) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const PanelTitle("Image alignment"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              height: _imageSize,
              child: Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          imageUrl!,
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment(0.0,alignments[imageUrl] ?? -0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ), 
            Container(
              height: _sliderSize,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Slider(
                min: -1.0,
                max: 1.0,
                value: alignments[imageUrl] ?? -0.5,
                onChanged: (value){
                  settings.imageAlignments.value[imageUrl] = value;
                  settings.imageAlignments.refresh();
                },
              ),
            ),
          ],
        ),),
      ),
    );
  }
}

