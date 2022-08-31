import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';

class CardAlert extends StatefulWidget {
  final MtgCard card;

  const CardAlert(this.card);

  @override
  State<CardAlert> createState() => _CardAlertState();
}

class _CardAlertState extends State<CardAlert> {
  bool firstFace = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: (){
          if(widget.card.isFaced){
            setState((){
              firstFace = !firstFace;
            });
          }
        },
        child: SingleChildScrollView(
          physics: Stage.of(context)!.panelScrollPhysics,
          child: AspectRatio(
            aspectRatio: MtgCard.cardAspectRatio,
            child: CachedNetworkImage(
              errorWidget: (_,__,___) => const Center(child: Icon(Icons.error_outline)),
              imageUrl: widget.card.imageUrl(faceIndex: firstFace ? 0 : 1, uri: ImageUris.BORDERCROP)!,
              placeholder: (_,__) => const Center(child: CircularProgressIndicator()),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}