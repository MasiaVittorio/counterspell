import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell_new/core.dart';

class AptCardImage extends StatelessWidget {

  const AptCardImage({
    required this.bloc,
    required this.name,
    required this.gameState,
    required this.gesturesApplied,
    required this.isAttacking,
    required this.isDefending,
    required this.pageColors,
    required this.defenceColor,
    required this.highlighted,
    required this.maxWidth,
  });

  final GameState? gameState;
  final String name;
  final CSBloc? bloc;
  final Widget gesturesApplied;
  final bool isAttacking;
  final bool isDefending;
  final Map<CSPage,Color?>? pageColors;
  final Color? defenceColor;
  final bool highlighted;
  final double maxWidth;

  static const double _cmdrOpacity = 0.35;

  @override
  Widget build(BuildContext context) {
    
    final player = gameState!.players[name]!;
    final bool haveB = player.havePartnerB;
    final bool useB = haveB && player.usePartnerB;
    final group = bloc!.game.gameGroup;

    return group.cardsA.build((_, cardsA) => group.cardsB.build((_, cardsB) {
      final MtgCard? cardA = cardsA[name];
      final MtgCard? cardB = haveB ? cardsB[name] : null;

      if(cardB == null && cardA == null){
        return SizedBox.expand(
          child: gesturesApplied,
        );
      } else {

        final String? urlA = cardA?.imageUrl();
        final String? urlB = cardB?.imageUrl();

        return bloc!.settings.imagesSettings.imageAlignments.build((_,alignments){
          
          final Decoration? decorationA = urlA == null 
            ? null 
            : BoxDecoration(image: DecorationImage(
              image: CachedNetworkImageProvider(
                urlA,
                // errorListener: (){},
              ),
              fit: BoxFit.cover,
              alignment: Alignment(0, alignments[urlA] ?? -0.5),
            ),);

          Widget image;

          if(haveB){
            final Decoration? decorationB = urlB == null 
              ? null 
              : BoxDecoration(image: DecorationImage(
                image: CachedNetworkImageProvider(
                  urlB,
                  // errorListener: (){},
                ),
                fit: BoxFit.cover,
                alignment: Alignment(0, alignments[urlB] ?? -0.5),
              ),);

            image = Row(
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                  width: maxWidth * (useB ? 0.25 : 0.75),
                  decoration: decorationA,
                ),
                Expanded(child: Container(
                  decoration: decorationB,
                ),),
              ],
            );
          } else {
            image =  Container(decoration: decorationA);
          }

          final ThemeData themeData = Theme.of(context);

          Color bkgColor = highlighted 
                ? themeData.canvasColor 
                : themeData.scaffoldBackgroundColor;
          
          if(isAttacking) {
            bkgColor = Color.alphaBlend(
              pageColors![CSPage.commanderDamage]!
                  .withOpacity(_cmdrOpacity),
              bkgColor,
            );
          } else if (isDefending) {
            bkgColor = Color.alphaBlend(
              defenceColor!
                  .withOpacity(_cmdrOpacity),
              bkgColor,
            );
          }

          final Widget filterColor = bloc!.settings.imagesSettings.arenaImageOpacity.build((context, double? opacity) => Container(
            color: bkgColor.withOpacity(opacity!),
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
        });
      }
    },),);
  }
}