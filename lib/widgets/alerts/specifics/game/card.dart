import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';

class CardAlert extends StatefulWidget {
  final MtgCard card;

  const CardAlert(this.card);

  @override
  _CardAlertState createState() => _CardAlertState();
}

class _CardAlertState extends State<CardAlert> {
  bool firstFace = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.card.isFaced){
          this.setState((){
            firstFace = !firstFace;
          });
        }
      },
      child: SingleChildScrollView(
        physics: Stage.of(context)!.panelScrollPhysics,
        child: AspectRatio(
          aspectRatio: MtgCard.cardAspectRatio,
          child: CachedNetworkImage(
            errorWidget: (_,__,___) => Center(child: Icon(Icons.error_outline)),
            imageUrl: widget.card.imageUrl(faceIndex: firstFace ? 0 : 1, uri: "borderCrop")!,
            placeholder: (_,__) => Center(child: CircularProgressIndicator()),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}