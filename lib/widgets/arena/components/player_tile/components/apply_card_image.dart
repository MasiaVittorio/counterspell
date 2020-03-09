import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';

class AptCardImage extends StatelessWidget {

  AptCardImage({
    @required this.bloc,
    @required this.name,
    @required this.gameState,
    @required this.gesturesApplied,
    @required this.isAttacking,
    @required this.isDefending,
    @required this.pageColors,
    @required this.defenceColor,
    @required this.highlighted,
  });

  final GameState gameState;
  final String name;
  final CSBloc bloc;
  final Widget gesturesApplied;
  final bool isAttacking;
  final bool isDefending;
  final Map<CSPage,Color> pageColors;
  final Color defenceColor;
  final bool highlighted;

  static const double _cmdrOpacity = 0.35;

  @override
  Widget build(BuildContext context) {

    return bloc.game.gameGroup.cards(!this.gameState.players[name].usePartnerB).build((_, cards){
      final MtgCard card = cards[name];

      if(card == null){

        return SizedBox.expand(
          child: gesturesApplied,
        );

      } else {

        final ThemeData themeData = Theme.of(context);
        final String imageUrl = card.imageUrl();

        final Widget image = bloc.settings.imageAlignments.build((_,alignments) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                imageUrl,
                errorListener: (){},
              ),
              fit: BoxFit.cover,
              alignment: Alignment(0,alignments[imageUrl] ?? -0.5),
            ),
          ),
        ),);

        Color bkgColor = highlighted 
              ? themeData.canvasColor 
              : themeData.scaffoldBackgroundColor;
        
        if(isAttacking) {
          bkgColor = Color.alphaBlend(
            this.pageColors[CSPage.commanderDamage]
                .withOpacity(_cmdrOpacity),
            bkgColor,
          );
        } else if (isDefending) {
          bkgColor = Color.alphaBlend(
            this.defenceColor
                .withOpacity(_cmdrOpacity),
            bkgColor,
          );
        }

        final Widget filterColor = bloc.settings.simpleImageOpacity.build((context, double opacity) => Container(
          color: bkgColor.withOpacity(opacity),
        ));

        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: image,
            ),
            Positioned.fill(
              child: filterColor,
            ),
            Theme(
              data: themeData.copyWith(splashColor: Colors.white.withAlpha(0x66)),
              child: gesturesApplied,
            ),
          ],
        );
      }
    },);
  }
}